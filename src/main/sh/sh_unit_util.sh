#!/usr/bin/env bash

. ../../../bootstrap.sh

# ======================================
# Dependencies
# ======================================
# None

# ======================================
# Functions
# ======================================
#----------------------------------------
# Verify if $2 string start with $1 string.
#
# Examples:
#    string_start_with "unit tests are useful" "unit test"  # Return $TRUE
#    string_start_with "unit tests are useful" "UNIT"       # Return $FALSE
#
# Arguments:
#   $1 - String
#   $2 - Substring to search in $1 string 
#
# Globals:
#   $TRUE
#   $FALSE
#
# External executables:
#   None
#
# Other function dependencies:
#   None
#
# Outputs:
#   None
#
# Returns:
#   $TRUE if found $2 in $1 string, $FALSE otherwise.
#
# Documentation:
#   Created in 3 de set. de 2022
#   Updated in 3 de set. de 2022
#----------------------------------------
string_start_with(){

  local string=$1
  local substring=$2
  
  if [[ $string == "$substring"* ]]; then
    return "$TRUE";
  else
    return "$FALSE";
  fi
}

#----------------------------------------
# Verify if array string $1 contains the $2 string element.
#
# Examples:
# ------------------
#  local test_array
#
#  test_array=( \
#    "one"
#    "TWO"
#    "Three"
#  )
#
#  array_contain_element test_array "one"    # $TRUE
#  array_contain_element test_array "four"   # $FALSE
# ------------------
#
# Arguments:
#   $1 - array of strings
#   $2 - string element to search in $1 array
#
# Globals:
#   $TRUE
#   $FALSE
#
# External executables:
#   None
#
# Other function dependencies:
#   None
#
# Outputs:
#   None
#
# Returns:
#   $TRUE if found $2 string in $1 array strings, $FALSE otherwise.
#   
# Documentation:
#   Created in 3 de set. de 2022
#   Updated in 3 de set. de 2022
#----------------------------------------
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

# ======================================
# Run functions
# ======================================
# None