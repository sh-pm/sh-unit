#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$SRC_DIR_PATH/sh_unit_log.sh"
include_file "$SRC_DIR_PATH/sh_unit_g_vars.sh"

get_caller_info(){
  echo "$( basename "${BASH_SOURCE[2]}" ) (l. ${BASH_LINENO[1]})"
}

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


assert_true(){
    local value="$1"
    local assert_description="$2"
    
    export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
    
    if [[ -z "$value" ]]; then
    LAST_FUNCTION_STATUS_EXECUTION="$?"
    value=$LAST_FUNCTION_STATUS_EXECUTION
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

assert_false(){
  local value="$1"
    local assert_description="$2"
    
    export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
    
    if [[ -z $value ]]; then
    LAST_FUNCTION_STATUS_EXECUTION="$?"
    value=$LAST_FUNCTION_STATUS_EXECUTION
    fi

  if [[ $value == "$TRUE" ]]; then
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

assert_success(){

  local assert_description="$1"

  export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
  export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
  export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))

    sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $assert_description${ECHO_COLOR_NC}"
    
    return "$TRUE"  
}

assert_array_contains() {
  local -n p_array=$1
  local ITEM=$2
  
  for array_item in "${p_array[@]}"; do
    if [[ "$array_item" == "$ITEM" ]]; then
      return "$TRUE";
    fi
  done 
  
  sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect value |$ITEM| in array, but it NOT found: (${ECHO_COLOR_NC}"
  sh_unit_print_array_for_msg_error p_array
  
  return "$FALSE"
}

assert_array_not_contains() {
  local -n p_array=$1
  local ITEM=$2
  
  for array_item in "${p_array[@]}"; do
    if [[ "$array_item" == "$ITEM" ]]; then
      
      echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect value |$ITEM| not in array, but it was found: (${ECHO_COLOR_NC}"
      sh_unit_print_array_for_msg_error p_array
      
      return "$FALSE";
    fi
  done 
  
  return "$TRUE"
}


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
      sh_unit_log -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect item |$expected_item| not found in array: (${ECHO_COLOR_NC}"
      sh_unit_print_array_for_msg_error p_array
    
      return "$FALSE"
    fi
  done

  return "$TRUE"  
}

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
