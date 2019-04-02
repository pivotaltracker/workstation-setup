echo
echo "Setting up unix tools for Tracker"

brew tap pivotaltracker/homebrew-tracker

brew install ack
brew install awscli
brew install bash
brew install cloudfoundry/tap/cf-cli
brew install cmake
brew install coreutils
brew install ctags
brew install direnv
brew install ghostscript
brew install git
brew install git-duet/tap/git-duet
brew install glide
brew install gnupg
brew install go
brew install gradle
brew install haproxy
brew install htop
brew install httpie
brew install hub
brew install icu4c
brew install imagemagick
brew install ios-sim
brew install jmeter
brew install jq
brew install jsonpp
brew install lastpass-cli
brew install mas
brew install memcached
brew install mysql@5.7
brew install neovim
brew install nvm
brew install parallel
brew install proctools
brew install pstree
brew install python@2
brew install redis
brew install s3cmd
brew install shellcheck
brew install solr@6.6
brew install ssh-copy-id
brew install ripgrep
brew install tmux
brew install tree
brew install watch
brew install wget
brew install yarn
brew install zlib

brew link --force solr@6.6

pip install virtualenv

# Copy .vimrc file
cp files/tracker/.vimrc ${HOME}/.vimrc

# Copy my.cnf file
cp files/mysql/my.cnf /usr/local/etc/my.cnf

wget -O /usr/local/bin/fly 'https://cd.gcp.trackerred.com/api/v1/cli?arch=amd64&platform=darwin'
chmod +x /usr/local/bin/fly
