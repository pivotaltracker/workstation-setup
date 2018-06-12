#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureOSXTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    # Update the system clock
    # See http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
    process('defaults write com.apple.menuextra.clock "DateFormat" "MMM d h:mm:ss a"')
    process('killall SystemUIServer')
  end
end

ConfigureOSXTracker.new.run
