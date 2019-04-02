echo
echo "Setting up Tracker git configuration"

cp files/tracker/.git-authors ${HOME}/.git-authors

git config --global pull.rebase preserve
git config --global push.default current
git config --global user.email labs-tracker-team@pivotal.io
git config --global user.name Pivotal Tracker
git config --global fsck.zeroPaddedFileMode ignore
git config --global --unset transfer.fsckobjects

mkdir -p ${HOME}/.ssh
cp files/tracker/.ssh/known_hosts ${HOME}/.ssh/known_hosts
chmod 0600 ${HOME}/.ssh/known_hosts
