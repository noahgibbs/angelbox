package "libgeoip-dev"
package "libxslt1-dev"
package "libpcre3-dev"
package "libgd2-noxpm-dev"
package "libssl-dev"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
end

# default options from Ubuntu 8.10
compile_options = ["--conf-path=/etc/nginx/nginx.conf",
                   "--error-log-path=/var/log/nginx/error.log",
                   "--pid-path=/var/run/nginx.pid",
                   "--lock-path=/var/lock/nginx.lock",
                   "--http-log-path=/var/log/nginx/access.log",
                   "--http-client-body-temp-path=/var/lib/nginx/body",
                   "--http-proxy-temp-path=/var/lib/nginx/proxy",
                   "--http-fastcgi-temp-path=/var/lib/nginx/fastcgi",
                   "--with-http_stub_status_module",
                   "--with-http_ssl_module",
                   "--with-http_gzip_static_module",
                   "--with-http_geoip_module",
                   "--with-file-aio"].join(" ")

nginx_source_file = "nginx-#{node[:nginx][:version]}.tar.gz"

remote_file "/tmp/#{nginx_source_file}" do
  source "http://sysoev.ru/nginx/#{nginx_source_file}"
  not_if { File.exist? node[:nginx][:binary] }
end

gem_package "passenger"

execute "compile nginx with passenger" do
  command "passenger-install-nginx-module --auto --prefix=/usr --nginx-source-dir=/tmp/#{nginx_source_file} --extra-configure-flags=\"#{compile_options}\""
  notifies :restart, resources(:service => "nginx")
  not_if "nginx -V | grep passenger-enterprise-server-#{node[:nginx][:version]}"
end

execute "rm /tmp/#{nginx_source_file}" do
  command "rm /tmp/#{nginx_source_file}"
  only_if { File.exist? node[:nginx][:binary] }
end

# Set up nginx

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

cookbook_file "#{node[:nginx][:dir]}/mime.types"

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, resources(:service => "nginx")
end

service "nginx" do
  action [ :enable, :start ]
end

nginx_site "default" do
  enable false
end

### Passenger and compilation options


template node[:nginx][:conf_dir] + "/passenger.conf" do
  source "nginx_passenger_conf.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :restart, resources(:service => "nginx")
end
