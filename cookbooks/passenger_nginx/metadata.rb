maintainer        "Noah Gibbs"
maintainer_email  "noah_gibbs@yahoo.com"
license           "Apache 2.0"
description       "Configures passenger with NginX"
version           "0.1"

# Based on OpsCode NginX and 37Signals passenger cookbooks

# No dependencies.  Do *not* use with existing passenger or NginX packages.
# They will download or include binary deb packages, and then you'll
# wind up rebuilding a modified passenger module from source again
# afterward.  Just use this by itself.
