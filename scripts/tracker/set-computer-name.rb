#!/usr/bin/env ruby

require_relative './base.rb'

class SetComputerName < TrackerConfigurationBase
  def run
    puts "Type this computer's name. Then press the `return/enter` key:"
    computer_name = gets.strip
    process_without_output("sudo scutil --set ComputerName #{computer_name}")
    process_without_output("sudo scutil --set HostName #{computer_name}")
    process_without_output("sudo scutil --set LocalHostName #{computer_name}")
    process_without_output("sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string #{computer_name}")
  end
end

SetComputerName.new.run
