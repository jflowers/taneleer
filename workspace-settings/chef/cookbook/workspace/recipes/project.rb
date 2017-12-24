#
# Cookbook Name:: workspace
# Recipe:: project
#

include_recipe 'chef_commons'
include_recipe 'workspace::attributes_overrides'

homebrew_cask 'deluge'
