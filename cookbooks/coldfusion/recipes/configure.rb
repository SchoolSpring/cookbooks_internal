rightscale_marker :begin

template "/opt/jrun4/servers/cfusion/cfusion-ear/cfusion-war/cfadmin.cfm" do
  source "cfadmin.cfm.erb"
  variables(
    :cf_admin_pass => node[:coldfusion][:admin_password],
    :hostname => node[:coldfusion][:db][:hostname],
    :db_user => node[:coldfusion][:db][:username],
    :db_pass => node[:coldfusion][:db][:password],
    :master_schema => node[:coldfusion][:db][:master_schema],
    :multi_schema => node[:coldfusion][:db][:multi_schema],
    :status_schema => node[:coldfusion][:db][:status_schema]
  )
end

include_recipe "coldfusion::start"

ruby_block "run admin api" do
  block do
    system "curl localhost:8000/cfadmin.cfm"
    system "/opt/jrun4/bin/wsconfig -server cfusion -ws Apache -dir /etc/apache2 -bin /usr/sbin/apache2 -script /usr/sbin/apache2ctl -coldfusion -v"
    unless open('/etc/apache2/apache2.conf') { |f| f.grep(/Include httpd.conf/) }
      system "echo 'Include httpd.conf' >> /etc/apache2/apache2.conf"
    end
  end
end

include_recipe "web_apache::do_restart"
include_recipe "coldfusion::restart"

rightscale_marker :end

