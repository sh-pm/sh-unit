#!/usr/bin/env bash

. ../../../bootstrap.sh

include_file "$TEST_DIR_PATH/base/sh_unit_base4_unit_test_itself.sh"

# ======================================
# SUT
# ======================================
include_file "$SRC_DIR_PATH/sh_unit_util.sh"

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


# ======================================
# After each TestCase Finish
# ======================================


# ======================================
# Tests
# ======================================
test_string_start_with() {

  string_start_with "test are so cool!" "test are so cool!"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last string_start_with call NOT return expected \$TRUE value"
  
  string_start_with "test are so cool!" "test are so cool"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last string_start_with call NOT return expected \$TRUE value"
  
  string_start_with "test are so cool!" "test are"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last string_start_with call NOT return expected \$TRUE value"
  
  string_start_with "test are so cool!" "test a"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last string_start_with call NOT return expected \$TRUE value"
  
  string_start_with "test are so cool!" "t"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last string_start_with call NOT return expected \$TRUE value"
  
  string_start_with "test are so cool!" "x"
  eval "[[ $? == $FALSE ]]" || finish_test_case "last string_start_with call NOT return expected \$FALSE value"
}

test_array_contain_element() {

  local test_array

  test_array=( \
    "one"
    "TWO"
    "Three"
  )

  array_contain_element test_array "one"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last array_contain_element call NOT return expected \$TRUE value"
  
  array_contain_element test_array "TWO"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last array_contain_element call NOT return expected \$TRUE value"
  
  array_contain_element test_array "Three"
  eval "[[ $? == $TRUE ]]" || finish_test_case "last array_contain_element call NOT return expected \$TRUE value"
  
  array_contain_element test_array "ONE"
  eval "[[ $? == $FALSE ]]" || finish_test_case "last array_contain_element call NOT return expected \$FALSE value"
  
  array_contain_element test_array "four"
  eval "[[ $? == $FALSE ]]" || finish_test_case "last array_contain_element call NOT return expected \$FALSE value"
}

# ======================================
# RUN Tests
# ======================================
test_string_start_with
test_array_contain_element