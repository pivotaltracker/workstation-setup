echo
echo "Setting up Tracker rubygems configuration"

sudo cp files/tracker/gemrc /etc/gemrc
ln -sf /etc/gemrc ${HOME}/.gemrc
