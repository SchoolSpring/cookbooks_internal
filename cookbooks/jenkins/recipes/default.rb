#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2012, RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
rightscale_marker :begin

case node[:platform]
when "centos","redhat"
  include_recipe "jenkins::install_redhat"
when "ubuntu", "debian"
  include_recipe "jenkins::install_ubuntu"
when "suse"
  include_recipe "jenkins::install_suse"
end

rightscale_marker :end
