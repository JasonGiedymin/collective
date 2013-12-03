# system.rb

require 'colorize'
require 'growl'

module System
  def self.shell_cmd(location, cmd, action_message, fire_forget=false)
    version = Global::Settings.defaults['version']
    chdir(location)

    if (!fire_forget)
      if system cmd
        msg = "\nAction #{action_message} complete"
        self.msgSuccess msg, "vm"
      else
        msg = "\n!!!\n   Error trying to #{action_message}\n!!!\n\n"
        self.msgError msg, "vm"
        raise msg.red
      end
    else
      system cmd
    end

    chdir(HOME)
  end # end vm_cmd

  def self.chdir(dir)
    Dir.chdir("#{dir}")
  end

  # Bundled in System for now
  def self.msg(level, message, box)
    box ||= 'vm'
    version = Global::Settings.defaults['version']
    title = "#{version} - #{box}"

    Growl.send("notify_#{level}", message, :title => title)
  end

  def self.msgDebug(message, box)
    debug_mode = Global::Settings.defaults['debug']
    if debug_mode
      puts message.green
      self.msg('info', message, box)
    end
  end

  # Called when a function is successfully complete and the user must know
  def self.msgSuccess(message, box)
    puts message.black.on_magenta
    self.msg('ok', message, box)
  end

  def self.msgError(message, box)
    puts message.red
    self.msg('error', message, box)
  end

  def self.msgInfo(message, box)
    puts message.light_green
    self.msg('info', message, box)
  end

  def self.msgWarn(message, box)
    puts message.yellow
    self.msg('info', message, box)
  end

end
