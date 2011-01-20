default.nginx[:dir]     = "/etc/nginx"
default.nginx[:log_dir] = "/var/log/nginx"
default.nginx[:user]    = "www"
default.nginx[:group]   = "www"
default.nginx[:binary]  = "/usr/sbin/nginx"
default.nginx[:gzip_types] = [ "text/plain", "text/css", "application/javascript", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ]
default.nginx[:version] = "0.8.53"

default.nginx[:gzip] = "on"
default.nginx[:gzip_http_version] = "1.0"
default.nginx[:gzip_comp_level] = "2"
default.nginx[:gzip_proxied] = "any"

default.nginx[:keepalive] = "on"
default.nginx[:keepalive_timeout] = 8

default.nginx[:worker_processes] = 6
default.nginx[:worker_connections] = 2048
default.nginx[:server_names_hash_bucket_size] = 128
default.nginx[:conf_dir] = nginx[:dir] + "/conf.d"

default.passenger[:version] = '3.0.2'
