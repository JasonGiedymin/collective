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
    
    System.msgDebug "running berks install --path #{HOME}/#{berks_loc} -c #{HOME}/#{berks_loc}/berks-config.json", "system"
    
    System.msgDebug "removing Berksfile.lock...", "system"
    FileUtils.rm_rf "#{HOME}/#{berks_loc}/Berksfile.lock"

    System.msgDebug "removing cookbooks...", "system"
    FileUtils.rm_rf "#{HOME}/#{berks_loc}/cookbooks"

    System.shell_cmd(
      "#{HOME}/#{berks_loc}",
      "berks install --path #{HOME}/#{berks_loc}/cookbooks -c #{HOME}/#{berks_loc}/berks-config.json",
      "Downloaded cookbooks via berkshelf to [#{berks_loc}]"
    )

    System.msgSuccess "Download of cookbooks complete.", "system"
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
        System.msgInfo "Tracking #{full_loc}...", "system"
        FileUtils.rm_rf "#{full_loc}"
      end

      if !File.exists?(full_loc)
        System.msgInfo "Downloading file: [#{url}] as [#{name}]", "system"

        System.shell_cmd(
          "./",
          "curl #{url} > #{full_loc}",
          "Download file #{name} to [#{full_loc}]"
        )
      end
    end

    System.msgSuccess "== Downloads complete ==", "system"
  end

  desc "download plugins"
  task :plugins do
    def installPlug(plug_name)
      System.shell_cmd(
        "./",
        "vagrant plugin install #{plug_name}",
        "Installing vagrant plugin: [#{plug_name}]"
      )
    end

    vagrant_plugins = Global::Settings.defaults['vagrant_plugins']
    vagrant_plugins.each do |plug|
      installPlug(plug)
    end

  end
end
