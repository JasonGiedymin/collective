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
resources = Global::Settings.locations['resources']
cookbooks = Global::Settings.locations['cookbooks']
chef_client_keys = Global::Settings.locations['chef_client_keys']
universal_node_name = Global::Settings.defaults['universal_node_name']
universal_node_pem = Global::Settings.defaults['universal_node_pem']

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
      instance.vm.boot_timeout = 400

      instance.vm.provider "virtualbox" do |vb|
        vb.customize ['modifyvm', :id, '--memory', node['mem']]
        vb.customize ['modifyvm', :id, '--cpus', node['cpus']]
   
        # Do not change
        vb.customize ['modifyvm', :id, '--hwvirtex', 'on']

        # UI
        vb.gui = Conversions.Boolean(node['ui'])
      end # end vbox

      # - Plugins -
      # Omnibus
      # config.omnibus.chef_version = :latest
      
      # Cachier
      instance.cache.auto_detect = true
      instance.cache.scope = :machine # for multi-machine scope
      instance.cache.enable :apt # turn on caches:
      instance.cache.enable :chef
      instance.cache.enable :gem
      instance.cache.enable :rvm
      instance.cache.enable :npm

      # Chef Roles
      instance.vm.provision "chef_solo" do |chef|
        chef.log_level = :debug
        chef.cookbooks_path = [cookbooks]
        chef.roles_path = roles_loc
        
        if !node['roles'].nil?
          node['roles'].each do |role|
            chef.add_role(role)
          end
        end
      end # end chef_solo

      # # Chef Client # Disabled but left for posperity
      # if node['run_client']?
      #   config.vm.provision "chef_client" do |chef|
      #     # first check if node is set for using chef client
      #       chef.chef_server_url = "https://10.10.10.10/"
      #       chef.node_name = node['hostname']
      #       chef.validation_client_name = universal_node_name
      #       chef.validation_key_path = "#{chef_client_keys}/#{universal_node_pem}"
      #   end
      # end

      # Init
      instance.vm.provision :shell, path: "#{init_script_loc}/#{node['hostname']}/#{node['init']}"
    end # end instance
  end # end nodes
end # end vagrant
