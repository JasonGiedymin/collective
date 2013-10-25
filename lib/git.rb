# git.rb

require 'colorize'

import 'lib/system.rb'
import 'lib/conf.rb'

module Git
  def self.clone(name, url, dir)
    puts "-> Cloning [ #{name} via #{url} ]".light_blue
    System.shell_cmd(
      "./",
      "git clone #{url} #{dir}/#{name}",
      "cloning repository #{url}"
    )
  end

  def self.cloneRepos(repos)
    repos_loc = Global::Settings.locations['repos']
    Dir.mkdir(repos_loc) unless Dir.exists?(repos_loc)

    repos.each do |entry|
      out_location = "#{repos_loc}/#{entry['name']}"
      if !Dir.exists?(out_location)
        Dir.mkdir(out_location)
      else
        puts "Deleting existing entryity #{entry['name']}..."
        FileUtils.rm_rf out_location
      end

      puts "Preparing to download entryity #{entry['name']}"
      Git.clone(entry['name'], entry['url'], out_location)

      if (!entry['tag'].nil? && entry['tag'].length > 0)
        System.shell_cmd(
          out_location,
          "git checkout --quiet tags/#{entry['tag']}",
          "check out tag #{entry['tag']}"
        )
      end

      if( entry['post_install'].length > 0)
        System.shell_cmd(
          out_location,
          entry.postinstall,
          "Installed entry #{entry['name']}"
        )
      end

      puts "\n== Repo cloning complete ==".white.on_light_blue
    end
  end
end