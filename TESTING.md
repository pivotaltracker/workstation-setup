# Running a High Sierra VM for Workstation Setup testing

1. Install VMware Fusion from the "Self Service" application.  Open Finder, go to Applications, and run it.
1. Run the VMware Fusion app that was installed under Applications.
1. Install the macOS High Sierra installer from the Mac App Store
1. Open VMWare Fusion
	- Update to 8.5.10 if prompted.  ***NOTE:*** You may automatically get a prompt to update to version 10. ***Close*** this prompt, and instead use the VMware Fusion app menu "Check for Updates", which should prompt you to update to 8.5.10.
1. Click the "+" and select "New..."
1. Drag and drop the "Install macOS High Sierra.app" bundle onto the "Create New Virtual Machine" prompt presented by VMWare Fusion
1. Click "Continue"
1. Select "Apple OS X > macOS 10.12" as the Operating System type and click "Continue"
1. Click "Finish" and save the VM disk
1. Wait for the Installation Medium to be created
1. Start the Virtual Machine
1. Select your language
1. Choose "Install macOS"
1. Follow the prompts until you see the installation progress bar
1. Go through the device setup on the "Welcome" screen
	- Skip signing into iCloud for now
	- Use "pivotal" for the name and username and "How6wow;" for the password
1. Once on the desktop, go to "Virtual Machine > Install VMWare Tools" and then click on the "Install VMware Tools" icon
1. Once the tools are installed and the machine has restarted, take a snapshot via the "Virtual Machine > Snapshots > Take a Snapshot" option in the menu
	- If the option is greyed out, go to "Snapshots" and then take a new snapshot from the current VM state.
	- This allows you to go back to a fresh machine state to re-test workstation-setup
1. Follow the workstation-setup docs on setting up the "new machine" from here
