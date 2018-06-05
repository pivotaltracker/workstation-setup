#!/usr/bin/env ruby

require_relative './base.rb'

class ApplicationsCommonTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    things = %w(
      chromedriver
      clipy
      free-ruler
      google-cloud-sdk
      java
      spectacle
      the-unarchiver
      vagrant
      xquartz
      xscope
    )

    things.each do |thing|
      brew_cask_install(thing)
    end

    # Install Spectacle
    path = "Library/Application Support/Spectacle"
    filename = "Shortcuts.json"
    FileUtils.mkdir_p("#{home}/#{path}")
    FileUtils.copy("#{repo_root}/files/tracker/#{path}/#{filename}",
                   "#{home}/#{path}/#{filename}")
  end
end

ApplicationsCommonTracker.new.run
