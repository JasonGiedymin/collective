
import 'lib/conf.rb'
import 'lib/system.rb'
import 'lib/vagrant.rb'

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
# $stderr.sync = true

Dir.chdir(File.expand_path("../", __FILE__))

HOME = File.dirname(__FILE__)
# puts c.get('defaults')

## Tasks
task :default do
  Rake::Task["help:examples"].invoke
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
