#
# Cookbook Name:: dev
# Recipe:: dotfiles
#
# Copyright 2013, foostan
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

git "/home/#{node['user']}/dotfiles" do
  repository 'https://github.com/foostan/dotfiles.git'
  revision   'master'
  action     :sync
  user       node['user']
  group      node['group']
  #notifies :run, 'execute[ini-dotfiles]', :immediately
end

execute 'ini-dotfiles' do
  command './ini.sh'
  cwd     "/home/#{node['user']}/dotfiles"
  action  :run
  user    node['user']
  environment ({'HOME' => "/home/#{node['user']}"})
end

execute "chsh-to-zsh" do
  command "chsh #{node['user']} -s /bin/zsh"
  action :run
end

