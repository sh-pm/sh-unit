#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$TEST_DIR_PATH/base/sh_unit_base4_echo_redirect_output_in_unit_tests.sh"
include_file "$SRC_DIR_PATH/sh_unit_log.sh" 

reset_sh_unit_tests_execution_status() {
  SH_UNIT_TEST_EXECUTION_SUCCESS="$TRUE"
}

finish_test_case() {
  local var_value
  assert_description="$1"
  
  sh_unit_log -e "$( basename "${BASH_SOURCE[2]}" ) (l. ${BASH_LINENO[1]}): SH-UNIT Assertion Error! $assert_description"
  
  export TEST_EXECUTION_STATUS="$FALSE"
  export LAST_TESTCASE_EXECUTION_STATUS="$FALSE"
  
  sh_unit_log ""
  sh_unit_log "--STACK:------------------------------"
  
  for ((i=0;i<${#FUNCNAME[@]}-1;i++))
  do
    sh_unit_log " $i: $( basename ${BASH_SOURCE[$i+1]} ) (l.${BASH_LINENO[$i]}): ${FUNCNAME[$i]}"
  done
    
  sh_unit_log "--------------------------------------"
  sh_unit_log ""
   
  SH_UNIT_TEST_EXECUTION_SUCCESS="$FALSE"
}

sh_unit_assert_var_exists_and_value_is_equal() {
  local var_value
  local var_name
  local var_name
  
  var_value="$1"
  expected_value="$2"
  var_name="$3"
  
  if [[ -z "$var_value" ]]; then
    finish_test_case "Variable NOT exists! $var_name"
  fi
  
  if [[ "$var_value" != "$expected_value" ]]; then
    finish_test_case "Variable NOT contains expected value! Have: $var_name=|$var_value|, Expected: $var_name=|$expected_value|"
  fi
}

sh_unit_assert_var_NOT_exists() {
  var_value="$1"
  var_name="$2"
  
  if [[ ! -z "$var_value" ]]; then
    finish_test_case "Variable already exists! $var_name"
  fi
}

sh_unit_print_array_for_msg_error() {
  local -n aux_array
  aux_array=$1
  
  sh_unit_log -e "("
  for array_item in "${aux_array[@]}"; do
    sh_unit_log -e "   |$array_item|"
  done 
  sh_unit_log -e ")"
}

array_dump() {
  local -n aux_array
  aux_array=$1
  
  local aux_str
  
  aux_str="$aux_str""( ";
  for array_item in ${aux_array[@]}; do
    aux_str="$aux_str"" \"$array_item\"";
  done 
  aux_str="$aux_str"" )";
  
  sh_unit_log "$aux_str"
}

init_sh_unit_internal_tests_execution() {
  sh_unit_log ""
  sh_unit_log "======= SH-UNIT internal tests execution start =============="
  sh_unit_log ""
  
  reset_sh_unit_tests_execution_status
}

finish_sh_unit_internal_tests_execution() {
  check_sh_unit_internal_tests_result
}

check_sh_unit_internal_tests_result() {
  sh_unit_log ""
  sh_unit_log "======= SH-UNIT internal tests execution finish =============="
  if [[ "$SH_UNIT_TEST_EXECUTION_SUCCESS" == "$TRUE" ]]; then
    sh_unit_log -e "               ${ECHO_COLOR_GREEN}Result: SUCCESS!${ECHO_COLOR_NC}"
  else
    sh_unit_log -e "               ${ECHO_COLOR_RED}Result: FAIL!!!${ECHO_COLOR_NC}"
  fi
  sh_unit_log "=============================================================="
  sh_unit_log ""
}