
directory node[:railsframe][:dir] do
  owner node[:railsframe][:user]
  group node[:railsframe][:group]
  recursive true
end

unless node[:railsframe][:apps].respond_to?(:each)
  raise "railsframe[:apps] must be Array of Hash (1})!"
end

node[:railsframe][:apps].each do |app|
  raise "railsframe[:apps] must be Array of Hash!" unless app.kind_of?(Hash)

  if app[:github]
    app[:github] = app[:github].gsub(/\.git$/, "")
    app[:git] = "git://github.com/#{node[:railsframe][:github_user]}/#{app[:github]}.git"
    app[:name] ||= app[:github]
  end

  project = app[:dir] || app[:name]
  dir = "#{node[:railsframe][:dir]}/#{project}"
  if app[:git]
    git dir do
      action :sync
      repository app[:git]
      user node[:railsframe][:user]
      group node[:railsframe][:group]
    end
  else
    raise "Couldn't find a git repository!"
  end

  directory "#{dir}/tmp" do
    owner node[:railsframe][:user]
    group node[:railsframe][:group]
  end

  bash "bundler installation" do
    code "bundle install"
    cwd dir
    only_if { File.exist? "#{dir}/Gemfile" }
  end

  bash "passenger restart" do
    code "touch tmp/restart.txt"
    cwd dir
  end
end
