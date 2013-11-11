# update.rb

require 'colorize'

import 'lib/system.rb'
import 'lib/conf.rb'
import 'lib/git.rb'

namespace :update do


  desc "update all gems, cookbooks, and files"
  task :all do
    Rake::Task["download:gems"].invoke
    Rake::Task["download:cookbooks"].invoke
    Rake::Task["download:files"].invoke
    Rake::Task["download:repos"].invoke
  end
end
