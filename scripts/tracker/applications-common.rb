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
    ).join(" ")

    process_without_output("brew cask install #{things}")
  end
end

ApplicationsCommonTracker.new.run
