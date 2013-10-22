# git.rb

import 'lib/system.rb'

module Git
  def self.clone(name, url, dir)
    puts "Cloning [ #{name} via #{url} ]"
    System.shell_cmd(
      "./",
      "git clone #{url} #{dir}/#{name}",
      "cloning repository #{url}"
    )
  end

  def self.cloneRepos(repos)
    repos.each do |util|
      out_location = "#{util.location}/#{util.name}"
      if !Dir.exists?(out_location)
        Dir.mkdir(out_location)
      else
        puts "Deleting existing utility #{util.name}..."
        FileUtils.rm_rf out_location
      end

      puts "Preparing to download utility #{util.name}"
      Git.clone(util.name, util.url, util.location)

      if (!util.tag.nil? && util.tag.length > 0)
        System.shell_cmd(
          out_location,
          "git checkout --quiet tags/#{util.tag}",
          "check out tag #{util.tag}"
        )
      end

      if( util.postinstall.length > 0)
        System.shell_cmd(
          out_location,
          util.postinstall,
          "Installed util #{util.name}"
        )
      end

    end
  end
end