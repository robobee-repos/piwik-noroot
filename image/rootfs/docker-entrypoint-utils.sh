#!/bin/bash

### Version 1.0
### Contains various utilities functions for the docker-entrypoint.sh script.

set -e

BASH_CMD="bash"
RSYNC_CMD="rsync"

function check_files_exists() {
  ls $1 1> /dev/null 2>&1
}

function copy_file() {
  file="$1"; shift
  dir="$1"; shift
  mod="$1"; shift
  if [ -e "$file" ]; then
    mkdir -p "$dir"
    cp "$file" "$dir/$file"
    chmod $mod "$dir/$file"
  fi
}

function checkVariables() {
  declare -a v=("${!1}")
  for var in "${v[@]}"; do
    if [ -n "${!var:-}" ]; then
      echo "$var is set to: ${!var}"
    else
      echo "Need to set variable: $var"
      exit 1
    fi
  done
}

function copy_files() {
  if [[ $# -eq 4 ]]; then
    declare -a skip=("${!4}")
    skip="--exclude=${skip[@]}"
  else
    skip=""
  fi
  dir="$1"; shift
  target="$1"; shift
  files="$1"; shift
  if [[ ! -d "${dir}" ]]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "$files"; then
    return
  fi
  $RSYNC_CMD ${skip} -Lv ${dir}/$files $target/
}

function sync_dir() {
  dir="$1"; shift
  target="$1"; shift
  if [ ! -d "${dir}" ]; then
    echo "${dir} does not exists or is not a directory."
    exit 1
  fi
  if [ ! -d "${target}" ]; then
    echo "${target} does not exists or is not a directory."
    exit 1
  fi
  cd "${target}"
  $RSYNC_CMD -rlD -u ${dir}/. .
}

function do_sed() {
  ## TEMP File
  TFILE=`mktemp --tmpdir tfile.XXXXX`
  trap "rm -f $TFILE" EXIT

  file="$1"; shift
  search="$1"; shift
  replace="$1"; shift
  sed -r -e "s/^${search}.*/${replace}/g" $file > $TFILE
  cat $TFILE > $file
}

function do_sed_group() {
  ## TEMP File
  TFILE=`mktemp --tmpdir tfile.XXXXX`
  trap "rm -f $TFILE" EXIT

  file="$1"; shift
  search="$1"; shift
  replace="$1"; shift
  sed -r -e "s|^(${search}).*|${replace}|g" $file > $TFILE
  cat $TFILE > $file
}

function set_debug() {
  if [[ "$DEBUG" == "true" ]]; then
    set -x
    BASH_CMD="bash -x"
    RSYNC_CMD="rsync -v"
  fi
}
