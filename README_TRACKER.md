# Tracker Workstation Setup

This project automates the process of setting up a new Pivotal machine using a simple [Bash](https://www.gnu.org/software/bash/) script.

# PLEASE SEE [THE CONTRIBUTING_TRACKER.md DOC](CONTRIBUTING_TRACKER.md) BEFORE SUGGESTING CHANGES OR MODIFYING THIS REPO 

## Getting Started

* Follow the steps in [Image a Workstation](https://github.com/pivotaltracker/tracker-docs/blob/master/general/image-a-workstation.md).
* Open up Terminal.app and run the following command:

```sh
curl -s https://raw.githubusercontent.com/pivotaltracker/workstation-setup/master/bootstrap.rb -o /tmp/bootstrap.rb && chmod +x /tmp/bootstrap.rb && /tmp/bootstrap.rb && cd ~/workspace/workstation-setup && ./setup.sh
```
