#
# Cookbook Name:: phpap
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "gmake"
include_recipe "apache2"
include_recipe "build-essential"
include_recipe "openssl"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

include_recipe "mysql::ruby"

apache_site "default" do
  enable true
end

mysql_database node['phpap']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['phpap']['db_username'] do
  connection ({:host=> 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['phpap']['db_password']
  database_name node['phpap']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end


package 'htop' do
  action :install
end

wordpress_latest = Chef::Config[:file_cache_path] + "/wordpress-latest.tar.gz"
remote_file wordpress_latest do
  source "http://wordpress.org/latest.tar.gz"
  mode "0644"
end
directory node['phpap']['path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

execute "untar-wordpress" do
  cwd node['phpap']['path']
  command 'tar --strip-components 1 -xzf ' + wordpress_latest
  creates node['phpap']['path']  + "/wp-settings.php"
end
