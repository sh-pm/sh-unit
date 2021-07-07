finish_test_case() {
	local ASSERT_DESCRIPTION
	ASSERT_DESCRIPTION="$1"
	
	echo -e "$( basename "${BASH_SOURCE[2]}" ) (l. ${BASH_LINENO[0]}): ${ECHO_COLOR_RED}Internal test assertion Error! $ASSERT_DESCRIPTION${ECHO_COLOR_NC}"
	
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
	
	 
	exit 1
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