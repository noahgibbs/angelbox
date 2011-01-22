# Cookbook Name:: angelbox
# Recipe:: default
# Author:: Noah Gibbs <noah_gibbs@yahoo.com>
#
# Copyright 2010, Noah Gibbs
#
# Licensed under Creative Commons 0 (CC0) license.  This
# is essentially a public domain license - do as thou wilt.
#

# Needed for setting passwords
require_recipe "ruby-shadow"

# Outdated information sometimes means packages won't install - update
require_recipe "apt"

# Make sure we've got all the good Ruby basics (these should be no-ops by
# now):
apt_package "build-essential"
apt_package "bison"
apt_package "openssl"
apt_package "libreadline6"
apt_package "libreadline6-dev"
apt_package "curl"
apt_package "zlib1g-dev"
apt_package "libssl-dev"
apt_package "libyaml-dev"
apt_package "libsqlite3-dev"
apt_package "sqlite3"
apt_package "libxml2-dev"
#apt_package "libxslt-dev"
apt_package "autoconf"
apt_package "libc6-dev"
apt_package "git-core"

group "www"

user "www" do
  gid "www"
  home "/home/www"
  shell "/bin/bash"
  password "$1$fkGAAO8e$S4Ul9tukFOf1iEU5k8nYK."
end

directory "/home/www" do
  owner "www"
  group "www"
end

# includes build-essential, for gems with native extensions
require_recipe "build"

# Install RVM and Ruby Enterprise Edition
#require_recipe "rvm_ree_default"

group "rvm" do
  members ['www']
end

require_recipe "passenger_nginx"

###########
# Install MySQL stuff.  This belongs in a separate recipe
package "libmysqlclient-dev"
###########
# Install SQLite stuff.  This belongs in a separate recipe
package "sqlite3"
package "libsqlite3-dev"
###########

directory "/home/www/checkouts" do
  owner "www"
  group "www"
end

# Development gems
gem_package "bundler"

[ "www_static", "webconf" ].each do |project|
  git "/home/www/checkouts/#{project}" do
    action :sync
    repository "git://github.com/noahgibbs/#{project}.git"
    user "www"
    group "www"
  end

  directory "/home/www/checkouts/#{project}/tmp" do
    owner "www"
    group "www"
  end

  bash "bundler installation" do
    code "bundle install"
    cwd "/home/www/checkouts/#{project}"
    only_if { File.exist? "/home/www/checkouts/#{project}/Gemfile" }
  end

  bash "passenger restart" do
    code "touch tmp/restart.txt"
    cwd "/home/www/checkouts/#{project}"
  end
end

#template "/etc/nginx/sites-available/www_static" do
#  owner "root"
#  group "root"
#  mode "0755"
#end

#nginx_site "www_static" do
#  enabled true
#end
