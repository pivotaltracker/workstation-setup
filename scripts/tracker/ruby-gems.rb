#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureRubyGemsTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    process('gem install process_helper')
  end
end

ConfigureRubyGemsTracker.new.run
