#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureGitTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    # Add Tracker .git-authors
    FileUtils.copy("#{repo_root}/files/tracker/.git-authors", "#{home}/.git-authors")

    # Do the Tracker-specific Git configuration
    set_git_config('pull.rebase', 'preserve')
    set_git_config('push.default', 'current')
    set_git_config('user.email', 'labs-tracker-team@pivotal.io')
    set_git_config('user.name', 'Pivotal Tracker')
  end

  def set_git_config(key, value)
    process("git config --global '#{key}' '#{value}'")
  end
end

ConfigureGitTracker.new.run
