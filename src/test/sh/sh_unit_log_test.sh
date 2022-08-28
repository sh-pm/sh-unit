#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$TEST_DIR_PATH/base/sh_unit_base4_echo_redirect_output_in_unit_tests.sh"

# ======================================
# SUT
# ======================================
include_file "$SRC_DIR_PATH/sh_unit_log.sh"

# ======================================
# "Set-Up"
# ======================================
SH_UNIT_LOG_STRING_4_TEST="---> this string was generated only for unit test of sh_unit_log function <---"

# ======================================
# "Teardown"
# ======================================


# ======================================
# Before each TestCase Start
# ======================================


# ======================================
# After each TestCase Finish
# ======================================


# ======================================
# Tests
# ======================================

finish_one_testcase_with_success(){
  export TEST_EXECUTION_STATUS="$STATUS_SUCCESS"
  export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_SUCCESS"
  
  export TESTCASE_TOTAL_COUNT=1
  export TESTCASE_FAIL_COUNT=0
  export TESTCASE_SUCCESS_COUNT=1
    
  export ASSERTIONS_TOTAL_COUNT=1
  export ASSERTIONS_FAIL_COUNT=0
  export ASSERTIONS_SUCCESS_COUNT=1
  
  SH_UNIT_TEST_EXECUTION_SUCCESS="$TRUE"
  
  echo -e "${ECHO_COLOR_GREEN}""Test Sucess!""${ECHO_COLOR_NC}"
  
  exit 0
}

finish_one_testcase_with_fail(){
  export TEST_EXECUTION_STATUS="$STATUS_ERROR"
  export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
  
  export TESTCASE_TOTAL_COUNT=1
  export TESTCASE_FAIL_COUNT=1
  export TESTCASE_SUCCESS_COUNT=0
    
  export ASSERTIONS_TOTAL_COUNT=1
  export ASSERTIONS_FAIL_COUNT=1
  export ASSERTIONS_SUCCESS_COUNT=0
  
  export SH_UNIT_TEST_EXECUTION_SUCCESS="$FALSE"
  
  echo -e "${ECHO_COLOR_RED}""Test Fail!""${ECHO_COLOR_NC}"
  
  exit 1
}

ensure_necessary_global_vars_exists(){
  if [[ -z "$ENABLE_STDOUT_REDIRECT_4TEST" ]]; then
    finish_one_testcase_with_fail
  fi
  
  if [[ -z "$STDOUT_REDIRECT_FILEPATH_4TEST" ]]; then
    finish_one_testcase_with_fail
  fi
}

test_sh_unit_log_without_e_option_stdout_redirect_disabled(){

  disable_stdout_log_redirect

  sh_unit_log "$SH_UNIT_LOG_STRING_4_TEST"
  
  if [ -e "$STDOUT_REDIRECT_FILEPATH_4TEST" ]
  then
    if [[ "$(cat "$STDOUT_REDIRECT_FILEPATH_4TEST")" != "" ]]; then
        finish_one_testcase_with_fail    
    fi
  fi
}

test_sh_unit_log_with_e_option_stdout_redirect_disabled(){

  disable_stdout_log_redirect

  sh_unit_log -e "${ECHO_COLOR_GREEN}$SH_UNIT_LOG_STRING_4_TEST${ECHO_COLOR_NC}"
  
  if [ -e "$STDOUT_REDIRECT_FILEPATH_4TEST" ]
  then
    if [[ "$(cat "$STDOUT_REDIRECT_FILEPATH_4TEST")" != "" ]]; then
        finish_one_testcase_with_fail    
    fi
  fi
}

test_sh_unit_log_without_e_option_stdout_redirect_enabled(){
  
  enable_stdout_log_redirect
  
  sh_unit_log "$SH_UNIT_LOG_STRING_4_TEST"
  
  if [ -e "$STDOUT_REDIRECT_FILEPATH_4TEST" ]
  then
    if [[ "$(cat "$STDOUT_REDIRECT_FILEPATH_4TEST")" != "$SH_UNIT_LOG_STRING_4_TEST" ]]; then 
        echo "file content different of content expected: "
        echo "expected: |$SH_UNIT_LOG_STRING_4_TEST|"
        echo "obtained: |$(cat $STDOUT_REDIRECT_FILEPATH_4TEST)|"
      finish_one_testcase_with_fail
    fi
  else
    echo "expected file not exists"
      finish_one_testcase_with_fail
  fi
  
  disable_stdout_log_redirect
}

test_sh_unit_log_with_e_option_stdout_redirect_enabled(){
  
  enable_stdout_log_redirect
  
  local formated_string_4_test_to_be_logged
  local formated_string_4_test_expected_in_file
  
  formated_string_4_test_to_be_logged="${ECHO_COLOR_GREEN}""$SH_UNIT_LOG_STRING_4_TEST""${ECHO_COLOR_NC}"
  formated_string_4_test_expected_in_file=$(echo -e "${ECHO_COLOR_GREEN}""$SH_UNIT_LOG_STRING_4_TEST""${ECHO_COLOR_NC}")
  
  sh_unit_log -e "$formated_string_4_test_to_be_logged"
  
  if [ -e "$STDOUT_REDIRECT_FILEPATH_4TEST" ]
  then
    if [[ "$(cat "$STDOUT_REDIRECT_FILEPATH_4TEST")" != "$formated_string_4_test_expected_in_file" ]]; then 
        echo "file content different of content expected: "
        echo "expected: |$formated_string_4_test_expected_in_file|"
        echo "obtained: |$(cat $STDOUT_REDIRECT_FILEPATH_4TEST)|"
      finish_one_testcase_with_fail
    fi
  else
    echo "expected file not exists"
      finish_one_testcase_with_fail
  fi
  
  disable_stdout_log_redirect
}


test_sh_unit_log() {
  ensure_necessary_global_vars_exists
  
  test_sh_unit_log_without_e_option_stdout_redirect_disabled
  test_sh_unit_log_with_e_option_stdout_redirect_disabled
  test_sh_unit_log_without_e_option_stdout_redirect_enabled
  test_sh_unit_log_with_e_option_stdout_redirect_enabled
  
  finish_one_testcase_with_success
}

test_sh_unit_log