echo
echo "Doing Tracker specific macOS configuration"

# Set dark mode
if osascript -e 'tell application "System Events" to tell appearance preferences to get properties' | rg 'dark mode:false' > /dev/null; then
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
fi

# Set hot corners
sudo -u ${USER} defaults write ${HOME}/Library/Preferences/com.apple.dock.plist wvous-tr-corner -int 5
sudo -u ${USER} defaults write ${HOME}/Library/Preferences/com.apple.dock.plist wvous-tr-modifier -int 0

# Copy Library configurations
cp -r files/tracker/Library/ ${HOME}/Library

# Update the system clock
# See http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
defaults write com.apple.menuextra.clock "DateFormat" "MMM d h:mm:ss a"
killall SystemUIServer

# Modify appearance of dock
# remove existing icons
IFS=$'\n'
for app in $(dockutil --list | cut -f1); do
  dockutil --remove "${app}" --no-restart
done
unset IFS

# add desired applications
dockutil --add /Applications/Launchpad.app --no-restart
dockutil --add /Applications/iTerm.app --no-restart
dockutil --add /Applications/Google\ Chrome.app --no-restart
dockutil --add /Applications/Google\ Chrome\ Canary.app --no-restart
dockutil --add /Applications/Safari.app --no-restart
dockutil --add /Applications/Firefox.app --no-restart
dockutil --add /Applications/Sublime\ Text.app --no-restart
dockutil --add /Applications/Atom.app --no-restart
dockutil --add /Applications/System\ Preferences.app --no-restart
dockutil --add /Applications/zoom.us.app --no-restart

# add spacers after each of these apps
apps=( iTerm Firefox )
for app in "${apps[@]}"; do
  dockutil --add '' --type spacer --section apps --after ${app} --no-restart
done

defaults write com.apple.dock orientation -string bottom
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock tilesize -int 50

# Restart the dock
killall Dock

# Setup the daily script
launchctl load -w -F files/tracker/com.pivotaltracker.workstationsetup.daily.plist
launchctl load -w -F files/tracker/com.pivotaltracker.workstationsetup.clear_pairs_and_logs.plist

# Enable Spectacle as a login item
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Spectacle.app", hidden:false}' > /dev/null

# Keyboard Configuration
defaults write -g AppleKeyboardUIMode -int 2 # Full Keyboard Access: All controls
defaults write -g com.apple.keyboard.fnState -int 1 # Sane function keys

# Mouse Configuration
# enable secondary click
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton
defaults write com.apple.AppleMultitouchMouse MouseButtonMode TwoButton

# Printer Configuration
ppd='/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/Generic.ppd'
lpadmin -p Galactus -L Southeast -E -v 'lpd://galactus.den.pivotal.io' -P "${ppd}" -o printer-is-shared=false -o APOptionalDuplexer=true

# Finder Configuration
defaults write -g AppleShowAllExtensions -bool true
chflags nohidden ~/Library
defaults write com.apple.finder AppleShowAllFiles true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/workspace"
killall Finder

# Safari Configuration
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write -g WebKitDeveloperExtras -bool true

# Screen sharing configuration
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# Menu Bar Configuration
open '/System/Library/CoreServices/Menu Extras/Bluetooth.menu' # show Bluetooth menu
