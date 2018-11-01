echo
# guard against pre-installed rubymine
brew cask install rubymine --force

source ${MY_DIR}/scripts/common/download-pivotal-ide-prefs.sh
pushd ~/workspace/pivotal_ide_prefs/cli
./bin/ide_prefs install --ide=intellij
./bin/ide_prefs install --ide=rubymine
popd
