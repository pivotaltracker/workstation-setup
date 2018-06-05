#!/usr/bin/env ruby

require_relative './base.rb'

class ApplicationsCommonTracker < TrackerConfigurationBase
  def run
    process_without_output('brew tap homebrew/cask-versions')
    things = %w(
      atom
      chromedriver
      clipy
      docker
      free-ruler
      google-chrome-canary
      google-cloud-sdk
      istat-menus5
      java8
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
