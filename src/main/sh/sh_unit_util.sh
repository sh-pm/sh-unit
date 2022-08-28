#!/usr/bin/env bash

. ../../../bootstrap.sh

string_start_with(){

  local string=$1
  local substring=$2
  
  if [[ $string == "$substring"* ]]; then
    return "$TRUE";
  else
    return "$FALSE";
  fi
}

array_contain_element() {

  local -n p_array="$1"
  local element="$2"
  
  for iter in "${p_array[@]}"; do
    if [[ "$iter" == "$element" ]]; then
      return "$TRUE"
    fi  
  done
  
  return "$FALSE"
}
