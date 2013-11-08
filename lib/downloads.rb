# downloads.rb

require 'colorize'

import 'lib/system.rb'
import 'lib/conf.rb'
import 'lib/git.rb'

namespace :download do
  desc "download cookbooks"
  task :cookbooks do
    cookbooks_loc = Global::Settings.locations['berkshelf']
    
    puts "\n-> running berks install --path #{HOME}/#{cookbooks_loc} -c #{HOME}/manifests/berkshelf/berks-config.json".underline
    
    puts "removing Berksfile.lock..."

    FileUtils.rm_rf "#{HOME}/#{cookbooks_loc}/Berksfile.lock" 

    System.shell_cmd(
      "./manifests/berkshelf",
      "berks install --path #{HOME}/#{cookbooks_loc} -c #{HOME}/manifests/berkshelf/berks-config.json",
      "Downloaded cookbooks via berkshelf to [#{cookbooks_loc}]"
    )
  end

  desc "download repos"
  task :repos do
    repos = Global::Settings.repos
    Git.cloneRepos(repos)
  end

  desc "download files"
  task :files do
    downloads = Global::Settings.downloads
    files = downloads['files']

    files.each do |file|
      name = file['name']
      url = file['url']
      track = file['track']
      location = file['location']

      download_loc = Global::Settings.locations[location]
      full_loc = "#{download_loc}/#{name}"

      # check if location exists create otherwise
      Dir.mkdir(download_loc) unless Dir.exists?(download_loc)

      if track
        puts "-> Tracking #{full_loc}...".light_yellow
        FileUtils.rm_rf "#{full_loc}"
      end

      if !File.exists?(full_loc)
        puts "-> Downloading file: [#{url}] as [#{name}]".light_blue

        System.shell_cmd(
          "./",
          "curl #{url} > #{full_loc}",
          "Download file #{name} to [#{full_loc}]"
        )
      end
    end

    puts "\n== Downloads complete ==".white.on_light_blue
  end
end
