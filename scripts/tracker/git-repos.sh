echo
echo "Cloning Tracker git repos"

git clone git@github.com:pivotaltracker/app_env.git            ${HOME}/workspace/app_env
git clone git@github.com:pivotaltracker/app_env_secret_nonprod ${HOME}/workspace/app_env_secret_nonprod
git clone git@github.com:pivotaltracker/checkfiles             ${HOME}/workspace/checkfiles
git clone git@github.com:pivotaltracker/gitpflow               ${HOME}/workspace/gitpflow
git clone git@github.com:pivotaltracker/lib-tracker-proxy      ${HOME}/workspace/lib-tracker-proxy
git clone git@github.com:pivotaltracker/pivotal_ide_prefs      ${HOME}/workspace/pivotal_ide_prefs
git clone git@github.com:pivotaltracker/tracker-android        ${HOME}/workspace/tracker-android
git clone git@github.com:pivotaltracker/tracker-ios            ${HOME}/workspace/tracker-ios
git clone git@github.com:pivotaltracker/tracker-knowledge-base ${HOME}/workspace/tracker-knowledge-base
git clone git@github.com:pivotaltracker/tracker-marketing      ${HOME}/workspace/tracker-marketing
git clone git@github.com:pivotaltracker/tracker-vcr            ${HOME}/workspace/tracker-vcr

git clone git@github.com:pivotaltracker/tracker                ${HOME}/workspace/tracker
cd ${HOME}/workspace/tracker/apps/tracker-web && direnv allow && cd -

cp -r ${HOME}/workspace/tracker ${HOME}/workspace/alt-tracker
cd ${HOME}/workspace/alt-tracker/apps/tracker-web && direnv allow && cd -

git clone git@github.com:pivotaltracker/app_env_secret_nonprod ${HOME}/.app_env_secret
ln -s ${HOME}/.app_env_secret/keys/npmrc ${HOME}/.npmrc
