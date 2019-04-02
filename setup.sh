#!/usr/bin/env bash
#
# setup.sh:  run the Pivotal workstation setup
#
# Arguments:
#   - a list of components to install, see scripts/opt-in/ for valid options
#
# Environment variables:
#   - SKIP_ANALYTICS:  Set this to 1 to not send usage data to our Google Analytics account
#

# Fail immediately if any errors occur
set -e

echo "Caching password..."
sudo -K
sudo true;
clear

MY_DIR="$(dirname "$0")"
SKIP_ANALYTICS=${SKIP_ANALYTICS:-0}
if (( SKIP_ANALYTICS == 0 )); then
    clientID=$(od -vAn -N4 -tx  < /dev/urandom)
    source ${MY_DIR}/scripts/helpers/google-analytics.sh ${clientID} start $@
else
    export HOMEBREW_NO_ANALYTICS=1
fi

# Note: Homebrew needs to be set up first
source ${MY_DIR}/scripts/common/homebrew.sh
source ${MY_DIR}/scripts/common/configuration-bash.sh

# Run our custom bash configuration script.
source ${MY_DIR}/scripts/tracker/configuration-bash.sh

# Place any applications that require the user to type in their password here
brew tap caskroom/cask
brew cask install github
brew cask install zoomus

source ${MY_DIR}/scripts/common/git.sh

# Run our custom git configuration script.
source ${MY_DIR}/scripts/tracker/git.sh

source ${MY_DIR}/scripts/common/git-aliases.sh

# Run our custom git aliases script.
source ${MY_DIR}/scripts/tracker/git-aliases.sh

source ${MY_DIR}/scripts/common/cloud-foundry.sh
source ${MY_DIR}/scripts/common/applications-common.sh

# Install the Tracker desktop applications.
source ${MY_DIR}/scripts/tracker/applications-common.sh

source ${MY_DIR}/scripts/common/unix.sh

# Install the Tracker command line applications.
source ${MY_DIR}/scripts/tracker/unix.sh

source ${MY_DIR}/scripts/common/configuration-osx.sh
source ${MY_DIR}/scripts/common/configurations.sh

# Do configuration of macOS specific to Tracker.
source ${MY_DIR}/scripts/tracker/configuration-osx.sh

# Log in to LastPass and pull down the private SSH key.
set +e
source "${HOME}/.bash_profile"
set -e
echo "Enter your username for LastPass login (without @pivotal.io):"
read username

# TODO: try to use the alias instead of this.
loadkey_github ${username}

source ${MY_DIR}/scripts/tracker/app-store-setup.sh

# Do Ruby configuration
source ${MY_DIR}/scripts/tracker/configuration-ruby.sh

# Clone the Tracker repos.
source ${MY_DIR}/scripts/tracker/git-repos.sh
source ${MY_DIR}/scripts/tracker/tracker-setup.sh

# TODO: This is failing because of system ruby install permissions.  Disabling for now
# ${MY_DIR}/scripts/tracker/install-gitpflow.rb

# For each command line argument, try executing the corresponding script in opt-in/
#for var in "$@"
#do
#    echo "$var"
#    FILE=${MY_DIR}/scripts/opt-in/${var}.sh
#    echo "$FILE"
#    if [ -f $FILE ]; then
#        source ${FILE}
#    else
#       echo "Warning: $var does not appear to be a valid argument. File $FILE does not exist."
#    fi
#done

source ${MY_DIR}/scripts/tracker/finished.sh

if (( SKIP_ANALYTICS == 0 )); then
    source ${MY_DIR}/scripts/helpers/google-analytics.sh ${clientID} finish $@
fi
