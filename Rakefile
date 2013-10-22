
import 'lib/system.rb'
import 'lib/git.rb'

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
# $stderr.sync = true

Dir.chdir(File.expand_path("../", __FILE__))

HOME = File.dirname(__FILE__)

Repo = Struct.new(:name, :url, :tag, :location, :postinstall)
repos = [
  # Disabled tracking vagrant for now, make sure to stick with v1.2.7
  # you may have to do gem uninstall vagrant
  # Utility.new('vagrant', 'https://github.com/mitchellh/vagrant.git', 'v1.2.7', 'gem uninstall -a vagrant && rake install')
  Repo.new( 
    'devstack', 
    'https://github.com/openstack-dev/devstack.git', 
    '',
    "#{HOME}/manifests",
    'echo "Obtained private origin release v2.0"')
]

## Tasks
task :default do
  Rake::Task["help:examples"].invoke
end

namespace :download do
  desc "download repos"
  task :repos do
    Git.cloneRepos(repos)
  end
end

namespace :check do
  desc "check config"
  task :config do
    ConfigCheck.test
  end
end

namespace :help do
  desc "usage examples"
  task :examples do
    puts "\n\n"
    puts " Note: You may see `CLEAN` warnings from running `rake`, you may safely ignore these."
    puts "---------------------------"
    puts " Usage Examples:"
    puts "  `rake -T` lists all the available tasks"
    puts "  `rake clean` cleans up cookbooks and misc files"
    puts "---------------------------"
    puts "\n\n"
  end

  task :default => :examples
end

