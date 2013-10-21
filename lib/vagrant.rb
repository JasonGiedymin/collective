

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

  if (!fire_forget)
    if system vagrant_cmd
      puts "-> Vagrant command ran: [#{vagrant_cmd}]\n\n"
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
          vm_cmd(os, command.cmd, command.fire_forget)
        end # end dynamic task

      end # end command each

      desc "Removes #{version}-#{os} from vagrant."
      task :cleanup do
        Rake::Task["vm:destroy"].invoke
        vm_cmd('virtualbox', "box remove #{version}-#{os}", true)
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
      end

    end # end namespace os

  end # end os

  # raw vm:<cmd>
  VAGRANT_CMDS.each do |command|
    os=default_vm
    desc "#{command.desc} #{os}"
    task command.task do |t|
      vm_cmd(os, command.cmd, command.fire_forget)
    end # end default vm task
  end # end default command each


  desc 'Cleanup up latest holobot box'
  task :cleanup do
    Rake::Task["vm:destroy"].invoke
    vm_cmd('virtualbox', "box remove #{version}-#{default_vm}")
  end

  desc 'Cleanup all boxes'
  task :cleanupall do
    SUPPORTED_OS.each do |os|
      puts "\ndestroying #{os}..."
      Rake::Task["vm:#{os}:destroy"].invoke
    end
  end
  
  desc 'Rebirth does a force destroy followed by an up'
  task :rebirth do
    Rake::Task["vm:destroy"].invoke
    Rake::Task["vm:cleanup"].invoke
    Rake::Task["vm:up"].invoke
  end

  desc 'Reboots a vm'
  task :reboot do
    Rake::Task["vm:halt"].invoke
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
            puts "\nhalting #{os}..."
            Rake::Task["vm:#{os}:halt"].invoke
          end
        end

        desc 'Power up cluster'
        task :up do
          cluster_nodes.each do |os|
            puts "\n== Powering up cluster:[#{cluster_name}], node:[#{os}] =="
            Rake::Task["vm:#{os}:up"].invoke
            Rake::Task["vm:#{os}:provision"].invoke # for good measure
            Rake::Task["vm:#{os}:reboot"].invoke # for good measure
            puts "\n== Cluster:[#{cluster_name}] up and running =="
          end
        end

        desc 'Rebirth an entire cluster'
        task :rebirth do
          cluster_nodes.each do |os|
            puts "\nrebirth-ing #{os}..."
            Rake::Task["vm:#{os}:rebirth"].invoke
          end
        end

        desc 'Destroys an entire cluster'
        task :destroy do
          cluster_nodes.each do |os|
            puts "\ndestroying #{os}..."
            Rake::Task["vm:#{os}:destroy"].invoke
          end
        end

        desc 'Reboots an entire cluster'
        task :reboot do
          cluster_nodes.each do |os|
            puts "\nrebooting #{os}..."
            Rake::Task["vm:#{os}:reboot"].invoke
          end
        end
      end
    end # end clusters
  end # end cluster

end # end vm