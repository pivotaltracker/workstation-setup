
save_function() {
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

save_function prompt_command old_prompt_comand
save_function ruby_version_prompt old_ruby_version_prompt

function __cf_prompt() {
  if test -e "${CF_HOME:-$HOME}/.cf/config.json" ; then
    echo "cf:$(jq --raw-output '.OrganizationFields.Name + "/" + .SpaceFields.Name' < ${CF_HOME:-$HOME}/.cf/config.json)"
  fi
}

function ruby_version_prompt() {
  echo "$(old_ruby_version_prompt)${reset_color}${red} $(__cf_prompt)"
}

function set_term_color() {
  /usr/bin/osascript <<DOC
  tell application "iTerm"
    tell the current window
        tell the current session
          set background color to {${1}}
        end tell
    end tell
end tell
DOC
}

function get_term_color() {
 /usr/bin/osascript <<DOC
  tell application "iTerm"
    tell the current window
        tell the current session
          get background color
        end tell
    end tell
end tell
DOC
}

# if the color of the prompt is annoying you just run `export NO_PROD_COLOR=false`
# this will only work for the current color scheme if that changes this will need to as well
function prompt_command() {
  old_prompt_comand
  if [[ $(__cf_prompt) =~ production\/ ]] && [[ $NO_PROD_COLOR == '' ]]; then
    set_term_color '15000, 0, 0'
  elif [[ $NO_PROD_COLOR == '' ]]; then
    set_term_color "7391, 9663, 10884"
  fi
}


