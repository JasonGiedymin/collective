# system.rb

module System
  def self.shell_cmd(location, cmd, action_message, fire_forget=false)
    chdir(location)

    if (!fire_forget)
      if system cmd
        puts "-> Action [#{action_message}] complete\n\n"
      else
          raise "\n!!!\n   Error trying to #{action_message}\n!!!\n\n"
      end
    else
      system cmd
    end

  end # end vm_cmd

  def self.chdir(dir)
    Dir.chdir("#{dir}")
  end
end
