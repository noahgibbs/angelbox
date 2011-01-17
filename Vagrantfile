Vagrant::Config.run do |config|
  config.vm.box = "base"
  config.vm.box_url = "http://file.vagrantup.com/lucid32.box"

  config.vm.forward_port "http", 80, 4444

  # config.vm.share_folder("v-data", "/vagrant_data", "../data")

  # For debugging, opens a window when running
  #config.vm.boot_mode = :gui

  config.vm.provisioner = :chef_solo
  #config.chef.recipe_url = ""
  config.chef.cookbooks_path = ["cookbooks"]
  config.chef.add_recipe "angelbox"
  config.chef.add_recipe "railsframe"
  #config.chef.add_role "devbox"

  config.chef.json[:railsframe] = {
    :github_user => 'noahgibbs',
    :apps => [
      { :github => "blog" }
    ]
  }
end
