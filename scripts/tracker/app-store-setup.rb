#!/usr/bin/env ruby

require_relative './base.rb'

class ApplicationsCommonTracker < TrackerConfigurationBase
  def run
    # Sign in to the App Store
    username = process_without_output("lpass show --sync=now 'Shared-Tracker Team - General/Labs Apple iTunes / AppStore' --username")
    password = process_without_output("lpass show --sync=now 'Shared-Tracker Team - General/Labs Apple iTunes / AppStore' --password")

    puts 'Please log in to the App Store...'
    puts 'Use the following credentials:'
    puts "Username: #{username}"
    puts "Password: #{password}"
    puts 'The script will wait until you have logged in. Please double check that the login succeeds.'

    process_without_output('open -a "/Applications/App Store.app"')

    # Wait until signin is complete
    sleep(5) until signed_in

    # Install Xcode
    puts 'Installing Xcode. This will take a long time... Do not exit this script.'
    process_without_output('mas install 497799835')

    # Accept the license agreement
    process_without_output('sudo xcode-select -s /Applications/Xcode.app/Contents/Developer/')
    process_without_output('sudo xcodebuild -license accept')
  end

  def signed_in
    output = process_without_output('mas account', expected_exit_status: [0, 1], log: false)
    !output.include?('Not signed in')
  end
end

ApplicationsCommonTracker.new.run
