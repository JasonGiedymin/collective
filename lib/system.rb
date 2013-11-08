# system.rb

module System
  def self.shell_cmd(location, cmd, action_message, fire_forget=false)
    chdir(location)

    if (!fire_forget)
      if system cmd
        puts "\nAction #{action_message} complete".black.on_light_green
      else
        raise "\n!!!\n   Error trying to #{action_message}\n!!!\n\n".red
      end
    else
      system cmd
    end

    chdir(HOME)
  end # end vm_cmd

  def self.chdir(dir)
    Dir.chdir("#{dir}")
  end

end
