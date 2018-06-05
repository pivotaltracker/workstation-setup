#!/usr/bin/env ruby

require 'fileutils'
require_relative 'scripts/tracker/base'

class ClearPairsAndLogs < TrackerConfigurationBase
  def run
    process_without_output("git config --global --remove-section duet.env")
    Dir.entries("#{home}/workspace").each do |dir|
      if File.directory?(File.join(home, 'workspace', dir)) and !(dir == '.' || dir == '..')
        Dir.glob(File.join(home, 'workspace', dir, 'log/*')).each do |logfile|
          File.open(logfile, 'w') do |file|
            file.write('')
          end
        end
      end
    end
    # because launchd doesn't like it if a script takes under 10 seconds
    # https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html
    sleep 10
  end
end

ClearPairsAndLogs.new.run

