rightscale_marker :begin

package "htmldoc"

cookbook_file "#{node[:coldfusion][:jar_dir]}/jedis-2.1.0.jar" do
 source 'jedis-2.1.0.jar'
 owner 'root'
 group 'root'
 mode 00644
end

bash 'extract_module' do
  cwd "/tmp"
  code <<-EOH
    wget #{node[:coldfusion][:commons_url]}
    tar xzf #{node[:coldfusion][:tarball]}
    cp commons-pool-1.6/commons-pool-1.6.jar #{node[:coldfusion][:jar_dir]}
    EOH
  not_if { File.exists?("#{node[:coldfusion][:jar_dir]}/commons-pool-1.6.jar") }
end

cookbook_file "#{node[:coldfusion][:jar_dir]}/JLinkPointTxn.jar" do
  source "JLinkPointTxn.jar"
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "#{node[:coldfusion][:jar_dir]}/twitter4j-core-3.0.5.jar" do
  source "twitter4j-core-3.0.5.jar"
  mode 0755
  owner "root"
  group "root"
end

rightscale_marker :end
