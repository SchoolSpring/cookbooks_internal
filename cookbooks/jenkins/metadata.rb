maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures jenkins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


depends "rightscale"
depends "rightscale_services_tools"
depends "sys_firewall"
depends "sysctl"
