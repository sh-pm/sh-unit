#!/usr/bin/env bash

. ../../../bootstrap.sh

enable_stdout_log_redirect() {
  export ENABLE_STDOUT_REDIRECT_4TEST="$TRUE"
  if [ ! -e "$STDOUT_REDIRECT_FILEPATH_4TEST" ]
  then
    local actual_dir_path="$( pwd )"
    cd "$TMP_DIR_PATH"  
      touch "$STDOUT_REDIRECT_FILENAME_4TEST"
    cd "$actual_dir_path"  
  fi  
}

disable_stdout_log_redirect() {
  export ENABLE_STDOUT_REDIRECT_4TEST="$FALSE"
  if [ -e "$STDOUT_REDIRECT_FILEPATH_4TEST" ]
  then
    local actual_dir_path="$( pwd )"
    cd "$TMP_DIR_PATH"  
      rm "$STDOUT_REDIRECT_FILENAME_4TEST"
    cd "$actual_dir_path"  
  fi
}