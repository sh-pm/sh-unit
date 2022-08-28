#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$TEST_DIR_PATH/base/sh_unit_base4_unit_test_itself.sh"

# ======================================
# SUT
# ======================================
# ATIPICAL TEST: See include inside test function ...

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
# Tests
# ======================================

ensure_true_and_false_bootstrap_global_vars() {
	if [[ "$TRUE" != "0" || "$FALSE" == "0" ]]; then
		finish_test_case "bootstrap global vars \$TRUE and \$FALSE with wrong values: \$TRUE=$TRUE and \$FALSE=$FALSE"
	fi
}

test_define_sh_unit_global_variables() {

	ensure_true_and_false_bootstrap_global_vars

	#-----Assertion call---------|------------Var value----------------|-------------Var name------------------	
	sh_unit_assert_var_NOT_exists "$STATUS_SUCCESS"                    "${!STATUS_SUCCESS@}"
	sh_unit_assert_var_NOT_exists "$STATUS_ERROR"                      "${!STATUS_ERROR@}"
	sh_unit_assert_var_NOT_exists "$TEST_FUNCTION_PREFIX"              "${!TEST_FUNCTION_PREFIX@}"	
	sh_unit_assert_var_NOT_exists "$TEST_FILENAME_SUFIX"               "${!TEST_FILENAME_SUFIX@}"
	sh_unit_assert_var_NOT_exists "$TESTCASE_TOTAL_COUNT"              "${!TESTCASE_TOTAL_COUNT@}"
	sh_unit_assert_var_NOT_exists "$TESTCASE_FAIL_COUNT"               "${!TESTCASE_FAIL_COUNT@}"
	sh_unit_assert_var_NOT_exists "$TESTCASE_SUCCESS_COUNT"            "${!TESTCASE_SUCCESS_COUNT@}"
	sh_unit_assert_var_NOT_exists "$ASSERTIONS_TOTAL_COUNT"            "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_NOT_exists "$ASSERTIONS_FAIL_COUNT"             "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_NOT_exists "$ASSERTIONS_SUCCESS_COUNT"          "${!ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_NOT_exists "$TESTCASE_ASSERTIONS_TOTAL_COUNT"   "${!TESTCASE_ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_NOT_exists "$TESTCASE_ASSERTIONS_FAIL_COUNT"    "${!TESTCASE_ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_NOT_exists "$TESTCASE_ASSERTIONS_SUCCESS_COUNT" "${!TESTCASE_ASSERTIONS_SUCCESS_COUNT@}"
	sh_unit_assert_var_NOT_exists "$TEST_EXECUTION_STATUS"             "${!TEST_EXECUTION_STATUS@}"
	sh_unit_assert_var_NOT_exists "$LAST_TESTCASE_EXECUTION_STATUS"    "${!LAST_TESTCASE_EXECUTION_STATUS@}"
	
	#-------------------------------
	include_file "$SRC_DIR_PATH/sh_unit_g_vars.sh"
	#-------------------------------
	
	ensure_true_and_false_bootstrap_global_vars
	
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
	sh_unit_assert_var_exists_and_value_is_equal "$LAST_TESTCASE_EXECUTION_STATUS"    "$TRUE"    "${!LAST_TESTCASE_EXECUTION_STATUS@}"	
}

# ======================================
# RUN Tests
# ======================================
test_define_sh_unit_global_variables