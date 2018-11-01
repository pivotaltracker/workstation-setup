# Tracker Workstation Setup

This project automates the process of setting up a new Pivotal machine using a simple [Bash](https://www.gnu.org/software/bash/) script.

# PLEASE SEE [THE CONTRIBUTING_TRACKER.md DOC](CONTRIBUTING_TRACKER.md) BEFORE SUGGESTING CHANGES OR MODIFYING THIS REPO

## Core Principles

* Prefer the defaults (or more sameness) to eliminate controversy and conflict 
  * Always prefer the default keymaps/shortcuts/settings
* If default keymaps conflict, the ones defined in the primary developer tools (Jetbrains IDEs) and/or designer tools (Sketch/Photoshop/etc) should win and not be overridden by other apps
* Base tracker workstation setup has minimal changes on top of standard workstation-setup, only stuff that is truly necessary and/or useful across all pods.
* Customizations on the main workstations should be disjoint, i.e. don't write code that automatically reverts a config or setting from the base setup; instead open a discussion about changing or removing the default.
* Keep it simple, stupid!

## Getting Started
**We recommend you use the pre-created workstation-setup image on DeployStudio. To do so, please follow the steps in
[Image a Workstation](https://docs.trackernonprod.com/#general/image-a-workstation/).**

### Manually running workstation-setup
If you are developing workstation-setup or want to add customizations to it for your own laptop you will need to run
workstation-setup manually.

1. Follow steps 1-8 in
   [Image a Workstation](https://docs.trackernonprod.com/#general/image-a-workstation/).
   However, on step 5, choose *Individual Workstation High Sierra*.
1. Open up `Terminal.app` and run the following command:

    ```sh
    curl -s https://raw.githubusercontent.com/pivotaltracker/workstation-setup/master/bootstrap.rb -o /tmp/bootstrap.rb && chmod +x /tmp/bootstrap.rb && /tmp/bootstrap.rb && cd ~/workspace/workstation-setup && ./setup.sh
    ```
1. Follow the instructions in [Post-Install Steps Before Cutting an image](#post-install-steps-before-cutting-an-image)
   and [Post-Imaging Steps](#post-imaging-steps).

1. If the setup fails with an error around NVM or Node, install Node 10 and try the script again
    ```sh
    nvm install 10
    ```
## Post-Install Steps Before Cutting an image
Run these steps only if you are in the process of cutting a fresh DeployStudio image

## Workstation Setup Repo
Change the remote to be writable
```bash
cd ~/workspace/workstation-setup
git remote set-url origin git@github.com:pivotaltracker/workstation-setup.git
```

## Google Chrome and Google Chrome Canary setup:
1. Sign in to Google Chrome
    1. Click on the profile icon in the upper right of Chrome and click the *Sign in to Chrome* button
    1. Log in with the `tracker.remote1` username and password found in LastPass
    1. Move the LastPass and Okta extensions to the left of the other ones
    1. Right click on all other extensions and click *Hide in Chrome Menu*
    1. Navigate to `chrome://extensions/`
    1. Click on *Details* on the LastPass extension
    1. Turn on *Allow in incognito*
1. Set up Google Chrome Canary in the same way as above

## Deploy Spy Configuration
Follow steps in [Tracker Docs](https://docs.trackernonprod.com/#general/configure-deploy-spy/)

## ITerm2 Configuration
Open Preferences:
1. Appearance -> Tabs: Check "Show tab bar even when there is only one tab"
1. Profiles -> Default -> General -> Working Directory: Select "Reuse previous session's directory"
1. Profiles -> Default -> Terminal -> Scrollback Buffer -> Scrollback lines: Check
   "Unlimited Scrollback"

## IDE Installation and Launchers:
1. Open RubyMine
1. In the menu bar, click `Tools -> Create Command-line Launcher...` then click `OK` (note you may
   need to click `OK` to override if a script already exists.)
1. Open IntelliJ
1. In the menu bar, click `Tools -> Create Command-line Launcher...` then click `OK` (note you may
   need to click `OK` to override if a script already exists.)

## IntelliJ and Rubymine Common Manual Setup

For each IDE:

### Preferences
Open `Preferences` and change the following settings:

* Appearance & Behavior
  * Appearance
    * Check *Override default fonts by (not recommended)*
    * Change the font size to 14
* Editor
  * General
    * Set *Maximum number of contents to keep in clipboard* to `100`

### Plugins
Open `Preferences -> Plugins`.

* **Install** the following plugins
  * File Watchers
  * BashSupport
  * .ignore
  * Autoscroll Save
  * Presentation Assistant (Possibly visually noisy, can remove we get negative feedback)
* **Disable** the following plugins
  * CVS Integration
  * Haml
  * Perforce Integration
  * UML Support
  * Stylus support
  * Subversion integration
* **Restart the IDE**
* **Configure Plugins** the following plugins  
  * Autoscroll Save
    * Click the gear in the Project Pane (Cmd-1)
    * Check `Autoscroll to Source`
    * Check `Autoscroll from Source`
    * Click `File -> Autoscroll Save`

## RubyMine-Specific Manual Setup

### Preferences
Open `Preferences` and change the following settings:

* Set `Editor -> Color Scheme -> Ruby -> Line Continuation -> Background` to `3B3B3B`

### Plugins
Open `Preferences -> Plugins`.

* **Disable** the following plugins
  * Puppet Support
  * Ruby Slim Support Integration
  * Ruby UML Support Integration
  * Slim

* Restart Rubymine to activate new plugins

## IntelliJ-Specific Manual Setup

### Preferences
Open `Preferences` and change the following settings:

* Editor
  * Code Style
    * Turn off *Detect and use existing file indents for editing*
    * Java
      * Set *Continuation indent* to `4`
    * Other File Types
      * Set *Tab size* to `2`
      * Set *Indent* to `2`
  * `General -> Smart Keys`
    * Turn on *Surround selection on typing quote or brace*
  * `Inspections -> Kotlin -> Naming Conventions -> Class naming convention`
    * Set *Pattern* to `[A-Za-z][A-Za-z\d]*`

### Plugins
Open `Preferences -> Plugins`.

* Add the Ruby plugin

## System Preferences
1. Open `System Preferences`
1. Go to `Security & Privacy -> General`
    - Make sure that `Require password` is checked
    - Select `5 seconds` from the dropdown
1. Go to `Accessibility -> Zoom`
    - Check *Use scroll gesture with modifier keys to zoom*
    - Ensure that *^ Control* is selected in the dropdown
1. Go to `Accessibility -> Mouse & Trackpad`
    - Click on `Trackpad Options...` and check `Enable Dragging` and set it to `Three Finger Drag`
1. Go to `Energy Saver -> Power Adapter`
    - Check on `Prevent computer from sleeping automatically when the display is off`

## Key Repeat Enable
* `defaults write -g ApplePressAndHoldEnabled -bool false`

## Clipy
1. Change Clipy main shortcut to "Ctrl-Option-Cmd-V" so it doesn't override Jetbrains default keystroke
  for clipboard.

## Wi-Fi
1. Click on the Wi-Fi icon.
1. Click "Turn Wi-Fi Off"

## Licenses
### Sublime Text
1. Open Sublime Text
1. Click `Help -> Enter License`
1. Enter the license from LastPass (under
   `Shared-Tracker Team - General/Software Licenses/Sublime Text 3`)

### iStat Menus
1. Open iStat Menus
1. Click *Install*
1. Enter the user's password
1. Click *OK*
1. Click *Register*
1. Enter the iStat Menus serial number from LastPass (under
   `Shared-Tracker Team - General/Software Licenses/iStats Menu Serial Number`)
1. Press *Check For Updates*
1. Press *Skip This Version*

## Finder
1. Open Finder.
1. Click `Finder -> Preferences...`.
1. Set the following preferences:
    - Prefs - General
      - Uncheck Open folders in tabs
    - Prefs - Sidebar - disable all except
      - Applications
      - Desktop
      - Documents
      - Downloads
      - Home (Pivotal)
      - Connected Servers
      - Hard disks
      - External Disks
      - CDs, DVDs and iPods (this includes mounted .dmg files so we need it)
    - Advanced
      - Ensure everything is checked
1. In a Finder window:
    - Set "Applications" to be list view.

## Zoom
1. Launch Zoom meeting from Chrome bookmarks bar
    - Click "remember my choice" on the *External Protocol Request* popup
1. Click `zoom.us -> Preferences...`
1. Set the following preferences:
    - General
      - Uncheck *Use dual monitors*
      - Uncheck *Enter full screen automatically when starting or joining a meeting*
    - Audio
      - Check *Automatically join audio by computer*
      - Uncheck *Automatically adjust microphone settings*

## Spectacle
1. Launch the Spectacle app
1. Follow the instructions to give it Accessibility permissions

## Cleanup
1. Clear Chrome and Safari browser histories
1. Remove SSH keys (`ssh-add -D`)
1. Log out of `lpass`, if applicable
1. Clear bash history (`history -c`)

# Post-Imaging Steps
Run these steps after imaging a machine

## Set the computer name

Open up iTerm and run the following command:
```sh
$HOME/workspace/workstation-setup/scripts/tracker/set-computer-name.rb
```
