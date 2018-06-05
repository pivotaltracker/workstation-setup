#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureRuby < TrackerConfigurationBase
  def run
    process_without_output("sudo cp #{repo_root}/files/tracker/gemrc /etc/gemrc")
    FileUtils.ln_s('/etc/gemrc', "#{home}/.gemrc", force: true)
  end
end

ConfigureRuby.new.run
