require 'socket'
host = Socket.gethostname
user_home = ENV["HOME"]
HOME = File.dirname(__FILE__)

client_name = "cluster_node"
chef_repo = "#{HOME}/"
chef_server_url "http://10.10.10.10:4000"
node_name "#{client_name}"
client_key "#{chef_repo}/#{client_name}.pem"
validation_key "#{chef_repo}/#{client_name}.pem"
cookbook_path "#{chef_repo}/../cookbooks"