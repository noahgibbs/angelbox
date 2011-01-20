package "libgeoip-dev"
package "libxslt1-dev"
package "libpcre3-dev"
package "libgd2-noxpm-dev"
package "libssl-dev"
package "libcurl4-openssl-dev"

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

nginx_tar_file = "nginx-#{node[:nginx][:version]}.tar.gz"

remote_file "/tmp/#{nginx_tar_file}" do
  source "http://sysoev.ru/nginx/#{nginx_tar_file}"
  not_if { File.exist? node[:nginx][:binary] }
end

execute "unpack nginx" do
  command "tar -C /tmp -zxf /tmp/#{nginx_tar_file}"
  not_if { File.exist? node[:nginx][:binary] }
end

gem_package "passenger" do
  version node[:passenger][:version]
end

execute "compile nginx with passenger" do
  user "root"
  command "passenger-install-nginx-module --auto --prefix=/usr --nginx-source-dir=/tmp/nginx-#{node[:nginx][:version]} --extra-configure-flags=\"#{compile_options}\""
  #notifies :restart, resources(:service => "nginx") # Not 'til it exists
  not_if "bash -c \"nginx -V |& grep passenger\""
end

template "/etc/init.d/nginx" do
  source "nginx.init.erb"
  owner "root"
  group "root"
  mode "0755"
end

directory "/var/lib/nginx" do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

execute "rm /tmp/#{nginx_tar_file}" do
  command "rm /tmp/#{nginx_tar_file}"
  only_if { File.exist?(node[:nginx][:binary]) &&
            File.exist?("/tmp/#{nginx_tar_file}") }
end

# Set up nginx

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

cookbook_file "#{node[:nginx][:dir]}/mime.types"

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :reload, resources(:service => "nginx")
end

directory "#{node[:nginx][:dir]}/conf.d" do
  owner node[:nginx][:user]
  mode "0755"
  action :create
end

directory "#{node[:nginx][:dir]}/sites-enabled" do
  owner node[:nginx][:user]
  mode "0755"
  action :create
end

directory "#{node[:nginx][:dir]}/sites-available" do
  owner node[:nginx][:user]
  mode "0755"
  action :create
end

nginx_site "default" do
  enable false
end
