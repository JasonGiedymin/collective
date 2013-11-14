require 'colorize'

VagrantCommand = Struct.new(:task, :desc, :cmd, :fire_forget)

# Simple custom commands here
# If more complex commands are necessary, drop down to
# the `namespace: vm` section below.
VAGRANT_CMDS = [
  VagrantCommand.new('up', 'Start vm', 'up'),
  VagrantCommand.new('halt', 'Stop vm', 'halt'),
  VagrantCommand.new('suspend', 'Suspend suspended vm', 'suspend'),
  VagrantCommand.new('resume', 'Resume a suspended vm', 'resume'),
  VagrantCommand.new('destroy', 'Destroy and cleanup vm', 'destroy --force', true),
  VagrantCommand.new('ssh', 'SSH onto vm', 'ssh', true),
  VagrantCommand.new('provision', 'Provision vm', 'provision')
]

def vm_cmd(os, cmd, fire_forget=false)
  System.chdir("#{HOME}")
  vagrant_cmd = "vagrant #{cmd} #{os}"
  puts "\n-> running command: [#{vagrant_cmd}]\n\n".underline

  if (!fire_forget)
    if system vagrant_cmd
      puts "  Vagrant command ran: [#{vagrant_cmd}]\n\n"
    else
        raise "\n!!!\n   Error trying to run vagrant command [#{vagrant_cmd}]\n!!!\n\n"
    end
  else
    system vagrant_cmd
  end
end # end vm_cmd


namespace :vm do
  SUPPORTED_NODES = Global::Settings.nodes
  version = Global::Settings.defaults['version']
  default_vm = Global::Settings.defaults['vm']
  clusters = Global::Settings.clusters

  # nested vm command: vm:<os>:<cmd>
  SUPPORTED_NODES.each do |entry|
    os = entry['node']['hostname']

    namespace "#{os}" do
      VAGRANT_CMDS.each do |command|

        desc "#{command.desc} #{os}"
        task command.task do |t|
          puts "-> running command:[#{command.task}] on node:[#{os}]".underline
          vm_cmd(os, command.cmd, command.fire_forget)
          puts "\n== command:[#{command.task}] on node:[#{os}] complete ==".black.on_magenta

          if(command.task == 'destroy')
            Rake::Task["vm:#{os}:cleanup"].invoke
          end
        end # end dynamic task

      end # end command each

      desc "Removes #{version}-#{os} from vagrant."
      task :cleanup do
        puts "-> running command:[cleanup] on node:[#{os}]".underline
        vm_cmd('virtualbox', "box remove #{version}-#{os}", true)
        puts "\n== command:[cleanup] on node:[#{os}] complete ==".black.on_magenta
      end

      desc 'Rebirth does a force destroy followed by an up'
      task :rebirth do
        Rake::Task["vm:#{os}:destroy"].invoke
        Rake::Task["vm:#{os}:cleanup"].invoke
        Rake::Task["vm:#{os}:up"].invoke
      end

      desc "Reboots the #{os} vm"
      task :reboot do
        Rake::Task["vm:#{os}:halt"].invoke
        Rake::Task["vm:#{os}:up"].invoke
        Rake::Task["vm:#{os}:provision"].invoke
      end

    end # end namespace os

  end # end os

  # raw vm:<cmd>
  VAGRANT_CMDS.each do |command|
    os=default_vm
    desc "#{command.desc} #{os}"
    task command.task do |t|
      # puts "-> running command:[#{command.task}] on node:[#{os}]".underline
      # vm_cmd(os, command.cmd, command.fire_forget)
      # puts "\n== command:[#{command.task}] on node:[#{os}] complete ==".black.on_magenta
      
      # if(command.task == 'destroy')
      #   Rake::Task["vm:cleanup"].invoke
      # end

      # legacy manual impl above, kept for posperity
      Rake::Task["vm:#{os}:#{command.task}"].invoke

    end # end default vm task
  end # end default command each


  desc 'Cleanup up latest box'
  task :cleanup do
    vm_cmd('virtualbox', "box remove #{version}-#{default_vm}", true)
    puts "== command:[cleanup] on node:[#{default_vm}] complete ==\n".black.on_magenta
  end

  desc 'Cleanup ALL nodes'
  task :cleanupall do
    SUPPORTED_NODES.each do |entry|
      os = entry['node']['hostname']
      Rake::Task["vm:#{os}:cleanup"].invoke
    end
    puts "\n== cleanup on all nodes complete ==".black.on_light_magenta
  end
  
  desc 'Rebirth does a force destroy followed by an up'
  task :rebirth do
    Rake::Task["vm:destroy"].invoke
    Rake::Task["vm:cleanup"].invoke
    puts "sleeping to let host system catchup"
    sleep(5)
    Rake::Task["vm:up"].invoke
  end

  desc 'Reboots a vm'
  task :reboot do
    Rake::Task["vm:halt"].invoke
    puts "sleeping to let host system catchup"
    sleep(5)
    Rake::Task["vm:up"].invoke
  end

  namespace :cluster do
    clusters.each do |entry|
      cluster_name = entry['cluster']['name']
      cluster_nodes = entry['cluster']['nodes']
      
      namespace "#{cluster_name}" do
        desc 'Halt or shutdown cluster'
        task :halt do
          cluster_nodes.each do |os|
            puts "\n== Powering down cluster:[#{cluster_name}], node:[#{os}] ==".light_red
            Rake::Task["vm:#{os}:halt"].invoke
          end
          puts "\n== Cluster:[#{cluster_name}] down ==".black.on_light_red
        end

        desc 'Power up a cluster'
        task :up do
          cluster_nodes.each do |os|
            puts "\n== Powering up cluster:[#{cluster_name}], node:[#{os}] ==".green
            Rake::Task["vm:#{os}:up"].invoke
            Rake::Task["vm:#{os}:provision"].invoke # for good measure
          end

          Rake::Task["vm:cluster:#{cluster_name}:sync"].invoke # for good measure
          puts "\n== Cluster:[#{cluster_name}] up and running ==".black.on_green
        end

        desc 'Re-provisions a cluster'
        task :provision do
          cluster_nodes.each do |os|
            puts "\n== Provisioning cluster:[#{cluster_name}], node:[#{os}] ==".cyan
            Rake::Task["vm:#{os}:provision"].invoke
          end

          puts "\n== Provisioning Cluster:[#{cluster_name}] complete ==".black.on_cyan

          # prepare the cluster
          Rake::Task["vm:cluster:#{cluster_name}:prepare"].invoke
        end

        desc 'Rebirth an entire cluster'
        task :rebirth do
          cluster_nodes.each do |os|
            puts "\n== Rebirthing cluster:[#{cluster_name}], node:[#{os}] ==".light_blue
            Rake::Task["vm:#{os}:rebirth"].invoke
          end

          # prepare the cluster
          Rake::Task["vm:cluster:#{cluster_name}:sync"].invoke
          
          puts "\n== Rebirth complete for cluster:[#{cluster_name}] ==".white.on_light_blue
        end

        desc 'Sync a cluster by uploading and ping'
        task :sync do
          puts "Syncing cluster..."

          # bootstrap the cluster (will also register node)
          # also creates client.rb and who knows what else
          # cause I'm lazy
          Rake::Task["vm:cluster:#{cluster_name}:bootstrap"].invoke

          # upload chef data (upload _our_ node data)
          Rake::Task["vm:cluster:#{cluster_name}:upload"].invoke

          # register the node with daemon mode and run chef-client
          Rake::Task["vm:cluster:#{cluster_name}:prepare"].invoke

          puts "\n== Syncing cluster:[#{cluster_name}] complete ==".light_yellow
        end

        desc 'Destroys an entire cluster and cleans up'
        task :destroy do
          cluster_nodes.each do |os|
            puts "\n== Destroying cluster:[#{cluster_name}]".red
            Rake::Task["vm:#{os}:destroy"].invoke
            Rake::Task["vm:#{os}:cleanup"].invoke
            puts "\n== Cluster:[#{cluster_name}] destroyed".white.on_red
          end
        end

        desc 'Reboots an entire cluster'
        task :reboot do
          cluster_nodes.each do |os|
            puts "\n== Rebooting cluster:[#{cluster_name}]".light_yellow
            Rake::Task["vm:#{os}:reboot"].invoke
            Rake::Task["vm:#{os}:sync"].invoke
            puts "\n== Cluster:[#{cluster_name}] rebooted".black.on_light_yellow
          end
        end

        desc 'Bootstraps the cluster with chef'
        task :bootstrap do
          chef_node = entry['cluster']['chef_node']
          raise "\n!!!\n   Cannot find chef_node within cluster node!\n!!!\n\n".red if chef_node.nil?

          bootstrap_nodes = entry['cluster']['bootstrap_nodes']
          nodes = Global::Settings.nodes
          user = entry['cluster']['user']
          pass = entry['cluster']['pass']
          
          # Bootstrap because I'm lazy
          bootstrap_nodes.each do |node|
            node_box = nodes[nodes.index{ |x| x['node']['box'] == node }]['node']['ip']
            # script = "\"rvm use system && cd ~/manifests/chef-server/ && bash ~/manifests/chef-server/knife_bootstrap.sh bootstrap 10.10.10.12 vagrant vagrant\""
            script = "\"bash manifests/chef-server/knife_bootstrap.sh bootstrap #{node_box} #{user} #{pass}\""
            # script = "\"sudo chef-client\""
            command = "ssh #{chef_node} -c #{script}"
            vm_cmd('', command, true)

            puts "\n== Bootstrapping cluster:[#{cluster_name}], node:[#{node}] complete =="
          end

          puts "\n== Bootstrapping cluster:[#{cluster_name}] complete ==".light_yellow.on_light_blue
        end

        desc 'Prepare the cluster node with chef'
        task :prepare do
          chef_node = entry['cluster']['chef_node']
          raise "\n!!!\n   Cannot find chef_node within cluster node!\n!!!\n\n".red if chef_node.nil?

          bootstrap_nodes = entry['cluster']['bootstrap_nodes']
          nodes = Global::Settings.nodes
          user = entry['cluster']['user']
          pass = entry['cluster']['pass']

          # run chef-client on each
          bootstrap_nodes.each do |node|
            node_box = nodes[nodes.index{ |x| x['node']['box'] == node }]['node']['ip']
            script = "\"sudo chef-client\"" # -d daemon mode has a memory leak
            command = "ssh #{node} -c #{script}"
            vm_cmd('', command, true)

            puts "\n== chef-client prepared on cluster:[#{cluster_name}], node:[#{node}] complete =="
          end

          puts "\n== Cluster:[#{cluster_name}] prepared ==".light_yellow.on_light_blue
        end

        desc 'Uploads all recipes, roles, nodes, environments to the chef server'
        task :upload do
          chef_node = entry['cluster']['chef_node']
          raise "\n!!!\n   Cannot find chef_node within cluster node!\n!!!\n\n".red if chef_node.nil?

          bootstrap_nodes = entry['cluster']['bootstrap_nodes']
          nodes = Global::Settings.nodes
          user = entry['cluster']['user']
          pass = entry['cluster']['pass']
          user_home = "/home/#{user}"

          scripts = [
            "\"cd #{user_home}/manifests/chef-server/ && sudo knife upload -V --force cookbooks\"",
            "\"cd #{user_home}/manifests/chef-server/ && sudo knife role bulk delete \"*\"",
            "\"cd #{user_home}/manifests/chef-server/ && sudo knife upload -V --force roles\"",
            "\"cd #{user_home}/manifests/chef-server/ && sudo knife upload -V --force nodes\""
          ]
          
          scripts.each do |script|
            command = "ssh #{chef_node} -c #{script}"
            vm_cmd('', command, true)
          end

          puts "\n== Uploading cluster:[#{cluster_name}], node:[#{chef_node}] complete ==".light_yellow.on_light_blue
        end # end upload

      end # end curr cluster
    end # end clusters each
  end # end cluster

end # end vm