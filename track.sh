#!/bin/bash

# $1=name $2=url

function log_add() {
  echo " + [$1]($2): v$3" >> .log_add
}

function log_update() {
  echo " + [$1]($2): v$3 => v$4" >> .log_update
}

function track() {
  version_remote=`lastversion "$2" 2>/dev/null`
  version_local=`cat .version 2>/dev/null | grep -E "^$1==" | cut -d '=' -f 3 `

  if [[ "x$version_remote" = "x" ]]; then
    echo "[$1] Oops, get remote version failed"
    exit -1
  fi

  # if no current version
  if [[ "x$version_local" = "x" ]]; then
    echo "[$1] New track, latest version is $version_remote"
    log_add $1 $2 $version_remote
    echo "$1==$version_remote" >> .version
    return
  fi

  version_newer=`lastversion "$version_remote" -gt "$version_local"`

  if [[ "x$version_local" = "x$version_remote" ]]; then
    echo "[$1] Already newest version: $version_remote"
  elif [[ "x$version_newer" = "x$version_remote" ]]; then
    echo "[$1] Find newer version: $version_local => $version_remote"
    log_update $1 $2 $version_local $version_remote
    sed -i "s@^$1==.*@$1==$version_remote@g" .version
  else
    echo "[$1] Already newest version: $version_remote"
  fi
}

track $1 $2
