require "rubygems"
require "json"

rightscale_marker :begin

node[:web_app] = JSON.parse(node[:web_app_config])

RightScale::Repo::GitSshKey.new.create(node[:repo][:default][:credential], node[:repo][:default][:credential] )


log "===> Cloning resource"
git "/home/webapps/#{node[:web_app][:application]}" do
  repository node[:web_app][:git_repository]
  reference node[:web_app][:git_revision]
  enable_submodules node[:web_app][:submodule_init]
  action :sync
end

template "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/config/parameters.yml" do
  source "parameters.yml.erb"
  mode "0644"
  variables(
    :hostname => node[:web_app][:database][:hostname],
    :username => node[:web_app][:database][:username],
    :password => node[:web_app][:database][:password],
    :redis_hostname => node[:symfony][:redis][:hostname],
    :schema_name => node[:web_app][:database][:schema_name]
  )
end

execute "composer_install" do
  cwd "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}"
  command "chmod -R 777 /home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}/vendors"
  command "php composer.phar install"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}composer.phar") }
  action :run
end

execute "clear_cache" do
  cwd "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}"
  command "app/console cache:clear --env=prod"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/console") }
  action :run
end

rightscale_marker :end
