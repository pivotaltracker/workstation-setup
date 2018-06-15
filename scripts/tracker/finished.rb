#!/usr/bin/env ruby

require_relative './base.rb'

class FinishedTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    output = process_without_output("#{repo_root}/files/tracker/defaultbrowser-1.1")
    unless output =~ /\* chrome/
      process("osascript -e 'tell application (path to frontmost application as text) to display dialog \"Select \\\"Use Chrome\\\"\" buttons {\"OK\"}'")
      process("#{repo_root}/files/tracker/defaultbrowser-1.1 chrome")
    end
  end
end

FinishedTracker.new.run
