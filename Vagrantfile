require File.join(File.dirname(__FILE__), "railsframe_infrastructure")
require File.join(File.dirname(__FILE__), "RailsFrame")

Vagrant::Config.run do |config|
  railsframe_dir = "/src/railsframe"
  RailsFrame.get_config.vagrant = config

  # First, load default configuration
  config.vm.box = "base"
  config.vm.box_url = "http://file.vagrantup.com/lucid32.box"

  config.vm.provisioner = :chef_solo
  #config.chef.recipe_url = ""
  config.chef.cookbooks_path = ["cookbooks"]
  config.chef.add_recipe "angelbox"
  config.chef.add_recipe "railsframe"
  #config.chef.add_role "devbox"

  # Then, get RailsFrame configuration
  RailsFrame.get_config.execute

  # Finally, configure based on RailsFrame parameters
  config.vm.forward_port "http", 80, RailsFrame.get_config.get_port

  config.chef.json[:railsframe] = {
    :dir => railsframe_dir,
    #:user => "www",
    #:group => "www",
    :apps => [],
  }

  RailsFrame.get_config.apps.each do |app|
    if(app.get_mounted)
      config.vm.share_folder("#{app.app_name}-mount",
                             "#{railsframe_dir}/#{app.app_name}",
                             app.get_mounted)
    end

    config.chef.json[:railsframe][:apps] << app.to_hash
  end
end
