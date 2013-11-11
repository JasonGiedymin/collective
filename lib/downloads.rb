# downloads.rb

require 'colorize'

import 'lib/system.rb'
import 'lib/conf.rb'
import 'lib/git.rb'

namespace :download do
  desc "download gems"
  task :gems do
    FileUtils.rm_rf "#{HOME}/Gemfile.lock"

    System.shell_cmd(
      "./",
      "bundle",
      "Downloaded gems via bundler"
    )
  end

  desc "download cookbooks"
  task :cookbooks do
    berks_loc = Global::Settings.locations['berkshelf']
    
    puts "\n-> running berks install --path #{HOME}/#{berks_loc} -c #{HOME}/#{berks_loc}/berks-config.json".underline    
    puts "\nremoving Berksfile.lock...".underline

    FileUtils.rm_rf "#{HOME}/#{berks_loc}/Berksfile.lock"
    FileUtils.rm_rf "#{HOME}/#{berks_loc}/cookbooks"

    System.shell_cmd(
      "#{HOME}/#{berks_loc}",
      "berks install --path #{HOME}/#{berks_loc}/cookbooks -c #{HOME}/#{berks_loc}/berks-config.json",
      "Downloaded cookbooks via berkshelf to [#{berks_loc}]"
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
