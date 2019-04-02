echo
echo "Setting up the computer to run the Tracker app"

# Force link mysql@5.7
brew link --force mysql@5.7
brew services start mysql@5.7

# Wait for mysql to start
while [[ mysql_running -eq 1 ]]; do
 sleep 5
done

# Change root password
mysqladmin -u root password password

# Install ruby
ruby_version=$(cat ${HOME}/workspace/tracker/apps/tracker-web/.ruby-version)
echo "Installing Ruby tools and Ruby ${ruby_version}"

eval $(rbenv init -)
rbenv install --skip-existing ${ruby_version}
rbenv global ${ruby_version}
rbenv rehash
gem install bundler -v 1.17.3

# Bundle in the Tracker app
cd ${HOME}/workspace/tracker/apps/tracker-web && bundle install && cd -

# Run direnv allow on all directories that require it
filename_globs=$(ls ${HOME}/workspace/tracker/apps/tracker-web/**/.envrc)
for filename in ${filename_globs}; do
  cd $(dirname ${filename}) && direnv allow && cd -
done

function mysql_running {
  return $(pgrep mysql)
}
