maintainer        "Noah Gibbs"
maintainer_email  "noah_gibbs@yahoo.com"
license           "Creative Commons 0 (CC0)"
description       "Installs and configures the angelbob.com server"
version           "0.0.1"

recipe "angelbox", "Installs and configures angelbob.com"

depends "apt"
depends "ruby-shadow"
depends "rvm_ree_default"
depends "nginx"
depends "passenger"
depends "build"

supports ubuntu
