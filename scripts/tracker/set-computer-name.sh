echo
echo "Type this computer's name. Then press the `return/enter` key:"
read computer_name

sudo scutil --set ComputerName ${computer_name}
sudo scutil --set HostName ${computer_name}
sudo scutil --set LocalHostName ${computer_name}
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string ${computer_name}
