# Tracker Workstation Setup

This project automates the process of setting up a new Pivotal machine using a simple [Bash](https://www.gnu.org/software/bash/) script.

# PLEASE SEE [THE CONTRIBUTING_TRACKER.md DOC](CONTRIBUTING_TRACKER.md) BEFORE SUGGESTING CHANGES OR MODIFYING THIS REPO 

## Getting Started

* Follow the steps in [Image a Workstation](https://github.com/pivotaltracker/tracker-docs/blob/master/image-a-workstation.md).
* Open up Terminal.app and run the following command:

```sh
curl -s https://raw.githubusercontent.com/pivotaltracker/workstation-setup/master/bootstrap.rb -o /tmp/bootstrap.rb && chmod +x /tmp/bootstrap.rb && /tmp/bootstrap.rb && cd ~/workspace/workstation-setup && ./setup.sh
```

### Engineering Machine

If you're setting up an engineering machine choose which languages to install:

```sh
# For Labs developers (remove unnecessary languages when running command)
./setup.sh java ruby node golang c docker

# For Data developers
./setup.sh c golang java docker

# If you want java 8, you can use
./setup.sh java8
```

The list of Engineering applications is found in: [applications-common.sh](https://github.com/pivotal/workstation-setup/blob/master/scripts/common/applications-common.sh)

### Designer Machine

If you're setting up a design machine run the following:

```sh
./setup.sh designer
```

In addition to the Engineering applications, this script also installs the list of Design applications found in: [applications-designer.sh](https://github.com/pivotal/workstation-setup/blob/master/scripts/opt-in/designer.sh)

### XP Workshop

If you're setting up a machine for the XP workshop run the following:

```sh
./setup.sh java8 node
```

## Analytics

The tool will send anonymous user data to our Google Analytics account, so we can see what command line arguments are popular.  You can disable this:
```
# Remove unnecessary languages when running command
SKIP_ANALYTICS=1 ./setup.sh java ruby node golang c docker
```
This will also disable brew's [data collection](https://github.com/Homebrew/brew/blob/master/docs/Analytics.md).

## Having problems?

If you're having problems using the setup script, please let us know by [opening an issue](https://github.com/pivotal/workstation-setup/issues/new).

If you see errors from `brew`, try running `brew doctor` and include the diagnostic output in your issue submission.

## Customizing

If you'd like to customize this project for a project's use:

- Fork the project
- Edit the shells scripts to your liking
- Profit

## Frequently Asked Questions

### Is it okay to run `./designer.sh` command again?

Yes. The script does not reinstall apps that are already on the machine.

### What about sprout-wrap?

This project is provided as an alternative to the [pivotal-sprout/sprout-wrap](https://github.com/pivotal-sprout/sprout-wrap) project. You are encouraged to use that project if it better suits your needs.

The goals of this projects is to keep the setup process simple and up to date:

Please see [this GitHub issue](https://github.com/pivotal/workstation-setup/issues/3) for more discussion on the subject.
