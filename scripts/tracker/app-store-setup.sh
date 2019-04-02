echo
echo "Running Tracker app store setup"

# Sign in to the Apple Store
username=$(lpass show --sync=now 'Shared-Tracker Team - General/Labs Apple iTunes / AppStore' --username)
password=$(lpass show --sync=now 'Shared-Tracker Team - General/Labs Apple iTunes / AppStore' --password)

echo "please log in to the App Store..."
echo "Use the following credentials:"
echo "Username: ${username}"
echo "Password: ${password}"
echo "The script will wait until you have logged in. Please double check that the login succeeds."

open -a /Applications/App\ Store.app

# Wait until signin is complete
while mas account | grep 'Not signed in'; do
  sleep 5
done

# Install Xcode
echo "Installing Xcode. This will take a long time... Do not exit this script."
mas install 497799835

# Accept the Xcode license
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer/
sudo xcodebuild -license accept
