# Bash functions, aliases, etc. for the tracker team
# See also tracker-frontend.bash and tracker-platform.bash

export WORKSPACE=${WORKSPACE:-$HOME/workspace}
export ENV_DIRECTORY="${WORKSPACE}/p-tracker/config/environments"

function update_git_repos() {
  local green="\033[0;32m"
  local red="\033[0;31m"
  local none="\033[0m"

  find ${WORKSPACE} -name .git -type d -prune -depth 2 | while read git_dir; do
    cd $git_dir/.. 2>/dev/null # ignore stderr to supress RVM
    echo -e "Pulling: ${green}${PWD}${none}"
    git pull --prune
    cd $OLDPWD
  done
}
export -f update_git_repos
