#!/usr/bin/env ruby

require_relative './base.rb'

class FinishedTracker < TrackerConfigurationBase
  def run
    # Configure the default browser
    output = process_without_output("#{repo_root}/files/tracker/defaultbrowser-1.1")
    unless output =~ /\* chrome/
      process_without_output("osascript -e 'with timeout of 1000000 seconds' -e 'tell application (path to frontmost application as text) to display dialog \"Select \\\"Use Chrome\\\"\" buttons {\"OK\"}' -e 'end timeout'")
      process_without_output("bash -c '#{repo_root}/files/tracker/defaultbrowser-1.1 chrome'")
    end

    puts '\nNow, continue setting up the workstation by following the instructions'
    puts 'in the workstation-setup README:'
    puts '    https://github.com/pivotaltracker/workstation-setup/blob/master/README_TRACKER.md'

    puts '--------------------------------------------------'
    puts 'Done! Workstation setup completed successfully.'
    puts '--------------------------------------------------'

  end
end

FinishedTracker.new.run
