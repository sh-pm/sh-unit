#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$SRC_DIR_PATH/sh_unit_log.sh"

reset_g_test_execution_status() {
  export TEST_EXECUTION_STATUS="$STATUS_SUCCESS"
  export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_SUCCESS"
}

reset_g_test_counters() {
  export TESTCASE_TOTAL_COUNT=0
  export TESTCASE_FAIL_COUNT=0
  export TESTCASE_SUCCESS_COUNT=0
  
  export ASSERTIONS_TOTAL_COUNT=0
  export ASSERTIONS_FAIL_COUNT=0
  export ASSERTIONS_SUCCESS_COUNT=0
  
  reset_testcase_counters
}

reset_testcase_counters() {
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=0
  export TESTCASE_ASSERTIONS_FAIL_COUNT=0
  export TESTCASE_ASSERTIONS_SUCCESS_COUNT=0
}

define_sh_unit_global_variables() {
  if [[ -z "$SH_UNIT_GLOBAL_VARS_ALREADY_DEFINED" || "$SH_UNIT_GLOBAL_VARS_ALREADY_DEFINED" == "$FALSE" ]]; then
  
    export readonly TEST_FUNCTION_PREFIX="test_"
    export readonly TEST_FILENAME_SUFIX="_test.sh"
    
    export readonly STATUS_SUCCESS="$TRUE"
    export readonly STATUS_ERROR="$FALSE"
    
    reset_g_test_execution_status
    
    reset_g_test_counters
    
    export SH_UNIT_GLOBAL_VARS_ALREADY_DEFINED="$TRUE"
  fi
}

define_sh_unit_global_variables
