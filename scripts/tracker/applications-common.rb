#!/usr/bin/env ruby

require_relative './base.rb'

class ApplicationsCommonTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    process('brew tap homebrew/cask-versions')
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
  end
end

ApplicationsCommonTracker.new.run
