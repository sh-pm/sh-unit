#!/usr/bin/env bash

. ../../../bootstrap.sh

# ======================================
# Dependencies
# ======================================
include_file "$TEST_DIR_PATH/base/sh_unit_base4_echo_redirect_output_in_unit_tests.sh"
include_file "$TEST_DIR_PATH/base/sh_unit_base4_unit_test_itself.sh"

# ======================================
# SUT
# ======================================
include_file "$SRC_DIR_PATH/sh_unit_asserts.sh"

# ======================================
# "Set-Up"
# ======================================
set_up() {
  init_sh_unit_internal_tests_execution
  
  define_sh_unit_global_variables
  
  enable_stdout_log_redirect
}
set_up

# ======================================
# "Teardown"
# ======================================
tear_down() {
  disable_stdout_log_redirect

  define_sh_unit_global_variables
  
  finish_sh_unit_internal_tests_execution
}
trap "tear_down" EXIT

# ======================================
# Before each TestCase Start
# ======================================
before_testcase_start() {
  reset_g_test_execution_status
  reset_g_test_counters
}

# ======================================
# After each TestCase Finish
# ======================================
after_testcase_finish() {
  reset_g_test_execution_status
  reset_g_test_counters
}

# ======================================
# Tests
# ======================================
test_get_caller_info() {
  before_testcase_start
  
  local expected
  
  expected="$( basename "${BASH_SOURCE[1]}" ) (l. ${BASH_LINENO[0]})"
  if [[ "$( get_caller_info )" != "$expected" ]]; then
    finish_test_case "get_caller_info not generate expected content. Expected: |$expected|, Generated: |$( get_caller_info )|" 
  fi
  
  after_testcase_finish
}

test_assert_equals() {

  before_testcase_start

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "0"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"    "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_equals "1" "1"
  
  eval "[[ $? == 0 ]]" || finish_test_case "last assert_equal not return expected \$TRUE value"  

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "1"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_equals "1" "0"
  
  eval "[[ $? != 0 ]]" || finish_test_case "last assert_equal not return expected \$FALSE value"  

  #--------------Assertion call---------------|------------Var value----------------|-array-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "2"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "1"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "2"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "1"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$FALSE"   "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$FALSE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"
  
  after_testcase_finish
}

test_assert_contains() {
  before_testcase_start

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "0"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"    "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_contains "write tests is cool" "test"
  
  eval "[[ $? == 0 ]]" || finish_test_case "last assert_contains not return expected \$TRUE value"

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "1"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_contains "write tests is cool" "bug"
  
  eval "[[ $? == 1 ]]" || finish_test_case "last assert_contains not return expected \$FALSE value"

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "2"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "1"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "2"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "1"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$FALSE"   "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$FALSE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"
  
  after_testcase_finish
}

test_assert_start_with() {
  before_testcase_start

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "0"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"    "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_start_with "write tests is cool" "write"
  
  eval "[[ $? == 0 ]]" || finish_test_case "last assert_start_with not return expected \$TRUE value"

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "1"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_start_with "write tests is cool" "cool"
  
  eval "[[ $? == 1 ]]" || finish_test_case "last assert_start_with not return expected \$FALSE value"

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "2"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "1"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "2"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "1"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$FALSE"   "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$FALSE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"
  
  after_testcase_finish
}

test_assert_end_with() {
  before_testcase_start

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "0"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"    "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_end_with "write tests is cool" "cool"
  
  eval "[[ $? == 0 ]]" || finish_test_case "last assert_end_with not return expected \$TRUE value"

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "1"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"

  assert_end_with "write tests is cool" "write"
  
  eval "[[ $? == 1 ]]" || finish_test_case "last assert_end_with not return expected \$FALSE value"

  #--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------  
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "2"        "${!ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "1"        "${!ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "2"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "1"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
  sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$FALSE"   "${!TEST_EXECUTION_STATUS@}"
  sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$FALSE"   "${!LAST_TESTCASE_EXECUTION_STATUS@}"
  
  after_testcase_finish 
}

test_assert_array_contains() {
  local array=( "one" "two" "three" "four" "testing" )
  
  assert_array_contains array "three" 
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
  
  assert_array_contains array "one" 
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
  
  assert_array_contains array "two" 
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"  
  
  assert_array_contains array "four" 
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
  
  assert_array_contains array "testing" 
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
    
}

test_assert_array_not_contains() {
  local array=( "one" "two" "three" "four" "testing" )
  
  assert_array_not_contains array "0" 
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_not_contains NOT return expected \$TRUE value"
    
  assert_array_not_contains array "test" 
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_not_contains NOT return expected \$TRUE value"
  
  assert_array_not_contains array "four" 
  eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_not_contains NOT return expected \$FALSE value"
}

test_assert_array_contains_values() {
  local array
  local values
  
  array=( "one" "two" "three" "four" "testing" )
  
  values=( "two" "three" "four" )
  assert_array_contains_values array values  
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_values NOT return expected \$TRUE value"
    
  values=( "two" "three" "four" "FIVE" )
  assert_array_contains_values array values 
  eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_values NOT return expected \$FALSE value"
}

test_assert_array_contains_only_this_values() {
  local array
  local values
  
  array=( "one" "two" "three" "four" "testing" )
  
  values=( "one" "two" "three" "four" "testing" )
  assert_array_contains_only_this_values array values  
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$TRUE value"
    
  values=( "one" "two" "three" "four" )
  assert_array_contains_only_this_values array values 
  eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
  
  values=( "one" "two" "three" "four" "testing" "OTHER" )
  assert_array_contains_only_this_values array values  
  eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
  
  values=( "OTHER" "one" "two" "three" "four" "testing" )
  assert_array_contains_only_this_values array values  
  eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
  
  values=( "one" "two" "3" "4" "testing" )
  assert_array_contains_only_this_values array values  
  eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
  
  values=( "testing" "two" "one" "four" "three" )
  assert_array_contains_only_this_values array values  
  eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$TRUE value"
}

# ======================================
# RUN Tests
# ======================================
[[ -z "$IS_TESTRUNNER_EXECUTION" || "$IS_TESTRUNNER_EXECUTION" != "$TRUE" ]] && {
  test_get_caller_info
  test_assert_equals
  test_assert_contains
  test_assert_start_with
  test_assert_end_with
  test_assert_array_contains
  test_assert_array_contains_values
  test_assert_array_contains_only_this_values
}