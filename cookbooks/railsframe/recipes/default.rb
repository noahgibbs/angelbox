
directory node[:railsframe][:dir] do
  owner node[:railsframe][:user]
  group node[:railsframe][:group]
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

  if app[:git]
    project = app[:dir] || app[:name]
    git "#{node[:railsframe][:dir]}/#{project}" do
      action :sync
      repository app[:git]
      user node[:railsframe][:user]
      group node[:railsframe][:group]
    end
  else
    raise "Couldn't find a git repository!"
  end

end
