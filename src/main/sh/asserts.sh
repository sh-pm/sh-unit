#!/bin/bash

source ../../../bootstrap.sh

include_file "$SRC_DIR_PATH/sh_unit_g_vars.sh"

define_sh_unit_global_variables

get_caller_info(){
	echo "$( basename "${BASH_SOURCE[2]}" ) (l. ${BASH_LINENO[1]})"
}

assert_equals(){
	
	local ASSERT_DESCRIPTION="$3"
	
	export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))

	if [[ "$1" == "$2" ]]; then
	
		echo -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
		
		export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
		export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
		
		return "$TRUE"
		
	else
		echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"		
		echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| is NOT EQUALs |$2|${ECHO_COLOR_NC}"

		export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))		 
		export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
		 
		TEST_EXECUTION_STATUS="$STATUS_ERROR"
		LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
		
		return "$FALSE"
	fi
}


assert_contains(){
	
	local ASSERT_DESCRIPTION="$3"
	
	export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))

	if [[ "$1" == *"$2"* ]]; then
	
		echo -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
		
		export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
		export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
		
		return "$TRUE"
		
	else
		echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"		
		echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| NOT contains |$2|${ECHO_COLOR_NC}"

		export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))		 
		export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
		 
		TEST_EXECUTION_STATUS="$STATUS_ERROR"
		LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
		
		return "$FALSE"
	fi
}

assert_start_with(){
	
	local ASSERT_DESCRIPTION="$3"
	
	export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
	
	if [[ ! -z "$1" && ! -z "$2" && "$1" =~ ^"$2".* ]]; then
	
		echo -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
		
		export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
		export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
		
		return "$TRUE"
	else
		echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
				
		if [[ -z "$1" || -z "$2" ]]; then 
			echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: Receive empty param(s): 1->|$1|, 2->|$2|${ECHO_COLOR_NC}"		
		else
			echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| NOT start with |$2|${ECHO_COLOR_NC}"		
		fi
	
		export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))		 
		export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
		 
		TEST_EXECUTION_STATUS="$STATUS_ERROR"
		LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
		
		return "$FALSE"
	fi
}

assert_end_with(){
	
	local ASSERT_DESCRIPTION="$3"
	
	export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
	
	if [[ ! -z "$1" && ! -z "$2" && "$1" =~ .*"$2"$ ]]; then
	
		echo -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
		
		export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
		export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
		
		return "$TRUE"
	else
		echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
				
		if [[ -z "$1" || -z "$2" ]]; then 
			echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: Receive empty param(s): 1->|$1|, 2->|$2|${ECHO_COLOR_NC}"		
		else
			echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$1| NOT end with |$2|${ECHO_COLOR_NC}"		
		fi
	
		export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))		 
		export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
		 
		TEST_EXECUTION_STATUS="$STATUS_ERROR"
		LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
		
		return "$FALSE"
	fi
}


assert_true(){
    local VALUE="$1"
    local ASSERT_DESCRIPTION="$2"
    
    export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
    
    if [[ -z "$VALUE" ]]; then
		LAST_FUNCTION_STATUS_EXECUTION="$?"
		VALUE=$LAST_FUNCTION_STATUS_EXECUTION
    fi

	if [[ "$VALUE" == "$TRUE" ]]; then
		echo -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
		
		export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
		export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
		
		return "$TRUE";
	else
    	echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
		echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$VALUE| is NOT true${ECHO_COLOR_NC}"
		
		export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))
		export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
		
		TEST_EXECUTION_STATUS="$STATUS_ERROR"
		LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
		
		return "$FALSE";
	fi
}	

assert_false(){
	local VALUE="$1"
    local ASSERT_DESCRIPTION="$2"
    
    export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
    
    if [[ -z $VALUE ]]; then
		LAST_FUNCTION_STATUS_EXECUTION="$?"
		VALUE=$LAST_FUNCTION_STATUS_EXECUTION
    fi

	if [[ $VALUE == "$TRUE" ]]; then
    	echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
	    
	    echo -e "${ECHO_COLOR_RED}     ${FUNCNAME[0]}: |$VALUE| is NOT false${ECHO_COLOR_NC}"
	    
	    export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))
	    export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))
	    
		TEST_EXECUTION_STATUS="$STATUS_ERROR"
		LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
		
		return "$FALSE";
	else
		echo -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
		
		export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
		export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))
		
		return "$TRUE";
	fi
}

assert_fail(){

	local ASSERT_DESCRIPTION="$1"

	export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export ASSERTIONS_FAIL_COUNT=$((ASSERTIONS_FAIL_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_FAIL_COUNT=$((TESTCASE_ASSERTIONS_FAIL_COUNT+1))

	echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
    
	TEST_EXECUTION_STATUS="$STATUS_ERROR"
	LAST_TESTCASE_EXECUTION_STATUS="$STATUS_ERROR"
	
	return "$FALSE"
}

assert_success(){

	local ASSERT_DESCRIPTION="$1"

	export ASSERTIONS_TOTAL_COUNT=$((ASSERTIONS_TOTAL_COUNT+1))
	export ASSERTIONS_SUCCESS_COUNT=$((ASSERTIONS_SUCCESS_COUNT+1))
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=$((TESTCASE_ASSERTIONS_TOTAL_COUNT+1))
	export TESTCASE_ASSERTIONS_SUCCESS_COUNT=$((TESTCASE_ASSERTIONS_SUCCESS_COUNT+1))

    echo -e "$( get_caller_info ): ${ECHO_COLOR_GREEN}Assert Success! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
    
    return "$TRUE"	
}

assert_array_contains() {
	local -n P_ARRAY=$1
	local ITEM=$2
	
	for array_item in ${P_ARRAY[@]}; do
		if [[ "$array_item" == "$ITEM" ]]; then
			return "$TRUE";
		fi
	done 
	
	echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect value |$ITEM| in array, but it NOT found: (${ECHO_COLOR_NC}"
	sh_unit_print_array_for_msg_error P_ARRAY
	
	return "$FALSE"
}

assert_array_not_contains() {
	local -n P_ARRAY=$1
	local ITEM=$2
	
	for array_item in ${P_ARRAY[@]}; do
		if [[ "$array_item" == "$ITEM" ]]; then
			
			echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect value |$ITEM| not in array, but it was found: (${ECHO_COLOR_NC}"
			sh_unit_print_array_for_msg_error P_ARRAY
			
			return "$FALSE";
		fi
	done 
	
	return "$TRUE"
}


assert_array_contains_values() {
	local -n P_ARRAY
	local -n P_VALUES
	local ITEM_FOUND
	
	P_ARRAY=$1
	P_VALUES=$2
	
	for expected_item in ${P_VALUES[@]}; do

		ITEM_FOUND="$FALSE"
		
		for array_item in ${P_ARRAY[@]}; do
		
			if [[ "$array_item" == "$expected_item" ]]; then
				ITEM_FOUND="$TRUE"
			fi
		done
		
		if [[ "$ITEM_FOUND" != "$TRUE" ]]; then
			echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect item |$expected_item| not found in array: (${ECHO_COLOR_NC}"
			sh_unit_print_array_for_msg_error P_ARRAY
		
			return "$FALSE"
		fi
	done

	return "$TRUE"	
}

assert_array_contains_only_this_values() {
	local -n P_ARRAY
	local -n P_VALUES
	
	local ITEM_FOUND
	
	P_ARRAY="$1"
	P_VALUES="$2"
	
	if [[ "${#P_ARRAY[@]}" != "${#P_VALUES[@]}" ]]; then
		echo -e "Arrays have diferent sizes! "
		echo -e "Array of values have size = ${#P_ARRAY[@]}"
		sh_unit_print_array_for_msg_error P_ARRAY
		
	 	echo -e "Array of EXPECTED values have size = ${#P_VALUES[@]}"
	 	sh_unit_print_array_for_msg_error P_VALUES
	 	
		return "$FALSE"
	fi
	
	for expected_item in ${P_VALUES[@]}; do

		ITEM_FOUND="$FALSE"
		
		for array_item in ${P_ARRAY[@]}; do
		
			if [[ "$array_item" == "$expected_item" ]]; then
				ITEM_FOUND="$TRUE"
			fi
		done
		
		if [[ "$ITEM_FOUND" != "$TRUE" ]]; then
			echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Expect item |$expected_item| not found in array: ${ECHO_COLOR_NC}"
		
			return "$FALSE"
		fi
	done
	
	
	for array_item in ${P_ARRAY[@]}; do

		ITEM_FOUND="$FALSE"
		
		for expected_item in ${P_VALUES[@]}; do		
			if [[ "$array_item" == "$expected_item" ]]; then
				ITEM_FOUND="$TRUE"
			fi
		done
		
		if [[ "$ITEM_FOUND" != "$TRUE" ]]; then
			echo -e "$( get_caller_info ): ${ECHO_COLOR_RED}Assert FAIL! Array contain a unexpected item |$array_item|${ECHO_COLOR_NC}"
			sh_unit_print_array_for_msg_error P_ARRAY
		
			return "$FALSE"
		fi
	done

	return "$TRUE"	
}
