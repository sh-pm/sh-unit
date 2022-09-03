#!/usr/bin/env bash

. ../../../bootstrap.sh

# ======================================
# Dependencies
# ======================================
include_file "$SRC_DIR_PATH/sh_unit_log.sh"

# ======================================
# Functions
# ======================================
#----------------------------------------
# Reset test status variables to SUCCESS value.
#
# Arguments:
#   None 
#
# Globals:
#   TEST_EXECUTION_STATUS
#   LAST_TESTCASE_EXECUTION_STATUS
#   STATUS_SUCCESS
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
#   None
#   
# Documentation:
#   Created in 3 de set. de 2022
#   Updated in 3 de set. de 2022
#----------------------------------------
reset_g_test_execution_status() {
  export TEST_EXECUTION_STATUS="$STATUS_SUCCESS"
  export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_SUCCESS"
}

#----------------------------------------
# Reset:
#   - Global test counter for test cases and assertions to value 0.
#   - Test Case assertion counter to value 0.
#
# Arguments:
#   None 
#
# Globals: 
#   TESTCASE_TOTAL_COUNT
#   TESTCASE_FAIL_COUNT
#   TESTCASE_SUCCESS_COUNT
#   ASSERTIONS_TOTAL_COUNT
#   ASSERTIONS_FAIL_COUNT
#   ASSERTIONS_SUCCESS_COUNT
#
# External executables:
#   None   
#
# Other function dependencies:
#   reset_testcase_counters
#
# Outputs:
#   None
#
# Returns:
#   None
#   
# Documentation:
#   Created in 3 de set. de 2022
#   Updated in 3 de set. de 2022
#----------------------------------------
reset_g_test_counters() {
  export TESTCASE_TOTAL_COUNT=0
  export TESTCASE_FAIL_COUNT=0
  export TESTCASE_SUCCESS_COUNT=0
  
  export ASSERTIONS_TOTAL_COUNT=0
  export ASSERTIONS_FAIL_COUNT=0
  export ASSERTIONS_SUCCESS_COUNT=0
  
  reset_testcase_counters
}

#----------------------------------------
# Reset test counter for test cases and assertions to value 0.
#
# Arguments:
#   None 
#
# Globals: 
#   TESTCASE_ASSERTIONS_TOTAL_COUNT
#   TESTCASE_ASSERTIONS_FAIL_COUNT
#   TESTCASE_ASSERTIONS_SUCCESS_COUNT
#
# External executables:
#   None   
#
# Other function dependencies:
#   reset_testcase_counters
#
# Outputs:
#   None
#
# Returns:
#   None
#   
# Documentation:
#   Created in 3 de set. de 2022
#   Updated in 3 de set. de 2022
#----------------------------------------
reset_testcase_counters() {
  export TESTCASE_ASSERTIONS_TOTAL_COUNT=0
  export TESTCASE_ASSERTIONS_FAIL_COUNT=0
  export TESTCASE_ASSERTIONS_SUCCESS_COUNT=0
}

#----------------------------------------
# Prepare environment to run sh-unit unit tests:
#  - Define and export sh-unit global variables;
#  - Reset sh-unit counters
#
# Arguments:
#   None
# 
# Globals:
#   SH_UNIT_GLOBAL_VARS_ALREADY_DEFINED
#   TEST_FUNCTION_PREFIX
#   TEST_FILENAME_SUFIX
#   STATUS_SUCCESS
#   STATUS_ERROR   
#
# External executables:
#   None
#
# Other function dependencies:
#   reset_g_test_execution_status
#   reset_g_test_counters
#
# Outputs:
#   None
#
# Returns:
#   None
#
# Documentation:
#   Created in 3 de set. de 2022
#   Updated in 3 de set. de 2022
#----------------------------------------
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

# ======================================
# Run functions
# ======================================
define_sh_unit_global_variables
