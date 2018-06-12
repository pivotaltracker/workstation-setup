# Bash functions, aliases, etc. for the platform
# See also tracker-common.bash and tracker-frontend.bash

export API_HOST='http://localhost:3000'
export API_TOKEN=7f6ac05a103d99ab8f551e54159199b5         # "jdoe" fixture token
export API_PROJECT_ID=1                                   # "Microsoft Excel" fixture project
export API_TOKEN_FOR_SUSPENDED_USER=27cb9f2c1e6110f6bf8b501a8a1e03fd

function snapshot {
  mkdir -p ~/.database-snapshots
  if [[ -n "$1" ]]
  then mysqldump -uroot -ppassword t2_dev > ~/.database-snapshots/$1.sql
  else mysqldump -uroot -ppassword t2_dev > ~/.database-snapshots/t2_dev.sql
  fi
}

function restore {
  mkdir -p ~/.database-snapshots
  if [[ -n "$1" ]]
  then mysql -uroot -ppassword t2_dev < ~/.database-snapshots/$1.sql
  else mysql -uroot -ppassword t2_dev < ~/.database-snapshots/t2_dev.sql
  fi
}

function expire {
    for id in "$@"
    do
        curl -X POST -H 'X-TrackerToken: RobsToken' "http://localhost:3000/services/area_51/projects/$id/expire_cache"
    done
}
