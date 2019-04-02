echo
echo "Running Tracker bash configuration"

cp files/tracker/.inputrc ${HOME}/.inputrc

cp -rf files/tracker/.bash_it/ ${HOME}/.bash_it/

sed -i -e "s/^export BASH_IT_THEME=.*$/export BASH_IT_THEME='bobby-tracker'/" ${HOME}/.bash_profile

source ${HOME}/.bash_profile
bash-it enable alias bundler
bash-it enable completion git
bash-it enable completion ssh
bash-it enable plugin alias-completion
bash-it enable plugin docker
bash-it enable plugin ssh

echo
echo "Completed Tracker-specific bash configuration"
