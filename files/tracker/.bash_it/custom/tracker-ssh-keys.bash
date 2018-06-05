function _tracker_user_hook() {
  if [ -s "${HOME}/.tracker_user" ]; then
    export TRACKER_USER=$(cat "${HOME}/.tracker_user")
  fi
}
if ! [[ "$PROMPT_COMMAND" =~ _tracker_user_hook ]]; then
  PROMPT_COMMAND="_tracker_user_hook;$PROMPT_COMMAND";
fi

function _load_ssh_key_from_lastpass() {
  keytype=$1
  username=$2

  if [ -z "${username}" ]; then
    echo "Must supply your lastpass login without '@pivotal.io'. E.g. 'goppegard'."
    return
  fi

  tmpdir=$(mktemp -d -t lpass)
  export LPASS_HOME=$tmpdir

  trap 'lpass logout --force; rm -rf "${tmpdir}"' EXIT INT TERM HUP

  private_key_name="${keytype}_${username}"
  private_key_path="${tmpdir}/${private_key_name}"
  lifetime='10H'
  if [ "${keytype}" = 'prod' ]; then
    lifetime='9H'
  fi

  mkfifo -m 0600 "${private_key_path}"
  lpass login "${username}@pivotal.io"
  lpass show --notes ${username}_${keytype} > "${private_key_path}" &
  ssh-add -t "${lifetime}" "${private_key_path}"
  echo "${username}" > "${HOME}/.tracker_user"

  # Clean up
  rm -rf "${tmpdir}"
  unset LPASS_HOME
  unset LPASS_AGENT_DISABLE
  trap - EXIT INT TERM HUP
}

function _load_github_ssh_key_from_lastpass() {
  username=$1
  note_path="Shared-Tracker Team - General/tracker-common"

  if [ -z "${username}" ]; then
    echo "Must supply your lastpass login without '@pivotal.io'. E.g. 'goppegard'."
    return
  fi

  tmpdir=$(mktemp -d -t lpass)
  private_key_path="${tmpdir}/tracker-common"

  trap 'lpass logout --force;' EXIT INT TERM HUP

  lifetime='10H'

  mkfifo -m 0600 "${private_key_path}"
  lpass login "${username}@pivotal.io"
  lpass show --field="Private Key" "${note_path}" > "${private_key_path}" &
  ssh-add -t "${lifetime}" "${private_key_path}"

  lpass show --notes "${note_path}" > "${HOME}/.config/hub"

  # Clean up
  trap 'lpass logout --force; rm -rf "${tmpdir}"' EXIT INT TERM HUP
}

alias nonprod='_load_ssh_key_from_lastpass nonprod'
alias prod='_load_ssh_key_from_lastpass prod'
alias loadkey='_load_github_ssh_key_from_lastpass'
