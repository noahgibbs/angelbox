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

# Outdated information sometimes means package won't install
require_recipe "apt"

# includes build-essential, for gems with native extensions
require_recipe "build"

# Install RVM and Ruby Enterprise Edition
require_recipe "rvm_ree_default"

require_recipe "passenger_nginx"

directory "/home/www/checkouts" do
  owner "www"
  group "www"
end

# Development gems
gem_package "bundler"

[ "blog", "www_static", "refactor_it", "wantmyjob.com", "webconf",
  "cheaptoad-catcher" ].each do |project|
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
    command "bundle install"
    cwd "/home/www/checkouts/#{project}"
  end

  bash "passenger restart" do
    command "touch tmp/restart.txt"
    cwd "/home/www/checkouts/#{project}"
  end

end
