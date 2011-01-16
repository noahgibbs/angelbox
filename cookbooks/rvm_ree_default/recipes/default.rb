#
# Cookbook Name:: rvm_ree_default
# Recipe:: default
#
# Copyright 2010, Matthias Marschall
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

# see: http://li109-47.members.linode.com/blog/
package "curl"
package "git-core"

include_recipe "build"

%w(libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev).each do |pkg|
  package pkg
end

bash "install RVM" do
  user "root"
  code "bash < <( curl -L http://bit.ly/rvm-install-system-wide )"
  only_if { `which rvm`.chomp == "" }
end

cookbook_file "/etc/profile.d/rvm.sh" do
  owner "root"
  group "root"
  mode "0755"
end

bash "install REE in RVM" do
  user "root"
  code "rvm install ree"
  not_if "rvm list | grep ree"
end

bash "make REE the default ruby" do
  user "root"
  code "rvm --default ree"
  not_if { `rvm info | grep 'ruby:' | grep ree`.length > 0 }
end

# re-install the chef gem into REE to enable subsequent chef-client runs
gem_package "chef"
