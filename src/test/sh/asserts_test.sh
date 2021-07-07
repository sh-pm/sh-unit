#!/usr/bin/env bash

source ../../../bootstrap.sh

include_file "$TEST_DIR_PATH/sh_unit_test_util.sh"

# ======================================
# SUT
# ======================================
include_file "$SRC_DIR_PATH/asserts.sh"

# ======================================
# "Set-Up"
# ======================================
set_up() {
	echo "set_up nothing to do"
}
set_up

# ======================================
# "Teardown"
# ======================================
tear_down() {
	echo "tear_down nothing to do!"
}
trap "tear_down" EXIT

# ======================================
# Tests
# ======================================
test_get_caller_info() {
	local EXPECTED
	
	EXPECTED="$( basename "${BASH_SOURCE[1]}" ) (l. ${BASH_LINENO[0]})"
	if [[ "$( get_caller_info )" != "$EXPECTED" ]]; then
		finish_test_case "get_caller_info not generate expected content. Expected: |$EXPECTED|, Generated: |$( get_caller_info )|" 
	fi	
}

test_assert_equals() {

	#--------------Assertion call---------------|------------Var value----------------|-Expected-|-----------Var name------------------	
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_TOTAL_COUNT"            "0"        "${!ASSERTIONS_TOTAL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_FAIL_COUNT"             "0"        "${!ASSERTIONS_FAIL_COUNT@}"
	sh_unit_assert_var_exists_and_value_is_equal "$ASSERTIONS_SUCCESS_COUNT"          "0"        "${!ASSERTIONS_SUCCESS_COUNT@}"
	

	assert_equals "1" "1"
	
	
}

test_assert_equals