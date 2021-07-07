#!/bin/bash

source ../../../bootstrap.sh

define_sh_unit_global_variables() {
	export TEST_FUNCTION_PREFIX="test_"
	export TEST_FILENAME_SUFIX="_test.sh"
	
	export STATUS_SUCCESS="$TRUE"
	export STATUS_ERROR="$FALSE"
	
	export TEST_EXECUTION_STATUS="$STATUS_SUCCESS"
	export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_SUCCESS"
	
	reset_g_test_counters
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
