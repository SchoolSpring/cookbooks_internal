maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Installs/configures a MySQL database client and server."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "12.1.0"

supports "centos", "~> 5.8"
supports "redhat", "~> 5.8"
supports "ubuntu", "~> 10.04.0"

depends "db"
depends "block_device"
depends "sys_dns"
depends "rightscale"
depends "aria2"
depends "sysctl"
depends "sys_firewall"

recipe  "db_oracle::default", "Set the DB MySQL provider. Sets version and node variables specific to the chosen MySQL version."

attribute "db_oracle",
  :display_name => "General Database Options",
  :type => "hash"

# == Default attributes
#
attribute "oracle/server/private_ip",
    :display_name => "Server Private Ip",
    :description => "Server Private IP.  Use env:PRIVATE_IP/Oracle Server ", 
    :recipes => [ "db_oracle::default" ],
    :required => "required"

attribute "oracle/install_file1_url", 
  :display_name => "Oracle Install ZipFile 1",
  :description => "Url to the oracle zip file", 
  :required => "optional", 
  :default => "http://ps-cf.rightscale.com/oracle/linux.x64_11gR2_database_1of2.zip",
  :recipes => [ "db_oracle::default" ]

attribute "oracle/install_file2_url",
  :display_name => "Oracle Install ZipFile 2",
  :description => "Url to the oracle zip file",
  :required => "optional",
  :default => "http://ps-cf.rightscale.com/oracle/linux.x64_11gR2_database_2of2.zip",
  :recipes => [ "db_oracle::default" ]

