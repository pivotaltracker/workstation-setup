#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureGitTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    # Add Tracker .git-authors
    FileUtils.copy("#{repo_root}/files/tracker/.git-authors", "#{home}/.git-authors")
  end
end

ConfigureGitTracker.new.run
