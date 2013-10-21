# Keep It Simple Vagrantfile
#
# Great with:
#   1. Vbox 4.3
#   1. Vagrant 1.3.5
#
# Rules:
#   1. no dynamic meta programming
#   1. no config files
#   1. nothing past this one file (one page app)
#   1. vagrant must run it's own commands, no proxy via rake
#   1. exceptions are manifests
#
#

nodes = [
  { :hostname => 'ci',     :box => 'ci',     :cpus => 1, :mem => 256, :ip => '10.10.10.01', :mac => '0800d2FF88F2', :url => 'base_boxes/ubuntu_13_04_lts.box' },
  { :hostname => 'dev',    :box => 'dev',    :cpus => 1, :mem => 256, :ip => '10.10.10.02', :mac => '080027EB6B03', :url => 'base_boxes/ubuntu_13_04_lts.box' },
  { :hostname => 'broker', :box => 'broker', :cpus => 1, :mem => 256, :ip => '10.10.20.01', :mac => '080027BE8715', :url => 'base_boxes/ubuntu_13_04_lts.box' },
  { :hostname => 'node-1', :box => 'node-1', :cpus => 1, :mem => 256, :ip => '10.10.20.02', :mac => '02EECB9EC1ED', :url => 'base_boxes/ubuntu_13_04_lts.box' }
]

#
# Unused macs:
#   02895C872CC5
#   02D7DAEB3F8C
#   024E89B94036
#   0253943912A9
#   0277E25CD585
#   025EDFE84F7F
#   02882CFDC8F
#   0269347FC4C6
#

Vagrant.configure('2') do |config|
  nodes.each do |node|
 
    config.vm.provider "virtualbox" do |vb|
      vb.customize ['modifyvm', :id, '--memory', node[:mem]]
      vb.customize ['modifyvm', :id, '--cpus', node[:cpus]]
 
      # do not change
      vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
    end
 
    config.vm.define node[:hostname] do |instance|
      instance.vm.box = node[:box]
      instance.vm.box_url = node[:url]
      instance.vm.host_name = node[:hostname]# + '.' + domain
      instance.vm.network 'private_network', ip: node[:ip]
    end # end define
  end # end nodes
end