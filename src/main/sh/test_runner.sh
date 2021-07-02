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

TEST_FUNCTION_PREFIX="test_"

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

array_contain_element() {
	local -n P_ARRAY="$1"
	local ELEMENT="$2"
	
	for iter in ${P_ARRAY[@]}; do
		if [[ "$iter" == "$ELEMENT" ]]; then
			return "$TRUE"
		fi	
	done
	
	return "$FALSE"
}

display_statistics() {
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
}

display_final_result() {
	echo "(*) FINAL RESULT of execution:"	
	if [[ "$TEST_EXECUTION_STATUS" != "$STATUS_OK" ]]; then 
		echo -e "      ${ECHO_COLOR_RED}FAIL!!!${ECHO_COLOR_NC}"
	else		
		echo -e "      ${ECHO_COLOR_GREEN}OK${ECHO_COLOR_NC}"
	fi
	echo ""
}

display_finish_execution() {
	echo ""
	echo "-------------------------------------------------------------"
	echo "Finish execution"
}

display_testcase_execution_statistics() {
	echo "  Assertions executed in $FUNCTION_NAME: "
	echo "   - Success: $TESTCASE_ASSERTIONS_SUCCESS_COUNT"
	echo "   - Fail:    $TESTCASE_ASSERTIONS_FAIL_COUNT"
	echo "   - Total:   $TESTCASE_ASSERTIONS_TOTAL_COUNT"
}

update_testcase_counters() {
	if [[ "$LAST_TESTCASE_EXECUTION_STATUS" != "$STATUS_OK" ]]; then
		export TESTCASE_FAIL_COUNT=$((TESTCASE_FAIL_COUNT+1))
	else
		export TESTCASE_SUCCESS_COUNT=$((TESTCASE_SUCCESS_COUNT+1))
	fi
	
	export TESTCASE_TOTAL_COUNT=$((TESTCASE_TOTAL_COUNT+1))
}

display_testcase_execution_start() {
	echo ""
	echo "---[ $FUNCTION_NAME ]----------------------------------------------------------"
	echo ""
}

display_test_file_delimiter() {
	echo -e "\n########################### $( basename "$1" ) ######################################################\n"
}

display_file_execution_start() {
	display_test_file_delimiter $1
	echo "Location: $1"
    echo "Start execution of test case(s)  ..."
}

run_test_case() {
	local TESTCASE_NAME
	
	TESTCASE_NAME="$1"

	display_testcase_execution_start
			
	LAST_TESTCASE_EXECUTION_STATUS="$STATUS_OK"
	
	reset_testcase_counters
	
	$TESTCASE_NAME # this line call/execute a test function!
	
	display_testcase_execution_statistics
	
	update_testcase_counters
}

get_all_function_names_from_file() {
	local SCRIPT_NAME_TO_RUN_TESTS
	
	SCRIPT_NAME_TO_RUN_TESTS="$1"
	
	grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$SCRIPT_NAME_TO_RUN_TESTS" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

get_all_test_function_names_from_file() {
	local SCRIPT_NAME_TO_RUN_TESTS
	
	SCRIPT_NAME_TO_RUN_TESTS="$1"
	
	get_all_function_names_from_file "$SCRIPT_NAME_TO_RUN_TESTS" | grep -E '^'$TEST_FUNCTION_PREFIX'*' 
}

run_testcases_in_file() {

	local SCRIPT_NAME_TO_RUN_TESTS
	local -n P_FUNCTIONS_TO_RUN
	
	SCRIPT_NAME_TO_RUN_TESTS="$1"
	P_FUNCTIONS_TO_RUN="$2"
	
    display_file_execution_start "$SCRIPT_NAME_TO_RUN_TESTS"
     
	source "$SCRIPT_NAME_TO_RUN_TESTS"

    TEST_FUNCTIONS_IN_FILE=( $( get_all_test_function_names_from_file "$SCRIPT_NAME_TO_RUN_TESTS" ) );
    
    reset_g_test_counters
	
	for FUNCTION_NAME in "${TEST_FUNCTIONS_IN_FILE[@]}"
	do
		if (( ${#P_FUNCTIONS_TO_RUN[@]} > 0 )); then
		 	if ( array_contain_element P_FUNCTIONS_TO_RUN "$FUNCTION_NAME" ); then		 			
				run_test_case "$FUNCTION_NAME"
			fi
		else
			run_test_case "$FUNCTION_NAME"
		fi
	done
	
	display_finish_execution
	
	display_statistics
	
	display_final_result
	
	if [[ "$TEST_EXECUTION_STATUS" == "$STATUS_OK" ]]; then
		return "$TRUE";
	else		
		return "$FALSE";
	fi
}

run_all_tests_in_this_script() {

	SCRIPT_NAME_TO_RUN_TESTS="$(basename "${BASH_SOURCE[1]}")"

	run_testcases_in_file "$SCRIPT_NAME_TO_RUN_TESTS"
}

run_testcases_in_files() {

	local -n P_ALL_TEST_FILES
  	local -n P_TEST_FILTERS
  	
  	local FUNCTIONS_TO_RUN
  	local FILE
	
	P_ALL_TEST_FILES="$1"
  	P_TEST_FILTERS="$2"
  	
  	# Run WITH filters
  	if (( "${#P_TEST_FILTERS[@]}" > 0 )); then
	  	for test_filter in ${P_TEST_FILTERS[@]}; do
	  		if [[ "$test_filter" == *"="* ]]; then
	  			FILE=${test_filter%=*}
				FUNCTIONS_TO_RUN_STR=${test_filter#*=}
				
				if [[ ! -z "$FUNCTIONS_TO_RUN_STR" ]]; then
					if [[ "$FUNCTIONS_TO_RUN_STR" == *","* ]]; then
						IFS=',' read -r -a FUNCTIONS_TO_RUN <<< "$FUNCTIONS_TO_RUN_STR"
					else
						FUNCTIONS_TO_RUN=( "$FUNCTIONS_TO_RUN_STR" ) 	
					fi
				fi
			else
				FILE=${test_filter}				
				FUNCTIONS_TO_RUN=( )
	  		fi
	  		
			for file in "${P_ALL_TEST_FILES[@]}"; do
				if [[ $( basename "$file" ) == "$FILE" ]]; then
					run_testcases_in_file "$file" FUNCTIONS_TO_RUN					
				fi
			done
	  	done
  	# Run WITHOUT filters	  	
	else
		FUNCTIONS_TO_RUN=( )
		if (( "${#P_ALL_TEST_FILES[@]}" > 0 )); then
			for file in "${P_ALL_TEST_FILES[@]}"
			do
				run_testcases_in_file "$file" FUNCTIONS_TO_RUN
			done
		else
			shpm_log "No test files found!"
		fi
  	fi
  	
  	shpm_log "\n########################################################################################################"
	shpm_log "\nFinish execution of files\n"
}
