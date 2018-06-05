#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureOSXTracker < TrackerConfigurationBase
  def run
    set_dark_mode
    set_hot_corner

    # Copy Library configurations
    FileUtils.cp_r("#{repo_root}/files/tracker/Library/.", "#{home}/Library")

    # Update the system clock
    # See http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
    process_without_output('defaults write com.apple.menuextra.clock "DateFormat" "MMM d h:mm:ss a"')
    process_without_output('killall SystemUIServer')

    # Modify appearance of dock
    # remove existing icons
    process_dockutil('--remove spacer-tiles --no-restart')
    process_dockutil('--list').split("\n").each do |line|
      application = line.split("\t")[0]
      process_dockutil("--remove \"#{application}\" --no-restart")
    end

    # add desired applications
    apps = [
      'Launchpad',
      'iTerm',
      'Google Chrome',
      'Google Chrome Canary',
      'Safari',
      'Firefox',
      'Sublime Text',
      'Atom',
      'System Preferences',
      'zoom.us',
    ]
    apps.each do |app|
      process_dockutil("--add \"/Applications/#{app}.app\" --no-restart")
    end

    # add spacers after each of these apps
    ['iTerm', 'Firefox'].each do |app|
      process_dockutil("--add '' --type spacer --section apps --after '#{app}' --no-restart")
    end

    process_without_output('defaults write com.apple.dock orientation -string bottom')
    process_without_output('defaults write com.apple.dock magnification -bool false')
    process_without_output('defaults write com.apple.dock tilesize -int 50')

    # Restart the dock
    process_without_output('killall Dock')

    # Setup the daily script
    process_without_output("launchctl load -w -F #{repo_root}/files/tracker/com.pivotaltracker.workstationsetup.daily.plist")
    process_without_output("launchctl load -w -F #{repo_root}/files/tracker/com.pivotaltracker.workstationsetup.clear_pairs_and_logs.plist")

    # Enable Spectacle as a login item
    process_without_output("osascript -e 'tell application \"System Events\" to make login item at end with properties {path:\"/Applications/Spectacle.app\", hidden:false}'")

    # Keyboard Configuration
    process_without_output('defaults write -g AppleKeyboardUIMode -int 2') # Full Keyboard Access: All controls
    process_without_output('defaults write -g com.apple.keyboard.fnState -int 1') # Sane function keys

    # Mouse Configuration
    # enable secondary click
    process_without_output('defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton')
    process_without_output('defaults write com.apple.AppleMultitouchMouse MouseButtonMode TwoButton')

    # Printer Configuration
    ppd = '/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/Generic.ppd'
    process_without_output("lpadmin -p Galactus -L Southeast -E -v 'lpd://galactus.den.pivotal.io' -P '#{ppd}' -o printer-is-shared=false -o APOptionalDuplexer=true")

    # Finder Configuration
    process_without_output('defaults write -g AppleShowAllExtensions -bool true')
    process_without_output('chflags nohidden ~/Library')
    process_without_output('defaults write com.apple.finder AppleShowAllFiles true')
    process_without_output('defaults write com.apple.finder ShowPathbar -bool true')
    process_without_output('defaults write com.apple.finder NewWindowTarget -string "PfLo"')
    process_without_output('defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/workspace"')
    process_without_output('killall Finder')

    # Safari Configuration
    process_without_output('defaults write com.apple.Safari IncludeInternalDebugMenu -bool true')
    process_without_output('defaults write com.apple.Safari IncludeDevelopMenu -bool true')
    process_without_output('defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true')
    process_without_output('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true')
    process_without_output('defaults write -g WebKitDeveloperExtras -bool true')

    # Screen sharing configuration
    process_without_output('sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false')
    process_without_output('sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist')

    # Menu Bar Configuration
    process_without_output("open '/System/Library/CoreServices/Menu Extras/Bluetooth.menu'") # show Bluetooth menu
  end

  def process_dockutil(command)
    process_without_output("dockutil #{command}")
  end

  def set_hot_corner
    process_without_output("sudo -u #{ENV.fetch('USER')} defaults write #{home}/Library/Preferences/com.apple.dock.plist wvous-tr-corner -int 5")
    process_without_output("sudo -u #{ENV.fetch('USER')} defaults write #{home}/Library/Preferences/com.apple.dock.plist wvous-tr-modifier -int 0")
  end

  def set_dark_mode
    appearance_properties = process_without_output("osascript -e 'tell application \"System Events\" to tell appearance preferences to get properties'")
    dark_mode = appearance_properties =~ /dark mode:true/
    unless dark_mode
      process_without_output("osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'")
    end
  end
end

ConfigureOSXTracker.new.run
