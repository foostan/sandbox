#
# Cookbook Name:: chefserver
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
remote_file "/tmp/chef-server.deb" do
    source "https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.8-1.ubuntu.12.04_amd64.deb"
end

dpkg_package "chef-server" do
    action :install
    source "/tmp/chef-server.deb"
end

execute "chef-server-ctl reconfigure" do
    action :run
end
