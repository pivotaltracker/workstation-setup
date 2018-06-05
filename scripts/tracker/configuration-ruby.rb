#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureRubyTracker < TrackerConfigurationBase
  def run
    process_without_output("sudo cp #{repo_root}/files/tracker/gemrc /etc/gemrc")
    FileUtils.ln_s('/etc/gemrc', "#{home}/.gemrc", force: true)

    install_gem('process_helper')
    install_gem('gitpflow --source https://repo.fury.io/pivotaltracker')
  end

  def install_gem(name)
    ruby_versions = process_without_output('rvm list strings').split('\n').map(&:strip)
    ruby_versions.append('system').each do |version|
      process_without_output("rvm use #{version}; gem install #{name}")
    end
  end
end

ConfigureRubyTracker.new.run
