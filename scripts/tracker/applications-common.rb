#!/usr/bin/env ruby

require_relative './base.rb'

class ApplicationsCommonTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    things = %w(
      atom
      chromedriver
      clipy
      docker
      free-ruler
      google-chrome-canary
      google-cloud-sdk
      java
      spectacle
      the-unarchiver
      vagrant
      visual-studio-code
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
