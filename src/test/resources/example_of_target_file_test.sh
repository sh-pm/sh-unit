#!/usr/bin/env bash

source ../../../bootstrap.sh

include_file "$SRC_DIR_PATH/sh_unit_asserts.sh"

# ======================================
# SUT
# ======================================
include_file "$TEST_RESOURCES_DIR_PATH/example_of_target_file.sh"

# ======================================
# "Set-Up"
# ======================================
set_up() {
	echo ""
}
set_up

# ======================================
# "Teardown"
# ======================================

# WARNING: 
# Below tear_down function commeted to NOT CONFLIT WITH tear_down trap already defined in test_runner_test.sh

#tear_down() {
#	echo "Nothing to do!"
#}
# trap "tear_down" EXIT 

# ======================================
# Before each TestCase Start
# ======================================
before_testcase_start() {
	echo ""
}

# ======================================
# After each TestCase Finish
# ======================================
after_testcase_finish() {
	echo ""
}

# ======================================
# Tests
# ======================================

test_function_example1() {
	function_example1
	assert_equals "$?" "$TRUE"
}

test_function_example2() {
	function_example2
	assert_equals "$?" "$TRUE"
}

test_function_example3() {
	function_example3
	assert_equals "$?" "$TRUE" # this assert will fail!
}