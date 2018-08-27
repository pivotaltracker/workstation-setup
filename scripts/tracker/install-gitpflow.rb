#!/usr/bin/env ruby

require_relative './base.rb'

# Make `gitpflow` executable without bundle exec
class InstallGitpflow < TrackerConfigurationBase
  def run
    install_gem('gitpflow --source https://repo.fury.io/pivotaltracker')
  end

  def install_gem(name)
    ruby_versions = process_without_output('rvm list strings').split('\n').map(&:strip)
    ruby_versions.each do |version|
      process_without_output("rvm use #{version}; gem install #{name}")
    end
  end
end

InstallGitpflow.new.run
