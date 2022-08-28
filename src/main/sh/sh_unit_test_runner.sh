#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$SRC_DIR_PATH/sh_unit_log.sh"
include_file "$SRC_DIR_PATH/sh_unit_g_vars.sh"
include_file "$SRC_DIR_PATH/sh_unit_util.sh"

display_statistics() {

	local script_name_to_run_tests
	
	script_name_to_run_tests="$1"

	sh_unit_log ""
	sh_unit_log "(*) ASSERTIONS executed in $script_name_to_run_tests: "
	sh_unit_log "    - Total:   $ASSERTIONS_TOTAL_COUNT"
	sh_unit_log "    - Success: $ASSERTIONS_SUCCESS_COUNT"
	sh_unit_log "    - Fail:    $ASSERTIONS_FAIL_COUNT"
	sh_unit_log ""
	sh_unit_log "(*) TEST CASES executed in $script_name_to_run_tests: "
	sh_unit_log "    - Total:   $TESTCASE_TOTAL_COUNT"
	sh_unit_log "    - Success: $TESTCASE_SUCCESS_COUNT"
	sh_unit_log "    - Fail:    $TESTCASE_FAIL_COUNT"
	sh_unit_log ""
}

display_final_result() {
	sh_unit_log "(*) FINAL RESULT of execution:"	
	if [[ "$TEST_EXECUTION_STATUS" != "$STATUS_SUCCESS" ]]; then 
		sh_unit_log -e "      ${ECHO_COLOR_RED}FAIL!!!${ECHO_COLOR_NC}"
	else		
		sh_unit_log -e "      ${ECHO_COLOR_GREEN}OK${ECHO_COLOR_NC}"
	fi
	sh_unit_log ""
}

display_finish_execution() {
	sh_unit_log ""
	sh_unit_log "-------------------------------------------------------------"
	sh_unit_log "Finish execution"
}

display_testcase_execution_statistics() {
	local testcase_name
	
	testcase_name="$1"
	
	sh_unit_log "  Assertions executed in $testcase_name: "
	sh_unit_log "   - Success: $TESTCASE_ASSERTIONS_SUCCESS_COUNT"
	sh_unit_log "   - Fail:    $TESTCASE_ASSERTIONS_FAIL_COUNT"
	sh_unit_log "   - Total:   $TESTCASE_ASSERTIONS_TOTAL_COUNT"
}

display_finish_execution_of_files() {
  	sh_unit_log -e "\n########################################################################################################"
	sh_unit_log -e "\nFinish execution of files\n"
}

update_testcase_counters() {
	if [[ "$LAST_TESTCASE_EXECUTION_STATUS" == "$STATUS_OK" ]]; then
		export TESTCASE_SUCCESS_COUNT=$((TESTCASE_SUCCESS_COUNT+1))
	else
		export TESTCASE_FAIL_COUNT=$((TESTCASE_FAIL_COUNT+1))
	fi
	
	export TESTCASE_TOTAL_COUNT=$((TESTCASE_TOTAL_COUNT+1))
}

display_testcase_execution_start() {
	local testcase_name
	
	testcase_name="$1"
	
	sh_unit_log ""
	sh_unit_log "---[ $testcase_name ]----------------------------------------------------------"
	sh_unit_log ""
}

display_test_file_delimiter() {
	sh_unit_log -e "\n########################### $( basename "$1" ) ######################################################\n"
}

display_file_execution_start() {
	display_test_file_delimiter "$1"
	sh_unit_log "Location: $1"
    sh_unit_log "Start execution of test case(s)  ..."
}

get_all_function_names_from_file() {
	local script_name_to_run_tests
	
	script_name_to_run_tests="$1"
	
	grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$script_name_to_run_tests" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

get_all_test_function_names_from_file() {
	local script_name_to_run_tests
	
	script_name_to_run_tests="$1"
	
	grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$script_name_to_run_tests" | grep -E '^test_*' | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

run_testcases_in_files() {

	local -n p_all_test_files
  	local -n p_test_filters
  	
  	local functions_to_run_str
  	local file
	
	p_all_test_files="$1"
  	p_test_filters="$2"
  	
  	# Run WITH filters
  	if (( "${#p_test_filters[@]}" > 0 )); then
	  	for test_filter in "${p_test_filters[@]}"; do
	  		if [[ "$test_filter" == *"="* ]]; then
	  			file=${test_filter%=*}
				functions_to_run_str=${test_filter#*=}
				
				if [[ -n "$functions_to_run_str" ]]; then
					if [[ "$functions_to_run_str" == *","* ]]; then
						IFS=',' read -r -a FUNCTIONS_TO_RUN <<< "$functions_to_run_str"
					else
						FUNCTIONS_TO_RUN=( "$functions_to_run_str" ) 	
					fi
				fi
			else
				file=${test_filter}				
				FUNCTIONS_TO_RUN=( )
	  		fi
	  		
			for file_iterator in "${p_all_test_files[@]}"; do
				if [[ $( basename "$file_iterator" ) == "$file" ]]; then
					run_testcases_in_file "$file" FUNCTIONS_TO_RUN					
				fi
			done
	  	done
  	# Run WITHOUT filters	  	
	else
		FUNCTIONS_TO_RUN=( $( get_all_test_function_names_from_file ) )
		
		export FUNCTIONS_TO_RUN 
		
		if (( "${#p_all_test_files[@]}" > 0 )); then
			for file in "${p_all_test_files[@]}"
			do
				run_testcases_in_file "$file" FUNCTIONS_TO_RUN
			done
		else
			sh_unit_log "No test files found!"
		fi
  	fi
  	
	display_finish_execution_of_files
}

run_testcases_in_file() {

	local script_name_to_run_tests
	local -n p_functions_to_run
	
	script_name_to_run_tests="$1"
	p_functions_to_run="$2"
	
    display_file_execution_start "$script_name_to_run_tests"
     
	. "$script_name_to_run_tests"

    test_functions_in_file=( $( get_all_test_function_names_from_file "$script_name_to_run_tests" ) );    
	
	for function_name in "${test_functions_in_file[@]}"
	do
		if (( ${#p_functions_to_run[@]} > 0 )); then
		 	if ( array_contain_element p_functions_to_run "$function_name" ); then		 			
				run_test_case "$function_name"
			fi
		else
			run_test_case "$function_name"
		fi
	done
	
	display_finish_execution
	
	display_statistics "$script_name_to_run_tests"
	
	display_final_result
	
	if [[ "$TEST_EXECUTION_STATUS" == "$STATUS_OK" ]]; then
		return "$TRUE";
	else		
		return "$FALSE";
	fi
}

run_test_case() {
	local testcase_name
	
	testcase_name="$1"

	display_testcase_execution_start "$testcase_name"
			
	export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_OK"
	
	reset_testcase_counters
	
	$testcase_name # this line call/execute a test function!
	
	display_testcase_execution_statistics "$testcase_name"
	
	update_testcase_counters
}
