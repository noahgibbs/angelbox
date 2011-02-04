RailsFrame.config do
  app do
    default!
    github "noahgibbs/blog"
  end

  app do
    name "wantmyjob"
    github "noahgibbs/wantmyjob.com"
    mounted "~/src/github/wantmyjob.com"
  end

  port 4444

  vagrant.chef.log_level = :debug
  # For debugging, opens a window when running
  #vagrant.vm.boot_mode = :gui
end
