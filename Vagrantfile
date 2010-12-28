Vagrant::Config.run do |config|
  config.vm.box = "lucid32"

  # For debugging, opens a window when running
  #config.vm.boot_mode = :gui

  config.vm.provisioner = :chef_solo
  #config.chef.recipe_url = ""
  config.chef.cookbooks_path = ["cookbooks"]
  config.chef.add_recipe "angelbox"
end
