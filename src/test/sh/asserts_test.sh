#!/usr/bin/env bash

source ../../../bootstrap.sh

include_file "$TEST_DIR_PATH/base/sh_unit_test_base.sh"

# ======================================
# SUT
# ======================================
include_file "$SRC_DIR_PATH/asserts.sh"

# ======================================
# "Set-Up"
# ======================================
set_up() {
	init_sh_unit_internal_tests_execution
	
	define_sh_unit_global_variables
}
set_up

# ======================================
# "Teardown"
# ======================================
tear_down() {
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
	
	local EXPECTED
	
	EXPECTED="$( basename "${BASH_SOURCE[1]}" ) (l. ${BASH_LINENO[0]})"
	if [[ "$( get_caller_info )" != "$EXPECTED" ]]; then
		finish_test_case "get_caller_info not generate expected content. Expected: |$EXPECTED|, Generated: |$( get_caller_info )|" 
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
	
	eval "[[ $? == 1 ]]" || finish_test_case "last assert_equal not return expected \$FALSE value"

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
	local ARRAY=( "one" "two" "three" "four" "testing" )
	
	assert_array_contains ARRAY "three" 
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
	
	assert_array_contains ARRAY "one" 
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
	
	assert_array_contains ARRAY "two" 
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"	
	
	assert_array_contains ARRAY "four" 
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
	
	assert_array_contains ARRAY "testing" 
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains NOT return expected \$TRUE value"
		
}

test_assert_array_not_contains() {
	local ARRAY=( "one" "two" "three" "four" "testing" )
	
	assert_array_not_contains ARRAY "0" 
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_not_contains NOT return expected \$TRUE value"
		
	assert_array_not_contains ARRAY "test" 
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_not_contains NOT return expected \$TRUE value"
	
	assert_array_not_contains ARRAY "four" 
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_not_contains NOT return expected \$FALSE value"
}

test_assert_array_contains_values() {
	local ARRAY
	local VALUES
	
	ARRAY=( "one" "two" "three" "four" "testing" )
	
	VALUES=( "two" "three" "four" )
	assert_array_contains_values ARRAY VALUES  
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_values NOT return expected \$TRUE value"
		
	VALUES=( "two" "three" "four" "FIVE" )
	assert_array_contains_values ARRAY VALUES 
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_values NOT return expected \$FALSE value"
}

test_assert_array_contains_only_this_values() {
	local ARRAY
	local VALUES
	
	ARRAY=( "one" "two" "three" "four" "testing" )
	
	VALUES=( "one" "two" "three" "four" "testing" )
	assert_array_contains_only_this_values ARRAY VALUES  
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$TRUE value"
		
	VALUES=( "one" "two" "three" "four" )
	assert_array_contains_only_this_values ARRAY VALUES 
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
	
	VALUES=( "one" "two" "three" "four" "testing" "OTHER" )
	assert_array_contains_only_this_values ARRAY VALUES  
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
	
	VALUES=( "OTHER" "one" "two" "three" "four" "testing" )
	assert_array_contains_only_this_values ARRAY VALUES  
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
	
	VALUES=( "one" "two" "3" "4" "testing" )
	assert_array_contains_only_this_values ARRAY VALUES  
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$FALSE value"
	
	VALUES=( "testing" "two" "one" "four" "three" )
	assert_array_contains_only_this_values ARRAY VALUES  
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_only_this_values NOT return expected \$TRUE value"
}

# ======================================
# RUN TESTS!
# ======================================
test_get_caller_info
test_assert_equals
test_assert_contains
test_assert_start_with
test_assert_end_with
test_assert_array_contains
test_assert_array_contains_values
test_assert_contains_only_this_values