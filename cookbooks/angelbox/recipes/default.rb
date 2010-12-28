# Cookbook Name:: angelbox
# Recipe:: default
# Author:: Noah Gibbs <noah_gibbs@yahoo.com>
#
# Copyright 2010, Noah Gibbs
#
# Licensed under Creative Commons 0 (CC0) license.  This
# is essentially a public domain license - do as thou wilt.
#

# Outdated information sometimes means package won't install
require_recipe "apt"

# Needed for setting passwords
require_recipe "ruby-shadow"

# includes build-essential, for gems with native extensions
require_recipe "build"

# Install RVM and Ruby Enterprise Edition
require_recipe "rvm_ree_default"

require_recipe "passenger_nginx"

group "www"

user "www" do
  action :create
  gid "www"
  password "$1$fkGAAO8e$S4Ul9tukFOf1iEU5k8nYK."
end

directory "/home/www/checkouts"

[ "blog", "www_static", "refactor_it", "wantmyjob.com", "webconf",
  "cheaptoad-catcher" ].each do |project|
  git "/home/www/checkouts/#{project}" do
    action :sync
    repository "git@github.com:noahgibbs#{project}.git"
    user "www"
    group "www"
  end
end
