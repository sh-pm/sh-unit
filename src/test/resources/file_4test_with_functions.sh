#!/usr/bin/env bash

source ../../../bootstrap.sh


# ======================================
# SUT
# ======================================
include_file "$TEST_RESOURCES_DIR_PATH/target_file4test.sh"

# ======================================
# "Set-Up"
# ======================================
set_up() {
	echo "Nothing to do!"
}
set_up

# ======================================
# "Teardown"
# ======================================
tear_down() {
	echo "Nothing to do!"
}
trap "tear_down" EXIT

# ======================================
# Before each TestCase Start
# ======================================
before_testcase_start() {
	echo "Nothing to do!"
}

# ======================================
# After each TestCase Finish
# ======================================
after_testcase_finish() {
	echo "Nothing to do!"
}

# ======================================
# Tests
# ======================================

test_get_all_function_names_from_file() {
	echo "test1" 
}

test_other_something_test() {
	echo "test2" 
}

# ======================================
# RUN Tests
# ======================================
test_get_all_function_names_from_file