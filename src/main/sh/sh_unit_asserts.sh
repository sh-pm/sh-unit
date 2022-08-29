#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$SRC_DIR_PATH/sh_unit_log.sh"
include_file "$SRC_DIR_PATH/sh_unit_g_vars.sh"

#----------------------------------------
# Return the filename and line when this function was called.
#
# Arguments:
#   None
#
# Globals:
#   BASH_SOURCE
#   BASH_LINENO
#
# External executables:
#   basename
#
# Example use:
#   The command 
#      echo get_caller_info
#   Will produce output similar to:
#      sh_unit_assert.sh (l. 23)
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
get_caller_info(){
  echo "$( basename "${BASH_SOURCE[2]}" ) (l. ${BASH_LINENO[1]})"
}

#----------------------------------------
# Assertion to used in unit tests to verify if string $1 is equal to string $2.
#
# Arguments:
#   $1 - first string
#   $2 - second string
#   $3 - msg if not equals (OPTIONAL)
# 
# Algoritm:
# - Receive at last two string params ($3 is optional) to verify if $1 is equals to $2;
# - Increment global and testcase assertion counters;
# - Verify if $1 is equals $2
# - IF was equals:
#   - print in stdout a string, with color highlight, identify assertion success
#   - increment global and testcase success assertion counters;
#   - return $TRUE
# - ELSE was not equals: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify the reason of assertion fail
#   - increment global and testcase fail assertion counters;
#   - return $FALSE
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#   ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   ECHO_COLOR_GREEN
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME[0]
#   TRUE
#   FALSE
#   STATUS_ERROR
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#
# Outputs:
# - IF params $1 equals to $2:
#   - print in stdout a string, with color highlight, identify assertion success
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify reason of assertion fail
#   
# Returns:
#   $TRUE if assertion success, $FALSE otherwise
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_equals(){
  
  local assert_description="$3"
  
  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))

  if [[ "$1" == "$2" ]]; then
  
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
    export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
    export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
    
    return "$TRUE"
    
  else
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"    
    sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| is NOT EQUALs |$2|${ECHO_COLOR_NC}"

    export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))     
    export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
     
    export TEST_EXECUTION_STATUS="$STATUS_ERROR"
    export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
    
    return "$FALSE"
  fi
}

#----------------------------------------
# Assertion to used in unit tests to verify if string $1 contain the SUBstring $2.
#
# Arguments:
#   $1 - string
#   $2 - SUBstring to be search in $1 string
#   $3 - msg if not found (OPTIONAL)
# 
# Algoritm:
# - Receive at last two string params ($3 is optional) to verify if $1 is equals to $2;
# - Increment global and testcase assertion counters; 
# - IF $1 string contains $2 SUBstring:
#   - print in stdout a string, with color highlight, identify assertion success
#   - increment global and testcase success assertion counters;
#   - return $TRUE
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify the reason of assertion fail
#   - increment global and testcase fail assertion counters;
#   - return $FALSE
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#   ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   ECHO_COLOR_GREEN
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME[0]
#   TRUE
#   FALSE
#   STATUS_ERROR
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#
# Outputs:
# - IF params $1 contains $2 SUBstring:
#   - print in stdout a string, with color highlight, identify assertion success
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify that NOT FOUND the substring
#
# Returns:
#   $TRUE if assertion success, $FALSE otherwise
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_contains(){
  
  local assert_description="$3"
  
  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))

  if [[ "$1" == *"$2"* ]]; then
  
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
    export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
    export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
    
    return "$TRUE"
    
  else
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"    
    sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| NOT contains |$2|${ECHO_COLOR_NC}"

    export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))     
    export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
     
    export TEST_EXECUTION_STATUS="$STATUS_ERROR"
    export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
    
    return "$FALSE"
  fi
}

#----------------------------------------
# Assertion to used in unit tests to verify if string $1 start with the SUBstring $2.
#
# Arguments:
#   $1 - string
#   $2 - SUBstring to be search in start of $1 string
#   $3 - msg if not found (OPTIONAL)
# 
# Algoritm:
# - Receive at last two string params ($3 is optional) to verify if $1 is equals to $2;
# - Increment global and testcase assertion counters; 
# - IF $1 start with $2 SUBstring:
#   - print in stdout a string, with color highlight, identify assertion success
#   - increment global and testcase success assertion counters;
#   - return $TRUE
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify the reason of assertion fail
#   - increment global and testcase fail assertion counters;
#   - return $FALSE
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#   ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   ECHO_COLOR_GREEN
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME[0]
#   TRUE
#   FALSE
#   STATUS_ERROR
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#
# Outputs:
# - IF params $1 and $2 was equals:
#   - print in stdout a string, with color highlight, identify assertion success
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify reason of assertion fail
#
# Returns:
#   $TRUE if assertion success, $FALSE otherwise
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_start_with(){
  
  local assert_description="$3"
  
  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
  
  if [[ -n "$1" && -n "$2" && "$1" =~ ^"$2".* ]]; then
  
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
    export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
    export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
    
    return "$TRUE"
  else
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"
        
    if [[ -z "$1" || -z "$2" ]]; then 
      sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: Receive empty param(s): 1->|$1|, 2->|$2|${ECHO_COLOR_NC}"    
    else
      sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| NOT start with |$2|${ECHO_COLOR_NC}"    
    fi
  
    export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))     
    export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
     
    export TEST_EXECUTION_STATUS="$STATUS_ERROR"
    export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
    
    return "$FALSE"
  fi
}

#----------------------------------------
# Assertion to used in unit tests to verify if string $1 end with the SUBstring $2.
#
# Arguments:
#   $1 - string
#   $2 - SUBstring to be search in the end of $1 string
#   $3 - msg if not found (OPTIONAL)
# 
# Algoritm:
# - Receive at last two string params ($3 is optional) to verify if $1 is equals to $2;
# - Increment global and testcase assertion counters; 
# - IF $1 end with $2 SUBstring:
#   - print in stdout a string, with color highlight, identify assertion success
#   - increment global and testcase success assertion counters;
#   - return $TRUE
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify the reason of assertion fail
#   - increment global and testcase fail assertion counters;
#   - return $FALSE
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#   ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   ECHO_COLOR_GREEN
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME[0]
#   TRUE
#   FALSE
#   STATUS_ERROR
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#
# Outputs:
# - IF params $1 and $2 was equals:
#   - print in stdout a string, with color highlight, identify assertion success
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify reason of assertion fail
#
# Returns:
#   $TRUE if assertion success, $FALSE otherwise
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_end_with(){
  
  local assert_description="$3"
  
  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
  
  if [[ -n "$1" && -n "$2" && "$1" =~ .*"$2"$ ]]; then
  
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
    export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
    export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
    
    return "$TRUE"
  else
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"
        
    if [[ -z "$1" || -z "$2" ]]; then 
      sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: Receive empty param(s): 1->|$1|, 2->|$2|${ECHO_COLOR_NC}"    
    else
      sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| NOT end with |$2|${ECHO_COLOR_NC}"    
    fi
  
    export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))     
    export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
     
    export TEST_EXECUTION_STATUS="$STATUS_ERROR"
    export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
    
    return "$FALSE"
  fi
}

#----------------------------------------
# Assertion to used in unit tests to verify if $1 is $TRUE.
#
# Arguments:
#   $1 - value to check if is $TRUE
#   $2 - msg if not $TRUE (OPTIONAL)
# 
# Algoritm:
# - Receive at last one param ($2 is optional) and store in $value to verify if $value is $TRUE;
# - Increment global and testcase assertion counters;
# - IF $1 is empty:
#   - $value receive the status of last command executed  
# - IF $1 is $TRUE:
#   - print in stdout a string, with color highlight, identify assertion success
#   - increment global and testcase success assertion counters;
#   - return $TRUE
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify the reason of assertion fail
#   - increment global and testcase fail assertion counters;
#   - return $FALSE
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#   ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   ECHO_COLOR_GREEN
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME[0]
#   TRUE
#   FALSE
#   STATUS_ERROR
#   $? - Last comand execution (expected to be a function?!)
#
# External executables:
#   Exit status of last function executed! (See $? above)
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#
# Outputs:
# - IF $value is $TRUE
#   - print in stdout a string, with color highlight, identify assertion success
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify reason of assertion fail
#
# Returns:
#   $TRUE if assertion success, $FALSE otherwise
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_true(){
  local value="$1"
  local assert_description="$2"
  
  local last_function_status_execution
  
  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
  
  # TODO shpm, 2022-08-28: Verify why the IF below exists in assert_true e assert_false functions
  if [[ -z "$value" ]]; then
    last_function_status_execution="$?"
    value="$last_function_status_execution"
  fi

  if [[ "$value" == "$TRUE" ]]; then
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
    export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
    export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
    
    return "$TRUE";
  else
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"
    sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$value| is NOT true${ECHO_COLOR_NC}"
    
    export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))
    export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
    
    TEST_EXECUTION_STATUS="$STATUS_ERROR"
    LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
    
    return "$FALSE";
  fi
}  

#----------------------------------------
# Assertion to used in unit tests to verify if $1 is $FALSE.
#
# Arguments:
#   $1 - value to check if is $FALSE
#   $2 - msg if not $FALSE (OPTIONAL)   
# 
# Algoritm:
# - Receive at last one param ($2 is optional) and store in $value to verify if $value is $FALSE;
# - Increment global and testcase assertion counters;
# - IF $1 is empty:
#   - $value receive the status of last command executed  
# - IF $1 is $FALSE:
#   - print in stdout a string, with color highlight, identify assertion success
#   - increment global and testcase success assertion counters;
#   - set with error test execution status and last testcase execution status;  
#   - return $TRUE
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify the reason of assertion fail
#   - increment global and testcase fail assertion counters;
#   - return $FALSE
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#   ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   ECHO_COLOR_GREEN
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME[0]
#   TRUE
#   FALSE
#   STATUS_ERROR
#   $? - Last comand execution (expected to be a function?!)   
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#
# Outputs:
# - IF $value is $FALSE
#   - print in stdout a string, with color highlight, identify assertion success
# - ELSE: 
#   - print in stdout a string, with color highlight, identify assertion fail   
#   - print in stdout a string, with color highlight, identify reason of assertion fail
#
# Returns:
#   $TRUE if assertion success, $FALSE otherwise
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_false(){
  local value="$1"
  local assert_description="$2"
  
  local last_function_status_execution
  
  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
    
  # TODO shpm, 2022-08-28: Verify why the IF below exists in assert_true e assert_false functions
  if [[ -z "$value" ]]; then
    last_function_status_execution="$?"
    value="$last_function_status_execution"
  fi

  if [[ "$value" == "$TRUE" ]]; then
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"      
    sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$value| is NOT false${ECHO_COLOR_NC}"
      
    export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))
    export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
      
    export TEST_EXECUTION_STATUS="$STATUS_ERROR"
    export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
    
    return "$FALSE";
  else
    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
    export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
    export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
    
    return "$TRUE";
  fi
}

#----------------------------------------
# Assertion to used in unit tests to fail test case e/or execution. 
#
# Arguments:
#   None
# 
# Algoritm:
# - Increment global and testcase assertion counters;
# - Increment global and testcase fail assertion counters;
# - Print in stdout a string, with color highlight, identify assertion fail; 
# - Set with error global test execution status and last testcase execution status;
# - Return $FALSE
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   STATUS_ERROR  
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FALSE 
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log   
#
# Outputs:
#   Print in stdout a string, with color highlight, identify assertion fail; 
#
# Returns:
#   Ever return $FALSE
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_fail(){

  local assert_description="$1"

  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))

  sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"
    
  export TEST_EXECUTION_STATUS="$STATUS_ERROR"
  export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
  
  return "$FALSE"
}

#----------------------------------------
# Assertion to used in unit tests to indicate success UNTIL NOW. 
#
# Arguments:
#   None
# 
# Algoritm:
# - Increment global and testcase assertion counters;
# - Increment global and testcase success assertion counters;
# - Print in stdout a string, with color highlight, identify assertion success; 
# - Return $TRUE 
#
# Globals:
#   ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#   ECHO_COLOR_GREEN
#   ECHO_COLOR_NC
#   TRUE 
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#
# Outputs:
#   Print in stdout a string, with color highlight, identify assertion success
#
# Returns:
#   Ever return $TRUE
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_success(){

  local assert_description="$1"

  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))

  sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
  return "$TRUE"  
}

#----------------------------------------
# Assertion to used in unit tests to verify if array $1 contain the item $2. 
#
# Arguments:
#   $1 - array with elements
#   $2 - item/element to be searched in $1 array
#   $3 - msg if $2 not found in $1 array (OPTIONAL)
# 
# Algoritm:
# - FOR each element of array $1 received as param:
#   - IF element is a string exactly equal to $2 item string received
#     - Return $TRUE
#     ELSE
#     - Print in stdout a string, with color highlight, identify assertion fail   
#     - Print in stdout a string, with color highlight, identify reason of assertion fail 
#     - Print in stdout a string, with color highlight, show all content of array
#     - Return $FALSE
#
# Globals:
#   TRUE
#   FALSE
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#   sh_unit_base4_unit_test_itself.sh::sh_unit_print_array_for_msg_error
#
# Outputs:
#   Print in stdout a string, with color highlight, identify assertion fail   
#   Print in stdout a string, with color highlight, identify reason of assertion fail 
#   Print in stdout a string, with color highlight, show all content of array
#    
# Returns:
#   Return $TRUE if $2 element found in $1 array, $FALSE otherwise.
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_array_contains() {
  local -n p_array=$1
  local item=$2
  
  for array_item in "${p_array[@]}"; do
    if [[ "$array_item" == "$item" ]]; then
      return "$TRUE";
    fi
  done 
  
  sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"  
  sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: Expect found value |$item| in array, but it NOT found:${ECHO_COLOR_NC}"
  sh_unit_print_array_for_msg_error p_array
  
  return "$FALSE"
}

#----------------------------------------
# Assertion to used in unit tests to verify if array $1 NOT contain the item $2. 
#
# Arguments:
#   $1 - array with elements
#   $2 - item/element to be searched in $1 array
#   $3 - msg if $2 found in $1 array (OPTIONAL)
# 
# Algoritm:
# - FOR each element of array $1 received as param:
#   - IF element is a string exactly equal to $2 item string received
#     - Print in stdout a string, with color highlight, identify assertion fail   
#     - Print in stdout a string, with color highlight, identify reason of assertion fail 
#     - Print in stdout a string, with color highlight, show all content of array
#     - Return $FALSE
#     ELSE
#     - Return $TRUE
#
# Globals:
#   TRUE
#   FALSE
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#   sh_unit_base4_unit_test_itself.sh::sh_unit_print_array_for_msg_error
#
# Outputs:
#   Print in stdout a string, with color highlight, identify assertion fail   
#   Print in stdout a string, with color highlight, identify reason of assertion fail 
#   Print in stdout a string, with color highlight, show all content of array
#    
# Returns:
#   Return $FALSE if $2 element found in $1 array, $TRUE otherwise.
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_array_not_contains() {
  local -n p_array=$1
  local item=$2
  
  for array_item in "${p_array[@]}"; do
    if [[ "$array_item" == "$item" ]]; then
      sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"  
      sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: Expect that value |$item| not in array, but it was found:${ECHO_COLOR_NC}"
      sh_unit_print_array_for_msg_error p_array
      
      return "$FALSE";
    fi
  done 
  
  return "$TRUE"
}

#----------------------------------------
# Assertion to used in unit tests to verify if array $1 contain all itens of the $2 array.
# CAUTION: array $1 may contain all itens of $2 AND MORE itens not presents in $2!
#
# Examples:
# -----------
#   local array1
#   local array2
# 
#   array1=( "one" "two" "three" "four" "testing" )
#   array2=( "two" "three" "four" )
#   assert_array_contains_values array1 array2 # <---- is $TRUE because array1 contain all values of array2  
#  
#   array1=( "one" "two" "three" "four" "testing" )
#   array2=( "two" "three" "four" "FIVE" )   
#   assert_array_contains_values array1 array2 # <---- is $FALSE because array1 NOT contain all values of array2
# -----------
#
# Arguments:
#   $1 (p_array)  - array  
#   $2 (p_values) - array with string itens expected to be found in array $1
#
# Algoritm:
# - FOR each expected_item of array $2 received as param:
#   - IF array $1 NOT contains expected_item, that is: no item of $1 is a string equal a expected_item
#     - Print in stdout a string, with color highlight, identify assertion fail   
#     - Print in stdout a string, with color highlight, identify reason of assertion fail 
#     - Print in stdout a string, with color highlight, show all content of array
#     - Return $FALSE
# - Return $TRUE
#
# Globals:
#   TRUE
#   FALSE
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME   
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#   sh_unit_base4_unit_test_itself.sh::sh_unit_print_array_for_msg_error
#
# Outputs:
#   Print in stdout a string, with color highlight, identify assertion fail   
#   Print in stdout a string, with color highlight, identify reason of assertion fail 
#   Print in stdout a string, with color highlight, show all content of array 
#
# Returns:
#   Return $TRUE if all elements of $2 was found in $1 array, $FALSE otherwise.
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_array_contains_values() {
  local -n p_array
  local -n p_values
  local item_found
  
  p_array=$1
  p_values=$2
  
  for expected_item in "${p_values[@]}"; do

    item_found="$FALSE"
    
    for array_item in "${p_array[@]}"; do
      if [[ "$array_item" == "$expected_item" ]]; then
        item_found="$TRUE"
      fi
    done
    
    if [[ "$item_found" != "$TRUE" ]]; then
      sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $assert_description${ECHO_COLOR_NC}"  
      sh_unit_log -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: Expect item |$expected_item| not found in array:${ECHO_COLOR_NC}"
      sh_unit_print_array_for_msg_error p_array
    
      return "$FALSE"
    fi
  done

  return "$TRUE"  
}

#----------------------------------------
# Assertion to used in unit tests to verify if array $1 and array $2 contain same itens, 
# CAUTION: array $1 and array $2 can contain same itens BUT NOT necessary in same order! 
#
# Examples:
# -----------
#   local array1
#   local array2
# 
#   array1=( "one" "two" "three" "four" )
#   array2=( "one" "two" "three" "four" )
#   assert_array_contains_values array1 array2 # <---- is $TRUE because array1 contain all values of array2  
#
#   array1=( "one" "two" "three" "four" )
#   array2=( "four" "three" "two" "one" )
#   assert_array_contains_values array1 array2 # <---- is $TRUE because array1 contain all values of array2
#  
#   array1=( "one" "two" "three" "four" )
#   array2=( "one" "two" "three" "four" "FIVE" )
#   assert_array_contains_values array1 array2 # <---- is $FALSE because array1 NOT contain all values of array2
#
#   array1=( "one" "two" "three" "four" "FIVE" )
#   array2=( "one" "two" "three" "four" )
#   assert_array_contains_values array1 array2 # <---- is $FALSE because array2 NOT contain all values of array1
# -----------
#
# Arguments:
#   $1 (p_array)  - array  
#   $2 (p_values) - array with string itens expected to be found in array $1
#
# Arguments:
#   $1 (p_array)  - array  
#   $2 (p_values) - array with string itens expected to be found in array $1   
# 
# Algoritm:
# - IF array $1 and array $2 NOT HAVE same size:
#     - Print in stdout a string, with color highlight, identify assertion fail because diferent sizes
#     - Print in stdout a string, with color highlight, identify size of array $1 
#     - Print in stdout a string, with color highlight, show all content of array $1
#     - Print in stdout a string, with color highlight, identify size of array $2 
#     - Print in stdout a string, with color highlight, show all content of array $2
#     - Return $FALSE
# - FOR each expected_item of array $2 received as param:
#   - IF array $1 NOT contains expected_item, that is: no item of $1 is a string equal a expected_item
#     - Print in stdout a string, with color highlight, identify assertion fail   
#     - Print in stdout a string, with color highlight, identify reason of assertion fail 
#     - Print in stdout a string, with color highlight, show all content of array
#     - Return $FALSE 
# - FOR each expected_item of array $1 received as param:
#   - IF array $2 NOT contains expected_item, that is: no item of $1 is a string equal a expected_item
#     - Print in stdout a string, with color highlight, identify assertion fail   
#     - Print in stdout a string, with color highlight, identify reason of assertion fail 
#     - Print in stdout a string, with color highlight, show all content of array
#     - Return $FALSE
# - Return $TRUE
#
# Globals:
#   TRUE
#   FALSE
#   ECHO_COLOR_RED
#   ECHO_COLOR_NC
#   FUNCNAME   
#
# External executables:
#   None
#
# Other function dependencies:
#   sh_unit_asserts.sh::get_caller_info
#   sh_unit_log.sh::sh_unit_log
#   sh_unit_base4_unit_test_itself.sh::sh_unit_print_array_for_msg_error
#
# Outputs:
# - IF array $1 and array $2 NOT HAVE same size:
#     - Print in stdout a string, with color highlight, identify assertion fail because diferent sizes
#     - Print in stdout a string, with color highlight, identify size of array $1 
#     - Print in stdout a string, with color highlight, show all content of array $1
#     - Print in stdout a string, with color highlight, identify size of array $2 
#     - Print in stdout a string, with color highlight, show all content of array $2
# - FOR each expected_item of array $2 received as param:
#   - IF array $1 NOT contains expected_item, that is: no item of $1 is a string equal a expected_item
#     - Print in stdout a string, with color highlight, identify assertion fail   
#     - Print in stdout a string, with color highlight, identify reason of assertion fail 
#     - Print in stdout a string, with color highlight, show all content of array
# - FOR each expected_item of array $1 received as param:
#   - IF array $2 NOT contains expected_item, that is: no item of $1 is a string equal a expected_item
#     - Print in stdout a string, with color highlight, identify assertion fail   
#     - Print in stdout a string, with color highlight, identify reason of assertion fail 
#     - Print in stdout a string, with color highlight, show all content of array
#
# Returns:
# - IF array $1 and array $2 NOT HAVE same size:
#     - Return $FALSE
# - FOR each expected_item of array $2 received as param:
#   - IF array $1 NOT contains expected_item, that is: no item of $1 is a string equal a expected_item
#     - Return $FALSE 
# - FOR each expected_item of array $1 received as param:
#   - IF array $2 NOT contains expected_item, that is: no item of $1 is a string equal a expected_item
#     - Return $FALSE
#   Return $TRUE   
#
# Documentation:
#   Was created in 2022-08-29
#   Last update in 2022-08-29
#----------------------------------------
assert_array_contains_only_this_values() {
  local -n p_array
  local -n p_values
  
  local item_found
  
  p_array="$1"
  p_values="$2"
  
  if [[ "${#p_array[@]}" != "${#p_values[@]}" ]]; then
    sh_unit_log -e "Arrays have diferent sizes! "
    
    sh_unit_log -e "Array of values have size = ${#p_array[@]}"
    sh_unit_print_array_for_msg_error p_array
    
    sh_unit_log -e "Array of EXPECTED values have size = ${#p_values[@]}"
    sh_unit_print_array_for_msg_error p_values
     
    return "$FALSE"
  fi
  
  for expected_item in "${p_values[@]}"; do

    item_found="$FALSE"
    
    for array_item in "${p_array[@]}"; do
    
      if [[ "$array_item" == "$expected_item" ]]; then
        item_found="$TRUE"
      fi
    done
    
    if [[ "$item_found" != "$TRUE" ]]; then
      sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect item |$expected_item| not found in array: ${ECHO_COLOR_NC}"
    
      return "$FALSE"
    fi
  done
  
  for array_item in "${p_array[@]}"; do

    item_found="$FALSE"
    
    for expected_item in "${p_values[@]}"; do    
      if [[ "$array_item" == "$expected_item" ]]; then
        item_found="$TRUE"
      fi
    done
    
    if [[ "$item_found" != "$TRUE" ]]; then
      sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Array contain a unexpected item |$array_item|${ECHO_COLOR_NC}"
      sh_unit_print_array_for_msg_error p_array
    
      return "$FALSE"
    fi
  done

  return "$TRUE"  
}
