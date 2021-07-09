reset_sh_unit_tests_execution_status() {
	SH_UNIT_TEST_EXECUTION_SUCCESS="$TRUE"
}

finish_test_case() {
	local ASSERT_DESCRIPTION
	ASSERT_DESCRIPTION="$1"
	
	echo -e "$( basename "${BASH_SOURCE[2]}" ) (l. ${BASH_LINENO[1]}): SH-UNIT Assertion Error! $ASSERT_DESCRIPTION"
	
	export TEST_EXECUTION_STATUS="$FALSE"
	export LAST_TESTCASE_EXECUTION_STATUS="$FALSE"
	
	echo ""
	echo "--STACK:------------------------------"
	for ((i=0;i<${#FUNCNAME[@]}-1;i++))
    do
      echo " $i: $( basename ${BASH_SOURCE[$i+1]} ) (l.${BASH_LINENO[$i]}): ${FUNCNAME[$i]}"
    done
    echo "--------------------------------------"
    echo ""
	 
	SH_UNIT_TEST_EXECUTION_SUCCESS="$FALSE"
}

sh_unit_assert_var_exists_and_value_is_equal() {
	local VAR_VALUE
	local EXPECTED_VALUE
	local VAR_NAME
	
	VAR_VALUE="$1"
	EXPECTED_VALUE="$2"
	VAR_NAME="$3"
	
	if [[ -z "$VAR_VALUE" ]]; then
		finish_test_case "Variable NOT exists! $VAR_NAME"
	fi
	
	if [[ "$VAR_VALUE" != "$EXPECTED_VALUE" ]]; then
		finish_test_case "Variable NOT contains expected value! Have: $VAR_NAME=|$VAR_VALUE|, Expected: $VAR_NAME=|$EXPECTED_VALUE|"
	fi
}

sh_unit_assert_var_NOT_exists() {
	VAR_VALUE="$1"
	VAR_NAME="$2"
	
	if [[ ! -z "$VAR_VALUE" ]]; then
		finish_test_case "Variable already exists! $VAR_NAME"
	fi
}

sh_unit_print_array_for_msg_error() {
	local -n AUX_ARRAY
	AUX_ARRAY=$1
	
	echo -e "("
	for array_item in ${AUX_ARRAY[@]}; do
		echo -e "   |$array_item|"
	done 
	echo -e ")"
}

array_dump() {
	local -n AUX_ARRAY
	AUX_ARRAY=$1
	
	local AUX_STR
	
	AUX_STR="$AUX_STR""( ";
	for array_item in ${AUX_ARRAY[@]}; do
		AUX_STR="$AUX_STR"" \"$array_item\"";
	done 
	AUX_STR="$AUX_STR"" )";
	
	echo "$AUX_STR"
}

init_sh_unit_internal_tests_execution() {
	echo ""
	echo "======= SH-UNIT internal tests execution start =============="
	echo ""
	reset_sh_unit_tests_execution_status
}

finish_sh_unit_internal_tests_execution() {
	check_sh_unit_internal_tests_result
}

check_sh_unit_internal_tests_result() {
	echo ""
	echo "======= SH-UNIT internal tests execution finish =============="
	if [[ "$SH_UNIT_TEST_EXECUTION_SUCCESS" == "$TRUE" ]]; then
		echo -e "               ${ECHO_COLOR_GREEN}Result: SUCCESS!${ECHO_COLOR_NC}"
	else
		echo -e "               ${ECHO_COLOR_RED}Result: FAIL!!!${ECHO_COLOR_NC}"
	fi
	echo "=============================================================="
	echo ""
}