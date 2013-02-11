#
# Cookbook Name:: splunk
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

log "Installing Splunk"

user "#{node[:splunk][:user]}"  do
 action :create
 system true
 shell "/bin/bash"
end 

directory node[:splunk][:installdir] do   
  owner "#{node[:splunk][:user]}"
  mode "0755"   
  action :create 
end 

remote_file "#{node[:splunk][:installdir]}/splunk.tar" do   
 source node[:splunk][:installfile]
 action :create_if_missing 
end 

bash "install_splunk" do
 cwd node[:splunk][:installdir]
 code <<-EOH
  tar -xvf splunk.tar
 EOH
end 

bash "update_splunk_config" do
cwd node[:splunk][:installdir]
code <<-EOH
  cd splunk/etc/system/
  wget https://rsed-cheftraining.s3.amazonaws.com/splunk_update.tgz
  gzip -cd splunk_update.tgz |tar xvf -
 EOH
end 

package "tree"

rightscale_marker :end

