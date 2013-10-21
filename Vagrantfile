HOME = File.dirname(__FILE__)

require './lib/conf.rb'


node_entries = Global::Settings.nodes
version = Global::Settings.defaults['version']
default_vm = Global::Settings.defaults['vm']
clusters = Global::Settings.clusters
box_loc = Global::Settings.locations['base_boxes']


Vagrant.configure('2') do |config|
  node_entries.each do |entry|
    node = entry['node']
 
    config.vm.provider "virtualbox" do |vb|
      vb.customize ['modifyvm', :id, '--memory', node['mem']]
      vb.customize ['modifyvm', :id, '--cpus', node['cpus']]
 
      # do not change
      vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
      vb.gui = Global::Settings.defaults['ui']
    end
 
    _primary = (default_vm == node['hostname'])
    config.vm.define node['hostname'], primary: _primary do |instance|
      box_name = "#{version}-#{node['box']}"
      instance.vm.box = box_name
      instance.vm.box_url = "#{box_loc}/#{node['url']}"
      instance.vm.host_name = node['hostname']# + '.' + domain
      instance.vm.network "private_network", ip: node['ip'], :mac => node['mac'], :adapter => 2

      instance.vm.provision :shell, inline: "echo '#{box_name}' started...'"
    end # end define

    # config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)', :mac => node['mac']#, :adapter => 3
  end # end node_entries
end # end Vagrant