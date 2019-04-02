echo
echo "Finishing up workstation setup"

# Configure default browser
if ! files/tracker/defaultbrowser-1.1 | grep '\* chrome' > /dev/null; then
  osascript -e "with timeout of 1000000 seconds" -e "tell application (path to frontmost application as text) to display dialog \"Select \\\"Use Chrome\\\"\" buttons {\"OK\"}" -e "end timeout"
  files/tracker/defaultbrowser-1.1 chrome
fi

echo "\nNow, continue setting up the workstation by following the instructions"
echo "in the workstation-setup README:"
echo "    https://github.com/pivotaltracker/workstation-setup/blob/master/README_TRACKER.md"
echo "--------------------------------------------------"
echo "Done! Workstation setup completed successfully."
echo "--------------------------------------------------"
