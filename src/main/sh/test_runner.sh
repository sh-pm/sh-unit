#!/bin/bash

source ../../../bootstrap.sh

include_lib sh-logger

# =================================
# echo -e colors
# =================================
ECHO_COLOR_ESC_CHAR='\033'
ECHO_COLOR_RED=$ECHO_COLOR_ESC_CHAR'[0;31m'
ECHO_COLOR_YELLOW=$ECHO_COLOR_ESC_CHAR'[0;93m'
ECHO_COLOR_GREEN=$ECHO_COLOR_ESC_CHAR'[0;32m'	
ECHO_COLOR_NC=$ECHO_COLOR_ESC_CHAR'[0m' # No Color

export TESTCASE_TOTAL_COUNT=0
export TESTCASE_FAIL_COUNT=0
export TESTCASE_SUCCESS_COUNT=0

export ASSERTIONS_TOTAL_COUNT=0
export ASSERTIONS_FAIL_COUNT=0
export ASSERTIONS_SUCCESS_COUNT=0

export TESTCASE_ASSERTIONS_TOTAL_COUNT=0
export TESTCASE_ASSERTIONS_FAIL_COUNT=0
export TESTCASE_ASSERTIONS_SUCCESS_COUNT=0


string_start_with(){
	STRING=$1
	SUBSTRING=$2
	if [[ $STRING == "$SUBSTRING"* ]]; then
		return 0;
	else
		return 1;
	fi
}


reset_g_test_counters() {
	TESTCASE_TOTAL_COUNT=0
	TESTCASE_FAIL_COUNT=0
	TESTCASE_SUCCESS_COUNT=0
	
	ASSERTIONS_TOTAL_COUNT=0
	ASSERTIONS_FAIL_COUNT=0
	ASSERTIONS_SUCCESS_COUNT=0
	
	reset_testcase_counters
}

reset_testcase_counters() {
	TESTCASE_ASSERTIONS_TOTAL_COUNT=0
	TESTCASE_ASSERTIONS_FAIL_COUNT=0
	TESTCASE_ASSERTIONS_SUCCESS_COUNT=0
}

run_all_tests_in_script() {
	local SCRIPT_NAME_TO_RUN_TESTS
	
	SCRIPT_NAME_TO_RUN_TESTS="$1"
	shift
		
	source "$SCRIPT_NAME_TO_RUN_TESTS"

    if [ $# -eq 0 ];  then
	    FUNCTIONS_TO_TEST=( $( grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$SCRIPT_NAME_TO_RUN_TESTS" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//' ) );
    else 
    	FUNCTIONS_TO_TEST=( $@ );   
    fi
    
    echo "Location: $SCRIPT_NAME_TO_RUN_TESTS"
    echo "Start execution of ${#FUNCTIONS_TO_TEST[@]} test case(s) found ..."
    
    reset_g_test_counters
	
	for FUNCTION_NAME in "${FUNCTIONS_TO_TEST[@]}"
	do
		if (string_start_with "$FUNCTION_NAME" "test_"); then
			echo ""
			echo "---[ $FUNCTION_NAME ]----------------------------------------------------------"
			echo ""
			
			LAST_TESTCASE_EXECUTION_STATUS="$STATUS_OK"
			
			reset_testcase_counters
			
			# Call test function
			$FUNCTION_NAME
			
			echo "  Assertions executed in $FUNCTION_NAME: "
			echo "   - Success: $TESTCASE_ASSERTIONS_SUCCESS_COUNT"
			echo "   - Fail:    $TESTCASE_ASSERTIONS_FAIL_COUNT"
			echo "   - Total:   $TESTCASE_ASSERTIONS_TOTAL_COUNT"
		fi
		
		if [[ "$LAST_TESTCASE_EXECUTION_STATUS" != "$STATUS_OK" ]]; then
			export TESTCASE_FAIL_COUNT=$((TESTCASE_FAIL_COUNT+1))
		else
			export TESTCASE_SUCCESS_COUNT=$((TESTCASE_SUCCESS_COUNT+1))
		fi
		
		export TESTCASE_TOTAL_COUNT=$((TESTCASE_TOTAL_COUNT+1))
		
	done
	
	echo ""
	echo "-------------------------------------------------------------"
	echo "Finish execution of ${#FUNCTIONS_TO_TEST[@]} test cases founds ..."
	echo ""
	echo "(*) ASSERTIONS executed in $SCRIPT_NAME_TO_RUN_TESTS: "
	echo "    - Total:   $ASSERTIONS_TOTAL_COUNT"
	echo "    - Success: $ASSERTIONS_SUCCESS_COUNT"
	echo "    - Fail:    $ASSERTIONS_FAIL_COUNT"
	echo ""
	echo "(*) TEST CASES executed in $SCRIPT_NAME_TO_RUN_TESTS: "
	echo "    - Total:   $TESTCASE_TOTAL_COUNT"
	echo "    - Success: $TESTCASE_SUCCESS_COUNT"
	echo "    - Fail:    $TESTCASE_FAIL_COUNT"
	echo ""
	echo "(*) FINAL RESULT of execution:"
	
	if [[ "$TEST_EXECUTION_STATUS" != "$STATUS_OK" ]]; then 
		echo -e "      ${ECHO_COLOR_RED}FAIL!!!${ECHO_COLOR_NC}"
	else		
		echo -e "      ${ECHO_COLOR_GREEN}OK${ECHO_COLOR_NC}"
	fi
	echo ""
	
	if [[ "$TEST_EXECUTION_STATUS" == "$STATUS_OK" ]]; then
		return "$TRUE";
	else		
		return "$FALSE";
	fi
}

run_all_tests_in_this_script() {

	SCRIPT_NAME_TO_RUN_TESTS="$(basename "${BASH_SOURCE[1]}")"

	run_all_tests_in_script "$SCRIPT_NAME_TO_RUN_TESTS"
}

run_all_tests_in_files() {

	local -n P_TEST_FILES
  	local -n P_TEST_FUNCTIONS
	
	P_TEST_FILES="$1"
  	P_TEST_FUNCTIONS="$2"

	if (( "${#P_TEST_FILES[@]}" > 0 )); then
			
			for file in "${P_TEST_FILES[@]}"
			do
				shpm_log "\n########################### $( basename "$file" ) ######################################################\n"
				run_all_tests_in_script "$file" "${P_TEST_FUNCTIONS[@]}"
			done
			
			shpm_log "\n########################################################################################################"
			shpm_log "\nFinish execution of files\n"
		else
			shpm_log "Nothing to test"
		fi
}
