#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$TEST_DIR_PATH/base/sh_unit_base4_unit_test_itself.sh"
include_file "$SRC_DIR_PATH/sh_unit_asserts.sh"

# ======================================
# SUT
# ======================================
include_file "$SRC_DIR_PATH/sh_unit_test_runner.sh"

# ======================================
# "Set-Up"
# ======================================
set_up() {
	init_sh_unit_internal_tests_execution
}
set_up

# ======================================
# "Teardown"
# ======================================
tear_down() {
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

test_get_all_function_names_from_file() {
	before_testcase_start

	local EXPECTED_FUNCTION_NAMES
	local OBTAINED_FUNCTION_NAMES
	
	OBTAINED_FUNCTION_NAMES=( $( get_all_function_names_from_file "$TEST_RESOURCES_DIR_PATH/file_4test_with_functions.sh" ) )
	
	EXPECTED_FUNCTION_NAMES=( "set_up" "tear_down" "before_testcase_start" "after_testcase_finish" "test_get_all_function_names_from_file" "test_other_something_test")
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $TRUE ]]" || finish_test_case "last test_assert_contains_only_this_values call NOT return expected \$TRUE value"
	
	EXPECTED_FUNCTION_NAMES=( "set_up" "tear_down" "before_testcase_start" "xpto_function" "test_get_all_function_names_from_file" "test_other_something_test" )
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $FALSE ]]" || finish_test_case "last test_assert_contains_only_this_values call NOT return expected \$FALSE value"
	
	EXPECTED_FUNCTION_NAMES=( "set_up" "tear_down" "before_testcase_start" "after_testcase_finish" )
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $FALSE ]]" || finish_test_case "last test_assert_contains_only_this_values call NOT return expected \$FALSE value"
	
	EXPECTED_FUNCTION_NAMES=( "set_up" "tear_down" "before_testcase_start" "after_testcase_finish" "test_get_all_function_names_from_file" "test_other_something_test" "more_one_function" )
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $FALSE ]]" || finish_test_case "last test_assert_contains_only_this_values call NOT return expected \$FALSE value"
}

test_get_all_test_function_names_from_file() {
	before_testcase_start
	
	local EXPECTED_FUNCTION_NAMES
	local OBTAINED_FUNCTION_NAMES
	
	OBTAINED_FUNCTION_NAMES=( $( get_all_test_function_names_from_file "$TEST_RESOURCES_DIR_PATH/file_4test_with_functions.sh" ) )
	
	EXPECTED_FUNCTION_NAMES=( "test_get_all_function_names_from_file" "test_other_something_test" )
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_only_this_values call NOT return expected \$TRUE value"
	
	EXPECTED_FUNCTION_NAMES=( "test_other_something_test" "test_get_all_function_names_from_file" )
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $TRUE ]]" || finish_test_case "last assert_array_contains_only_this_values call NOT return expected \$TRUE value"
	
	EXPECTED_FUNCTION_NAMES=( "test_other_something_test" )
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values call NOT return expected \$FALSE value"
	
	EXPECTED_FUNCTION_NAMES=( "test_other_something_test" "test_get_all_function_names_from_file" "test_other_function" )
	assert_array_contains_only_this_values OBTAINED_FUNCTION_NAMES EXPECTED_FUNCTION_NAMES
	eval "[[ $? == $FALSE ]]" || finish_test_case "last assert_array_contains_only_this_values call NOT return expected \$FALSE value"
}

test_run_test_case() {

	reset_g_test_execution_status
	reset_g_test_counters

	include_file "$TEST_RESOURCES_DIR_PATH/example_of_target_file_test.sh"
	
	#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "0"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "0"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "0"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "0"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
	 
	run_test_case "test_function_example1"
	
		#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "1"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "0"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "1"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "1"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "1"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
	
	run_test_case "test_function_example2"
	
		#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "2"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "0"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "2"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "2"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "2"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "1"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"
	
	run_test_case "test_function_example3"
	
	#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "3"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "1"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "2"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "3"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "1"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "2"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "1"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$FALSE"    "${!TEST_EXECUTION_STATUS@}"
}

test_run_testcases_in_file() {
	reset_g_test_execution_status
	reset_g_test_counters

	local TEST_FUNCTIONS_TO_RUN
	
	TEST_FUNCTIONS_TO_RUN=( \
		"test_function_example1" \
		"test_function_example2" \
		"test_function_example3" \
	)
	
	#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "0"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "0"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "0"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "0"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"

	run_testcases_in_file "$TEST_RESOURCES_DIR_PATH/example_of_target_file_test.sh" TEST_FUNCTIONS_TO_RUN 

	#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "3"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "1"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "2"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "3"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "1"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "2"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "1"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "1"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$FALSE"    "${!TEST_EXECUTION_STATUS@}"
	
	after_testcase_finish
}

test_run_testcases_in_files() {
	reset_g_test_execution_status
	reset_g_test_counters

	local TEST_FILES_TO_RUN
	local TEST_FILTERS
	
	TEST_FILES_TO_RUN=( \
		"$TEST_RESOURCES_DIR_PATH/example_of_target_file_test.sh" \
		"$TEST_RESOURCES_DIR_PATH/example_of_target_file_test2.sh" \
	)
	
	#TEST_FILTERS=( \
	#	"example_of_target_file_test.sh=test_function_example1" \
	#	"example_of_target_file_test.sh=test_function_example2" \
	#	"example_of_target_file_test2.sh=test_function_example5" \
	#	"example_of_target_file_test2.sh=test_function_example6" \
	#)
	
	TEST_FILTERS=( )
	
	#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "0"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "0"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "0"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "0"        "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "0"        "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "0"        "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$TRUE"    "${!TEST_EXECUTION_STATUS@}"

	run_testcases_in_files TEST_FILES_TO_RUN TEST_FILTERS
	
	#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_SUCCESS"                    "$TRUE"    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_exists_and_value_is_equal "$STATUS_ERROR"                      "$FALSE"   "${!STATUS_ERROR@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FUNCTION_PREFIX"              "test_"    "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_FILENAME_SUFIX"               "_test.sh" "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_TOTAL_COUNT"              "6"        "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_FAIL_COUNT"               "2"        "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TESTCASE_SUCCESS_COUNT"            "4"        "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "6"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "2"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "4"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$TEST_EXECUTION_STATUS"             "$FALSE"    "${!TEST_EXECUTION_STATUS@}"
	
	after_testcase_finish
}

# ======================================
# RUN Tests
# ======================================
test_get_all_function_names_from_file
test_get_all_test_function_names_from_file
test_run_testcases_in_files
test_run_test_case
test_run_testcases_in_file