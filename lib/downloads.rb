# downloads.rb

require 'colorize'

import 'lib/system.rb'
import 'lib/conf.rb'
import 'lib/git.rb'

namespace :download do
  desc "download repos"
  task :repos do
    repos = Global::Settings.repos
    Git.cloneRepos(repos)
  end

  desc "download files"
  task :files do
    download_loc = Global::Settings.locations['downloads']
    downloads = Global::Settings.downloads

    # check if location exists create otherwise
    Dir.mkdir(download_loc) unless Dir.exists?(download_loc)

    files = downloads['files']
    files.each do |file|
      name = file['name']
      url = file['url']
      puts "-> Downloading file: [#{url}]".light_blue
      System.shell_cmd(
        "./",
        "curl #{url} > #{download_loc}/#{name}",
        "Download file #{name} to [#{download_loc}/#{name}]"
      )
    end
    puts "\n== Downloads complete ==".white.on_light_blue
  end
end
