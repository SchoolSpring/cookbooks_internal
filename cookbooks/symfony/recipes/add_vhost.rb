require "rubygems"
require "json"

rightscale_marker :begin

node[:web_app] = JSON.parse(node[:web_app_config])

log "===> Cloning resource"
git "/home/webapps/#{node[:web_app][:application]}" do
  repository node[:web_app][:git_repository]
  reference node[:web_app][:git_revision]
  enable_submodules node[:web_app][:submodule_init]
  action :sync
  notifies :run, "execute[composer_install]", :immediately
  notifies :run, "execute[clear_cache]"
end

node[:web_app][:templates].each do |key, value|
  if value[:htpasswd]
    htpasswd node[:web_app][:application], node[:web_app][:htpasswd][:username], node[:web_app][:htpasswd][:passwd]
  end
  template "/home/webapps/#{node[:web_app][:application]}/Symfony2/app/config/parameters.yml" do
    source "parameters.yml.erb"
    variables(
      :hostname => node[:web_app][:database][:hostname],
      :username => node[:web_app][:database][:username],
      :password => node[:web_app][:database][:password],
      :schema_name => node[:web_app][:database][:schema_name]
    )
  end
end

def htpasswd(application, username, password)
  command "htpasswd /home/webapps/#{application}/.htpasswd #{username} #{password}"
end

log "===> Creating vhost"
template "/etc/apache2/sites-available/#{node[:web_app][:application]}.conf" do
  source "vhost.conf.erb"
  variables(
    :hostname => node[:web_app][:hostname],
    :application => node[:web_app][:application],
    :web_root => node[:web_app][:web_root]
  )
end

link "/etc/apache2/sites-available/#{node[:web_app][:application]}.conf" do
  to "/etc/apache2/sites-enabled/#{node[:web_app][:application]}.conf"
  notifies :reload, "service[apache]"
end

execute "composer_install" do
  cwd "/home/webapps/#{node[:web_app][:application]}"
  command "php composer.phar install"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}/composer.phar") }
  action :nothing
end

execute "clear_cache" do
  cwd "/home/webapps/#{node[:web_app][:application]}"
  command "app/console cache:clear"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}/app/console") }
  action :nothing
end

rightscale_marker :end
