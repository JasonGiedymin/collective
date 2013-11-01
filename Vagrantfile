#
# Vagrantfile
#
# Notice how lean this file is. Any injection other than init should be
# done at a higher level.
#

HOME = File.dirname(__FILE__)

require './lib/conf.rb'

node_entries = Global::Settings.nodes
version = Global::Settings.defaults['version']
default_vm = Global::Settings.defaults['vm']
clusters = Global::Settings.clusters
box_loc = Global::Settings.locations['base_boxes']
init_script_loc = Global::Settings.locations['init_scripts']
roles_loc = Global::Settings.locations['roles']

Vagrant.configure('2') do |config|

  node_entries.each do |entry|
    node = entry['node']

    _primary = (default_vm == node['hostname'])

    config.vm.define node['hostname'], primary: _primary do |instance|
      instance.vm.box = "#{version}-#{node['box']}"
      instance.vm.box_url = "#{box_loc}/#{node['url']}"
      instance.vm.host_name = node['hostname']# + '.' + domain
      instance.vm.network 'private_network', :mac => node['mac'], ip: node['ip']
      instance.vm.synced_folder "manifests", "/home/vagrant/manifests"

      instance.vm.provider "virtualbox" do |vb|
        vb.customize ['modifyvm', :id, '--memory', node['mem']]
        vb.customize ['modifyvm', :id, '--cpus', node['cpus']]
   
        # Do not change
        vb.customize ['modifyvm', :id, '--hwvirtex', 'on']

        # UI
        vb.gui = node['ui']

        # Chef Roles
        instance.vm.provision "chef_solo" do |chef|
          chef.cookbooks_path = "manifests/repos/cookbooks/"
          chef.roles_path = roles_loc
          
          if !node['roles'].nil?
            node['roles'].each do |role|
              chef.add_role(role)
            end
          end

        end # end chef_solo
        
        # Init
        instance.vm.provision :shell, path: "#{init_script_loc}/#{node['hostname']}/#{node['init']}"
      end # end instance

    end # end define
  end # end nodes
end # end vagrant
