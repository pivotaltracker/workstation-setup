function git() {
    if [[ "$1" == commit ]] ; then
      shift
      command git duet-commit "$@"
    elif [[ "$1" == merge ]] ; then
      shift
      command git duet-merge "$@"
    elif [[ "$1" == revert ]] ; then
      shift
      command git duet-revert "$@"
    else
      command hub "$@"
    fi
}
export -f git
