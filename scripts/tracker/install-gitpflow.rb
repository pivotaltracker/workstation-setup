#!/usr/bin/env ruby

require_relative './base.rb'

# Make `gitpflow` executable without bundle exec
class InstallGitpflow < TrackerConfigurationBase
  def run
    process_without_output('gem install gitpflow --source https://repo.fury.io/pivotaltracker')
  end
end

InstallGitpflow.new.run
