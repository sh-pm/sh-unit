#!/usr/bin/env bash

. ../../../bootstrap.sh

#----------------------------------------
# sh-unit internal log with enhancements to increase testability of string printings using echo command. 
#
# Examples:
# ------------------
#   sh_unit_log "xpto"
#   sh_unit_log -e "xpto"
# ------------------
#
# Arguments:
#   the "-e" param (OPTIONAL) 
#   the string to be printed   
#   NOTE: IF receive 2 params string to be printed is $2, otherwise is $1
# 
# Algoritm:
# - TODO: Write me!
#
# Globals:
#   ENABLE_STDOUT_REDIRECT_4TEST
#   STDOUT_REDIRECT_FILEPATH_4TEST
#   TMP_DIR_PATH
#
# External executables:
#   cd
#   rm
#   touch
#   echo
#
# Other function dependencies:
#   None
#
# Outputs:
# - TODO: Write me!  
#
# Returns:
# - IF stdout redirection is ENABLED
#     nothing returned 
#   ELSE
#     string received 
#----------------------------------------
sh_unit_log() {
  local p_string
  
  #-- Sanitize params start -----
  if [ "$#" -eq 1 ]
  then
    p_string="$1"
  fi
  
  if [ "$#" -eq 2 ]
  then
    if [[ "$1" == "-e" ]]; then
      p_string="$2"
    else
      echo "sh_unit_log: \$1 param must be -e"
      exit 1
    fi   
  fi
  
  if [ "$#" -gt 2 ]
  then
    echo 'sh_unit_log: max number of params is 2'
    exit 1
  fi
  #-- Sanitize params end -----

  if [[ -n "$ENABLE_STDOUT_REDIRECT_4TEST" && "$ENABLE_STDOUT_REDIRECT_4TEST" == "$TRUE" ]]; then

    local actual_dir_path
    actual_dir_path="$( pwd )"
    
    cd "$TMP_DIR_PATH" || exit 1
    
    if [ -e "$STDOUT_REDIRECT_FILEPATH_4TEST" ]
    then
        rm "$STDOUT_REDIRECT_FILENAME_4TEST"
    else
        touch "$STDOUT_REDIRECT_FILENAME_4TEST"
    fi
    
    cd "$actual_dir_path" || exit 1
    
    if [ "$#" -eq 1 ]
    then 
      echo "$p_string" >> "$STDOUT_REDIRECT_FILEPATH_4TEST"    
    else 
      echo -e "$p_string" >> "$STDOUT_REDIRECT_FILEPATH_4TEST"
    fi
  
  else
    if [ "$#" -eq 1 ]
    then 
      echo "$p_string"
    else 
      echo -e "$p_string"    
    fi
  fi
}