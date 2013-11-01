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
    # Walk down to repos dir
    repos_dir = [HOME,Global::Settings.locations['repos']].join('/')
    Dir.mkdir(repos_dir) unless Dir.exists?(repos_dir)

    repos.each do |entry|
      repo_loc = entry['location'] # sub dir location if any
      
      # Walk down to the final loc
      out_location = (repo_loc.length > 0 && [repos_dir,repo_loc].join('/')) || repos_dir

      # By this time we know we're safe, TODO: can we mkdir -p?
      # Dir.chdir(out_location)
      
      # The final repo location, to be used later
      repo_location = "#{out_location}/#{entry['name']}"

      # cleanup first
      if !Dir.exists?(repo_location)
        Dir.mkdir(repo_location)
      else
        puts "Deleting existing entryity #{entry['name']}..."
        FileUtils.rm_rf repo_location
      end

      # Clone
      puts "Preparing to download entry #{entry['name']}"
      Git.clone(entry['name'], entry['url'], out_location)

      # Checkout tag
      if (!entry['tag'].nil? && entry['tag'].length > 0)
        System.shell_cmd(
          repo_location,
          "git checkout --quiet tags/#{entry['tag']}",
          "check out tag #{entry['tag']}"
        )
      end

      # Post install
      if( entry['post_install'].length > 0)
        System.shell_cmd(
          repo_location,
          entry.postinstall,
          "Installed entry #{entry['name']}"
        )
      end

      puts "\n== Repo cloning complete ==".white.on_light_blue
    end
  end
end