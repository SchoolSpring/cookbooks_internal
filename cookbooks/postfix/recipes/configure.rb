rightscale_marker :begin

package "opendkim"

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  variables(
    :destinations => node[:postfix][:destinations],
    :networks => node[:postfix][:networks]
  )
end

cookbook_file "/etc/opendkim.conf" do
  source "opendkim.conf"
  mode "0644"
end

directory "/etc/mail" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  not_if { File.exists?("/etc/mail") }
end

template "/etc/mail/dkim.key" do
  source "dkim.key.erb"
  variables(
    :key => node[:postfix][:dkim_key]
  )
end

service "opendkim" do
  action :start
end

directory node[:postfix][:deploy_dir] do
  owner "nobody"
  group "root"
  mode 00755
  action :create
end

directory "#{node[:postfix][:deploy_dir]}/temp" do
  owner "postfix"
  group "root"
  mode 00755
  action :create
end

template "#{node[:postfix][:deploy_dir]}/datasource.pl" do
  source "datasource.pl.erb"
  variables(
    :gc_username => node[:postfix][:gc_username],
    :gc_password => node[:postfix][:gc_password],
    :database_name => node[:postfix][:db_name],
    :database_hostname => node[:postfix][:db_host],
    :database_username => node[:postfix][:db_user],
    :database_password => node[:postfix][:db_pass]
  )
end

bash 'postaliases' do
  code "postalias /etc/aliases"
  not_if { File.exists?("/etc/aliases.db") }
end

rightscale_marker :end
