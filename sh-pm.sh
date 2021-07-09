#### pom.sh ########################################################################################################
GIT_REMOTE_REPOSITORY=github.com/sh-pm
GROUP_ID=bash
ARTIFACT_ID=sh-pm
VERSION=v5.0.0
declare -A DEPENDENCIES=( \
    [sh-logger]=v1.4.0@github.com/sh-pm \
    [sh-unit]=v1.5.9@github.com/sh-pm \
);
#### bootstrap.sh ##################################################################################################
# =================================
# Internal Log
# =================================
internal_debug() {
	local ENABLE_DEBUG="false"
	if [[ "$ENABLE_DEBUG" == "true" ]]; then
		echo "$1"
	fi
}
# =================================
# Mandatory Global Variables
# =================================
# -- bootstrap file name ----------
BOOTSTRAP_FILENAME="$(basename "${BASH_SOURCE[0]}")"
# -- dependencies file name ----------
DEPENDENCIES_FILENAME="pom.sh"
# -- "Boolean's" ------------------
TRUE=0
FALSE=1
# -- Test Coverage ----------------
MIN_PERCENT_TEST_COVERAGE=80
# -- Main SubPath's ---------------
if [[ -z "$SRC_DIR_SUBPATH" ]]; then
	SRC_DIR_SUBPATH="src/main/sh"
fi
if [[ -z "$SRC_RESOURCES_DIR_SUBPATH" ]]; then
	SRC_RESOURCES_DIR_SUBPATH="src/main/resources"
fi
if [[ -z "$LIB_DIR_SUBPATH" ]]; then
	LIB_DIR_SUBPATH="src/lib/sh"
fi
if [[ -z "$TEST_DIR_SUBPATH" ]]; then
	TEST_DIR_SUBPATH="src/test/sh"
fi
if [[ -z "$TEST_RESOURCES_DIR_SUBPATH" ]]; then
	TEST_RESOURCES_DIR_SUBPATH="src/test/resources"
fi
if [[ -z "$TARGET_DIR_SUBPATH" ]]; then
	TARGET_DIR_SUBPATH="target"
fi
# -- Main Path's ------------------
if [[ -z "$ROOT_DIR_PATH" ]]; then
	THIS_SCRIPT_FOLDER_PATH="$( dirname "$(realpath "${BASH_SOURCE[0]}")" )"
	ROOT_DIR_PATH="${THIS_SCRIPT_FOLDER_PATH//$SRC_DIR_SUBPATH/}"		
	internal_debug "ROOT_DIR_PATH: $ROOT_DIR_PATH"
fi
if [[ -z "$SRC_RESOURCES_DIR_PATH" ]]; then
	SRC_RESOURCES_DIR_PATH="$ROOT_DIR_PATH/$SRC_RESOURCES_DIR_SUBPATH"
	internal_debug "SRC_RESOURCES_DIR_PATH: $SRC_RESOURCES_DIR_PATH"
fi
if [[ -z "$SRC_DIR_PATH" ]]; then
	SRC_DIR_PATH="$ROOT_DIR_PATH/$SRC_DIR_SUBPATH"
	internal_debug "SRC_DIR_PATH: $SRC_DIR_PATH"
fi
if [[ -z "$LIB_DIR_PATH" ]]; then
	LIB_DIR_PATH="$ROOT_DIR_PATH/$LIB_DIR_SUBPATH"
	internal_debug "LIB_DIR_PATH: $LIB_DIR_PATH"
fi
if [[ -z "$TEST_DIR_PATH" ]]; then
	TEST_DIR_PATH="$ROOT_DIR_PATH/$TEST_DIR_SUBPATH"
	internal_debug "TEST_DIR_PATH: $TEST_DIR_PATH"
	
	FOLDERNAME_4TEST="folder4test"
	FILENAME_4TEST="file4test"
	PROJECTNAME_4TEST="sh-project-only-4tests"	
	PROJECTVERSION_4TEST="v0.2.0"
	NEWBRANCH_4TEST="newbranch4test"
	CHANGELOG_4TEST="changelog4test"
fi
if [[ -z "$TEST_RESOURCES_DIR_PATH" ]]; then
	TEST_RESOURCES_DIR_PATH="$ROOT_DIR_PATH/$TEST_RESOURCES_DIR_SUBPATH"
	internal_debug "TEST_RESOURCES_DIR_PATH: $TEST_RESOURCES_DIR_PATH"
fi
if [[ -z "$TARGET_DIR_PATH" ]]; then
	TARGET_DIR_PATH="$ROOT_DIR_PATH/$TARGET_DIR_SUBPATH"
	internal_debug "TARGET_DIR_PATH: $TARGET_DIR_PATH"
fi
if [[ -z "$TMP_DIR_PATH" ]]; then
    # WARNING: Used in 
    #   - secure rm -rf executions
    #   - unit tests
	TMP_DIR_PATH="/tmp"
	internal_debug "TMP_DIR_PATH: $TMP_DIR_PATH"
	
fi
# -- manifest file -------------------
MANIFEST_FILENAME="manifest"
MANIFEST_FILE_PATH="$SRC_RESOURCES_DIR_PATH/$MANIFEST_FILENAME"
MANIFEST_P_ENTRY_POINT_FILE="entry_point_file"
MANIFEST_P_ENTRY_POINT_FUNCTION="entry_point_function"
# =================================
# echo -e colors
# =================================
ECHO_COLOR_ESC_CHAR='\033'
ECHO_COLOR_RED=$ECHO_COLOR_ESC_CHAR'[0;31m'
ECHO_COLOR_YELLOW=$ECHO_COLOR_ESC_CHAR'[0;93m'
ECHO_COLOR_GREEN=$ECHO_COLOR_ESC_CHAR'[0;32m'	
ECHO_COLOR_NC=$ECHO_COLOR_ESC_CHAR'[0m' # No Color
# =================================
# Load dependencies
# =================================
# =================================
# Include Management Libs and Files
# =================================
if [[ -z ${DEPS_INCLUDED+x}  ]]; then
	declare -A DEPS_INCLUDED=( \
		
	);
fi
if [[ -z ${FILES_INCLUDED+x}  ]]; then
	declare -A FILES_INCLUDED=( \
		
	);
fi
function include_lib () {
    
    LIB_TO_INCLUDE=$1
    
    # Sanitize param
	if [[ -z "$LIB_TO_INCLUDE" ]]; then
		echo "Could't perform include_lib: function receive empty param."
		exit 1001
	fi
	
	# Validate include
	# Include library only one time
	if [[ ! -z "${DEPS_INCLUDED[$LIB_TO_INCLUDE]}" ]]; then
		internal_debug "include_lib: lib $LIB_TO_INCLUDE already included."
	fi
	
	local DEP_VERSION=$( echo "${DEPENDENCIES[$LIB_TO_INCLUDE]}" | cut -d "@" -f 1 | xargs ) #xargs is to trim string!	
	local DEP_FOLDER_PATH="$LIB_DIR_PATH/$LIB_TO_INCLUDE""-""$DEP_VERSION"
	
	if [[ ! -d "$DEP_FOLDER_PATH" ]]; then
		echo "Could't perform include_lib: $LIB_TO_INCLUDE not exists in local $LIB_DIR_PATH repository"
		exit 1002
	fi
	
	for SH_FILE in "$LIB_DIR_PATH/$LIB_TO_INCLUDE""-""$DEP_VERSION"/*; do
	    if [[ "$(basename "$SH_FILE")" != "$DEPENDENCIES_FILENAME" && "$(basename "$SH_FILE")" != "$BOOTSTRAP_FILENAME" ]]; then
			include_file "$SH_FILE" 
		else
	        internal_debug "$SH_FILE NOT included" 
		fi
	done
	
	DEPS_INCLUDED[$LIB_TO_INCLUDE]=$TRUE
}
function include_file () {
    
    FILEPATH_TO_INCLUDE=$1
    
    # Sanitize param
	if [[ -z "$FILEPATH_TO_INCLUDE" ]]; then
		echo "Could't perform include_file: function receive empty param."
		exit 1003
	fi
	
	# Validate include
	# Include file only one time
	if [[ ! -z "${FILES_INCLUDED[$FILEPATH_TO_INCLUDE]}" ]]; then
		internal_debug "$FILEPATH_TO_INCLUDE already included."
	else 
		source "$FILEPATH_TO_INCLUDE"
		
		FILES_INCLUDED[$FILEPATH_TO_INCLUDE]=$TRUE
		
	    internal_debug "$FILEPATH_TO_INCLUDE included"	
	fi	
}
#### shpm_package_manager.sh #######################################################################################
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# LIBRARIES 
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#### sh_logger.sh ##################################################################################################
LOG_LEVEL_FATAL="FATAL"
LOG_LEVEL_ERROR="ERROR"
LOG_LEVEL_WARN="WARN"
LOG_LEVEL_INFO="INFO"
LOG_LEVEL_DEBUG="DEBUG"
LOG_LEVEL_TRACE="TRACE"
if [[ -z "$LOG_LEVEL" ]]; then
	LOG_LEVEL=${ROOT_LOGGER_LEVEL:-$LOG_LEVEL_INFO}
fi
ESC_CHAR='\033'
RED=$ESC_CHAR'[0;31m'
GREEN=$ESC_CHAR'[0;32m'
YELLOW=$ESC_CHAR'[0;93m'
NC=$ESC_CHAR'[0m' # No Color
try_redirect_log_to_console_and_file(){
	# If was configured to log in console and file
	if [[ ! -z $SH_LOGGER_LOG_FILE ]]; then
		if [[ -f "$SH_LOGGER_LOG_FILE" ]]; then	
			exec 3>&1 1>> ${SH_LOGGER_LOG_FILE} 2>&1 # redirect stout and stderr to console and file
		fi			
	fi
}
print_msg(){
	local MSG=$1
	local LEVEL=$2
	local TIMESTAMP=`date +"%Y-%m-%d_%T.%3N"`
	
	local FILENAME=$( basename ${BASH_SOURCE[2]} )
	local LOG_LINE="$TIMESTAMP - $LEVEL - $FILENAME - ${FUNCNAME[2]} - $MSG"
	try_redirect_log_to_console_and_file
	
	if [[ "$LEVEL" == "$LOG_LEVEL_WARN" ]]; then 
		echo -e "${YELLOW}$LOG_LINE${NC}"
		return;
	fi
	if [[ "$LEVEL" == "$LOG_LEVEL_ERROR" ]]; then 
		echo -e "${RED}$LOG_LINE${NC}"
		return;
	fi
		
	echo "$LOG_LINE"
}
log_fatal(){
   if [[ $LOG_LEVEL == "$LOG_LEVEL_TRACE" || $LOG_LEVEL == "$LOG_LEVEL_DEBUG" || $LOG_LEVEL == "$LOG_LEVEL_INFO" || $LOG_LEVEL == "$LOG_LEVEL_WARN"  || $LOG_LEVEL == "$LOG_LEVEL_ERROR" || $LOG_LEVEL == "$LOG_LEVEL_FATAL" ]]; then
      print_msg "$@" $LOG_LEVEL_FATAL
   fi
}
log_error(){
   if [[ $LOG_LEVEL == "$LOG_LEVEL_TRACE" || $LOG_LEVEL == "$LOG_LEVEL_DEBUG" || $LOG_LEVEL == "$LOG_LEVEL_INFO" || $LOG_LEVEL == "$LOG_LEVEL_WARN"  || $LOG_LEVEL == "$LOG_LEVEL_ERROR" ]]; then
      print_msg "$@" $LOG_LEVEL_ERROR
   fi
}
log_warn(){
   if [[ $LOG_LEVEL == "$LOG_LEVEL_TRACE" || $LOG_LEVEL == "$LOG_LEVEL_DEBUG" || $LOG_LEVEL == "$LOG_LEVEL_INFO" || $LOG_LEVEL == "$LOG_LEVEL_WARN" ]]; then
      print_msg "$@" $LOG_LEVEL_WARN
   fi
}
log_info(){
   if [[ $LOG_LEVEL == "$LOG_LEVEL_TRACE" || $LOG_LEVEL == "$LOG_LEVEL_DEBUG" || $LOG_LEVEL == "$LOG_LEVEL_INFO" ]]; then
      print_msg "$@" $LOG_LEVEL_INFO
   fi
}
log_debug(){
   if [[ $LOG_LEVEL == "$LOG_LEVEL_TRACE" || $LOG_LEVEL == "$LOG_LEVEL_DEBUG" ]]; then
      print_msg "$@" $LOG_LEVEL_DEBUG
   fi
}
log_trace(){
   if [[ $LOG_LEVEL == "$LOG_LEVEL_TRACE" ]]; then
      print_msg "$@" $LOG_LEVEL_TRACE
   fi
}
#### sh-unit.sh ####################################################################################################
######## sh_unit_util.sh ######################################################################################################################
string_start_with(){
	local STRING=$1
	local SUBSTRING=$2
	
	if [[ $STRING == "$SUBSTRING"* ]]; then
		return "$TRUE";
	else
		return "$FALSE";
	fi
}
array_contain_element() {
	local -n P_ARRAY="$1"
	local ELEMENT="$2"
	
	for iter in ${P_ARRAY[@]}; do
		if [[ "$iter" == "$ELEMENT" ]]; then
			return "$TRUE"
		fi	
	done
	
	return "$FALSE"
}
######## asserts.sh ###########################################################################################################################
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
######## sh_unit_g_vars.sh ####################################################################################################################
define_sh_unit_global_variables() {
	if [[ -z "$SH_UNIT_GLOBAL_VARS_ALREADY_DEFINED" || "$SH_UNIT_GLOBAL_VARS_ALREADY_DEFINED" == "$FALSE" ]]; then
	
		export TEST_FUNCTION_PREFIX="test_"
		export TEST_FILENAME_SUFIX="_test.sh"
		
		export STATUS_SUCCESS="$TRUE"
		export STATUS_ERROR="$FALSE"
		
		reset_g_test_execution_status
		
		reset_g_test_counters
		
		export SH_UNIT_GLOBAL_VARS_ALREADY_DEFINED="$TRUE"
	fi
}
reset_g_test_execution_status() {
	export TEST_EXECUTION_STATUS="$STATUS_SUCCESS"
	export LAST_TESTCASE_EXECUTION_STATUS="$STATUS_SUCCESS"
}
reset_g_test_counters() {
	export TESTCASE_TOTAL_COUNT=0
	export TESTCASE_FAIL_COUNT=0
	export TESTCASE_SUCCESS_COUNT=0
	
	export ASSERTIONS_TOTAL_COUNT=0
	export ASSERTIONS_FAIL_COUNT=0
	export ASSERTIONS_SUCCESS_COUNT=0
	
	reset_testcase_counters
}
reset_testcase_counters() {
	export TESTCASE_ASSERTIONS_TOTAL_COUNT=0
	export TESTCASE_ASSERTIONS_FAIL_COUNT=0
	export TESTCASE_ASSERTIONS_SUCCESS_COUNT=0
}
define_sh_unit_global_variables
######## test_runner.sh #######################################################################################################################
display_statistics() {
	echo ""
	echo "(*) ASSERTIONS executed in $SCRIPT_NAME_TO_RUN_TESTS: "
	echo "    - Total:   $ASSERTIONS_TOTAL_COUNT"
	echo "    - Success: $ASSERTIONS_SUCCESS_COUNT"
	echo "    - Fail:    $ASSERTIONS_FAIL_COUNT"
	echo ""
	echo "(*) TEST CASES executed in $SCRIPT_NAME_TO_RUN_TESTS: "
	echo "    - Total:   $TESTCASE_TOTAL_COUNT"
	echo "    - Success: $TESTCASE_SUCCESS_COUNT"
	echo "    - Fail:    $TESTCASE_FAIL_COUNT"
	echo ""
}
display_final_result() {
	echo "(*) FINAL RESULT of execution:"	
	if [[ "$TEST_EXECUTION_STATUS" != "$STATUS_SUCCESS" ]]; then 
		echo -e "      ${ECHO_COLOR_RED}FAIL!!!${ECHO_COLOR_NC}"
	else		
		echo -e "      ${ECHO_COLOR_GREEN}OK${ECHO_COLOR_NC}"
	fi
	echo ""
}
display_finish_execution() {
	echo ""
	echo "-------------------------------------------------------------"
	echo "Finish execution"
}
display_testcase_execution_statistics() {
	echo "  Assertions executed in $FUNCTION_NAME: "
	echo "   - Success: $TESTCASE_ASSERTIONS_SUCCESS_COUNT"
	echo "   - Fail:    $TESTCASE_ASSERTIONS_FAIL_COUNT"
	echo "   - Total:   $TESTCASE_ASSERTIONS_TOTAL_COUNT"
}
display_finish_execution_of_files() {
  	echo -e "\n########################################################################################################"
	echo -e "\nFinish execution of files\n"
}
update_testcase_counters() {
	if [[ "$LAST_TESTCASE_EXECUTION_STATUS" == "$STATUS_OK" ]]; then
		export TESTCASE_SUCCESS_COUNT=$((TESTCASE_SUCCESS_COUNT+1))
	else
		export TESTCASE_FAIL_COUNT=$((TESTCASE_FAIL_COUNT+1))
	fi
	
	export TESTCASE_TOTAL_COUNT=$((TESTCASE_TOTAL_COUNT+1))
}
display_testcase_execution_start() {
	local FUNCTION_NAME
	
	FUNCTION_NAME="$1"
	
	echo ""
	echo "---[ $FUNCTION_NAME ]----------------------------------------------------------"
	echo ""
}
display_test_file_delimiter() {
	echo -e "\n########################### $( basename "$1" ) ######################################################\n"
}
display_file_execution_start() {
	display_test_file_delimiter $1
	echo "Location: $1"
    echo "Start execution of test case(s)  ..."
}
get_all_function_names_from_file() {
	local SCRIPT_NAME_TO_RUN_TESTS
	
	SCRIPT_NAME_TO_RUN_TESTS="$1"
	
	grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$SCRIPT_NAME_TO_RUN_TESTS" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//'
}
get_all_test_function_names_from_file() {
	local SCRIPT_NAME_TO_RUN_TESTS
	
	SCRIPT_NAME_TO_RUN_TESTS="$1"
	
	grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$SCRIPT_NAME_TO_RUN_TESTS" | grep -E '^test_*' | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//'
}
run_testcases_in_files() {
	local -n P_ALL_TEST_FILES
  	local -n P_TEST_FILTERS
  	
  	local FUNCTIONS_TO_RUN
  	local FILE
	
	P_ALL_TEST_FILES="$1"
  	P_TEST_FILTERS="$2"
  	
  	# Run WITH filters
  	if (( "${#P_TEST_FILTERS[@]}" > 0 )); then
	  	for test_filter in ${P_TEST_FILTERS[@]}; do
	  		if [[ "$test_filter" == *"="* ]]; then
	  			FILE=${test_filter%=*}
				FUNCTIONS_TO_RUN_STR=${test_filter#*=}
				
				if [[ ! -z "$FUNCTIONS_TO_RUN_STR" ]]; then
					if [[ "$FUNCTIONS_TO_RUN_STR" == *","* ]]; then
						IFS=',' read -r -a FUNCTIONS_TO_RUN <<< "$FUNCTIONS_TO_RUN_STR"
					else
						FUNCTIONS_TO_RUN=( "$FUNCTIONS_TO_RUN_STR" ) 	
					fi
				fi
			else
				FILE=${test_filter}				
				FUNCTIONS_TO_RUN=( )
	  		fi
	  		
			for file in "${P_ALL_TEST_FILES[@]}"; do
				if [[ $( basename "$file" ) == "$FILE" ]]; then
					run_testcases_in_file "$file" FUNCTIONS_TO_RUN					
				fi
			done
	  	done
  	# Run WITHOUT filters	  	
	else
		FUNCTIONS_TO_RUN=( $( get_all_test_function_names_from_file ) )
		if (( "${#P_ALL_TEST_FILES[@]}" > 0 )); then
			for file in "${P_ALL_TEST_FILES[@]}"
			do
				run_testcases_in_file "$file" FUNCTIONS_TO_RUN
			done
		else
			echo "No test files found!"
		fi
  	fi
  	
	display_finish_execution_of_files
}
run_testcases_in_file() {
	local SCRIPT_NAME_TO_RUN_TESTS
	local -n P_FUNCTIONS_TO_RUN
	
	SCRIPT_NAME_TO_RUN_TESTS="$1"
	P_FUNCTIONS_TO_RUN="$2"
	
    display_file_execution_start "$SCRIPT_NAME_TO_RUN_TESTS"
     
	source "$SCRIPT_NAME_TO_RUN_TESTS"
    TEST_FUNCTIONS_IN_FILE=( $( get_all_test_function_names_from_file "$SCRIPT_NAME_TO_RUN_TESTS" ) );    
	
	for FUNCTION_NAME in "${TEST_FUNCTIONS_IN_FILE[@]}"
	do
		if (( ${#P_FUNCTIONS_TO_RUN[@]} > 0 )); then
		 	if ( array_contain_element P_FUNCTIONS_TO_RUN "$FUNCTION_NAME" ); then		 			
				run_test_case "$FUNCTION_NAME"
			fi
		else
			run_test_case "$FUNCTION_NAME"
		fi
	done
	
	display_finish_execution
	
	display_statistics
	
	display_final_result
	
	if [[ "$TEST_EXECUTION_STATUS" == "$STATUS_OK" ]]; then
		return "$TRUE";
	else		
		return "$FALSE";
	fi
}
run_test_case() {
	local TESTCASE_NAME
	
	TESTCASE_NAME="$1"
	display_testcase_execution_start "$TESTCASE_NAME"
			
	LAST_TESTCASE_EXECUTION_STATUS="$STATUS_OK"
	
	reset_testcase_counters
	
	$TESTCASE_NAME # this line call/execute a test function!
	
	display_testcase_execution_statistics
	
	update_testcase_counters
}
#### shpm_package_manager.sh #######################################################################################
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# SOURCES 
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#### shpm_log_utils.sh #############################################################################################
export SHPM_LOG_DISABLED="$FALSE"
export G_SHPMLOG_TAB="  "
export G_SHPMLOG_INDENT=""
increase_g_indent() {
	G_SHPMLOG_INDENT="$G_SHPMLOG_INDENT""$G_SHPMLOG_TAB"
}
decrease_g_indent() {
	local END_POS
	END_POS=$( echo "${#G_SHPMLOG_INDENT} - ${#G_SHPMLOG_TAB}" | bc )
	G_SHPMLOG_INDENT="${G_SHPMLOG_INDENT:0:$END_POS}"
}
reset_g_indent() {
	G_SHPMLOG_INDENT=""
}
set_g_indent() {
	G_SHPMLOG_INDENT="$1"
}
shpm_log() {
	local MSG=$1
	local COLOR=$2
	
    if [[ "$SHPM_LOG_DISABLED" != "$TRUE" ]]; then
		if [[ "$COLOR" == "red" ]]; then
			echo -e "${G_SHPMLOG_INDENT}${ECHO_COLOR_RED}$MSG${ECHO_COLOR_NC}"			
		elif [[ "$COLOR" == "green" ]]; then
			echo -e "${G_SHPMLOG_INDENT}${ECHO_COLOR_GREEN}$MSG${ECHO_COLOR_NC}"		
		elif [[ "$COLOR" == "yellow" ]]; then
			echo -e "${G_SHPMLOG_INDENT}${ECHO_COLOR_YELLOW}$MSG${ECHO_COLOR_NC}"	
		else
			echo -e "${G_SHPMLOG_INDENT}$MSG"
		fi
	fi
}
shpm_log_operation() {
    shpm_log "================================================================"
	shpm_log "sh-pm: $1"
	shpm_log "================================================================"
}
#### shpm_testcases_runner.sh ######################################################################################
run_testcases() {
	shpm_log_operation "Searching unit test files to run ..."
	
	if [[ -d "$TEST_DIR_PATH" ]]; then
	
		local ALL_TEST_FILES
		ALL_TEST_FILES=( $(ls "$TEST_DIR_PATH"/*_test.sh 2> /dev/null) );
		
		local TEST_FUNCTIONS 
		TEST_FILTERS=( "$@" )
		
		shpm_log "Found ${#ALL_TEST_FILES[@]} test file(s)" 
		shpm_log "\nStart execution of files ...\n"
		
		run_testcases_in_files ALL_TEST_FILES TEST_FILTERS
	
	else 
		shpm_log "Nothing to test"
	fi
	
	shpm_log "Done"
}
#### shpm_shellcheck.sh ############################################################################################
run_shellcheck() {
    local SHELLCHECK_CMD
    local SHELLCHECK_LOG_FILENAME
    local GEDIT_CMD
    
    SHELLCHECK_CMD=$(which shellcheck)
    SHELLCHECK_LOG_FILENAME="shellcheck.log"
    
    GEDIT_CMD=$(which gedit)
	shpm_log_operation "Running ShellCheck in .sh files ..."
    
    if [[ "$SKIP_SHELLCHECK" == "true" ]]; then
    	shpm_log ""
    	shpm_log "WARNING: Skipping ShellCheck verification !!!"
    	shpm_log ""
    	return "$TRUE" # continue execution with warning    	
    fi
    
    if [[ ! -z "$SHELLCHECK_CMD" ]]; then
	    
	    create_path_if_not_exists "$TARGET_DIR_PATH"
	    
	    for FILE_TO_CHECK in $SRC_DIR_PATH/*.sh; do        
	    
	    	if "$SHELLCHECK_CMD" -x -e SC1090 -e SC1091 "$FILE_TO_CHECK" > "$TARGET_DIR_PATH/$SHELLCHECK_LOG_FILENAME"; then	    	
	    		shpm_log "$FILE_TO_CHECK passed in shellcheck" "green"
	    	else
	    		shpm_log "FAIL!" "red"
	    		shpm_log "$FILE_TO_CHECK have shellcheck errors." "red"
	    		shpm_log "See log in $TARGET_DIR_PATH/$SHELLCHECK_LOG_FILENAME" "red"
	    		
	    		sed -i '1s/^/=== ERRORS FOUND BY ShellCheck tool: === /' "$TARGET_DIR_PATH/$SHELLCHECK_LOG_FILENAME"
	    		
	    		if [[ "$GEDIT_CMD" != "" ]]; then
	    			shpm_log "Open $TARGET_DIR_PATH/$SHELLCHECK_LOG_FILENAME ..."
	    			"$GEDIT_CMD" "$TARGET_DIR_PATH/$SHELLCHECK_LOG_FILENAME"
	    		fi
	    		
	    		exit 1
	    	fi
    	done;
    else
    	shpm_log "WARNING: ShellCheck not found: skipping ShellCheck verification !!!" "yellow"
    fi
    
    shpm_log ""
    shpm_log "ShellCheck finish."
    shpm_log ""
}
#### shpm_compiler.sh ##############################################################################################
get_entry_point_file() {
	
	if [[ -z "$MANIFEST_P_ENTRY_POINT_FILE" ]]; then
		return "$FALSE"
	fi
	
	if [[ -z "$MANIFEST_FILE_PATH" ]]; then
		return "$FALSE"
	fi
	
	echo $( grep "$MANIFEST_P_ENTRY_POINT_FILE" "$MANIFEST_FILE_PATH" | cut -d '=' -f 2 )
	
	return "$TRUE"
}
get_compiled_filename() {
	echo "$( basename "$ROOT_DIR_PATH" )"".sh"
}
array_contain_element() {
	local -n P_ARRAY="$1"
	local ELEMENT="$2"
	
	for iter in ${P_ARRAY[@]}; do
		if [[ "$iter" == "$ELEMENT" ]]; then
			return "$TRUE"
		fi	
	done
	
	return "$FALSE"
}
display_file_entrypoint_error_message() {
	shpm_log ""
	shpm_log "ERROR: Inform \"$MANIFEST_P_ENTRY_POINT_FILE\" propertie value in file: $MANIFEST_FILE_PATH!" "red"
	shpm_log ""
	shpm_log "Exemple content of $MANIFEST_FILENAME file:"
	shpm_log ""
	shpm_log "$MANIFEST_P_ENTRY_POINT_FILE""=""foo.sh"
	shpm_log "$MANIFEST_P_ENTRY_POINT_FUNCTION""=""main"
	shpm_log ""
}
right_pad_string() {
	printf %-"$2"s "$1" | tr ' ' "$3"
}
left_pad_string() {
	printf %"$2"s "$1" | tr ' ' "$3"
}
get_file_separator_delimiter_line() {
	echo -e $( right_pad_string "" 133 "#" )
}
ensure_newline_at_end_of_files() {
	local FOLDER_PATH
	FOLDER_PATH="$1"
	
	find "$FOLDER_PATH"  -type f ! -name "$DEPENDENCIES_FILENAME" ! -name 'sh-pm*' -name '*.sh' -exec sed -i -e '$a\' {} \;
}
ensure_newline_at_end_of_lib_files() {
	shpm_log "- Ensure \\\n in end of lib files to prevent file concatenation errors ..."
	ensure_newline_at_end_of_files "$LIB_DIR_PATH"
}
remove_problematic_lines_of_concat_lib_file() {
	shpm_log "- Remove problematic lines in all .sh lib files ..."
	grep -v "$PATTERN_INCLUDE_BOOTSTRAP_FILE" < "$FILE_WITH_CAT_SH_LIBS""_tmp" | grep -v "$SHEBANG_FIRST_LINE" | grep -v "$INCLUDE_LIB_AND_FILE" > "$FILE_WITH_CAT_SH_LIBS"
}
prepare_libraries() {
	shpm_log "- Prepare libraries:"
	
   	increase_g_indent
   	   	
   	ensure_newline_at_end_of_lib_files
   		                     
	concat_all_lib_files
	
	remove_problematic_lines_of_concat_lib_file
		
	remove_file_if_exists "$FILE_WITH_CAT_SH_LIBS""_tmp"
		
   	decrease_g_indent
}
display_running_compiler_msg() {	
	shpm_log "\nRunning compile pipeline:\n"
}
concat_all_lib_files() {
	shpm_log "- Concat all .sh lib files that will be used in compile ..."
			
	local LIB_FILES=$( find "$LIB_DIR_PATH"  -type f ! -name "$DEPENDENCIES_FILENAME" ! -name 'sh-pm*' -name '*.sh' )
	
	local FILENAME
	
	update_section_separator "LIBRARIES"	
	cat "$FILE_WITH_SEPARATOR" >> "$FILE_WITH_CAT_SH_LIBS""_tmp"
	
	for file in ${LIB_FILES[@]}; do
	
		update_file_separator "$file"
		
		cat "$FILE_WITH_SEPARATOR" "$file" >> "$FILE_WITH_CAT_SH_LIBS""_tmp"
	done
}
update_section_separator() {
	local STR_AUX="$1"
	
	local FILECONTENT_SEP=$( right_pad_string "#" 140 ">" )
	
	echo -e "\n\n$FILECONTENT_SEP\n# $STR_AUX \n$FILECONTENT_SEP\n\n" > "$FILE_WITH_SEPARATOR"
}
create_file_separator() {
	local file="$1"
	local PATH_TO_FILE_CONTAINING_SEPARATOR="$2"
	FILENAME_AUX=$( basename "$file" )
			
	FILECONTENT_SEP=$( right_pad_string "" 110 "#" )
	 		
	echo "#### $FILENAME_AUX ${FILECONTENT_SEP:0:-${#FILENAME_AUX}}" > "$PATH_TO_FILE_CONTAINING_SEPARATOR"
}
update_file_separator() {
	local file="$1"
	FILENAME_AUX=$( basename "$file" )
			
	FILECONTENT_SEP=$( right_pad_string "" 110 "#" )
	 		
	echo "#### $FILENAME_AUX ${FILECONTENT_SEP:0:-${#FILENAME_AUX}}" > "$FILE_WITH_SEPARATOR"
}
concat_all_src_files(){
	shpm_log "- Concat all .sh src files that will be used in compile except entrypoint file ..."
		
	local SRC_FILES=$( find "$SRC_DIR_PATH"  -type f ! -path "sh-pm*" ! -name "pom.sh" -name '*.sh' )
	local FILE_ENTRYPOINT_PATH=""
	
	update_section_separator "SOURCES"	
	
	cat "$FILE_WITH_SEPARATOR" >> "$FILE_WITH_CAT_SH_SRCS""_tmp"
	
	for file in ${SRC_FILES[@]}; do
		if [[ "$FILE_ENTRY_POINT" != "$( basename "$file" )" ]]; then
			update_file_separator "$file"
			cat "$FILE_WITH_SEPARATOR" "$file" >> "$FILE_WITH_CAT_SH_SRCS""_tmp"
		fi 		
	done
}
get_fileentrypoint_path(){
	local SRC_FILES=$( find "$SRC_DIR_PATH"  -type f ! -path "sh-pm*" ! -name "pom.sh" -name '*.sh' )
	
	for file in ${SRC_FILES[@]}; do
		if [[ "$FILE_ENTRY_POINT" == "$( basename "$file" )" ]]; then
			echo "$file"
		fi	
	done
}
remove_problematic_lines_of_src_concat_file() {
	shpm_log "- Remove problematic lines in all .sh src files ..."
	grep -v "$PATTERN_INCLUDE_BOOTSTRAP_FILE" < "$FILE_WITH_CAT_SH_SRCS""_tmp" | grep -v "$SHEBANG_FIRST_LINE" | grep -v "$INCLUDE_LIB_AND_FILE" > "$FILE_WITH_CAT_SH_SRCS"
	remove_file_if_exists "$FILE_WITH_CAT_SH_SRCS""_tmp"
}
remove_problematic_lines_of_entryfile() {
	HANDLED_FILE_ENTRYPOINT_PATH=$( get_handled_fileentrypoint_path )
	shpm_log "- Remove problematic lines in $HANDLED_FILE_ENTRYPOINT_PATH files ..."
	
	cp "$HANDLED_FILE_ENTRYPOINT_PATH" "$HANDLED_FILE_ENTRYPOINT_PATH""_tmp"
	
	grep -v "$PATTERN_INCLUDE_BOOTSTRAP_FILE" < "$HANDLED_FILE_ENTRYPOINT_PATH""_tmp" | grep -v "$SHEBANG_FIRST_LINE" | grep -v "$INCLUDE_LIB_AND_FILE" > "$HANDLED_FILE_ENTRYPOINT_PATH"	
}
prepare_source_code() {
   	shpm_log "- Prepare source code:"
   	increase_g_indent
   	
 	ensure_newline_at_end_of_src_files
	
	concat_all_src_files
	
	remove_problematic_lines_of_src_concat_file
	shpm_log "- Remove problematic lines in $ROOT_DIR_PATH/$BOOTSTRAP_FILENAME file ..."
	grep -v "$SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE" < "$ROOT_DIR_PATH/$BOOTSTRAP_FILENAME" | grep -v "$SHEBANG_FIRST_LINE" > "$FILE_WITH_BOOTSTRAP_SANITIZED"  
   	decrease_g_indent
}
prepare_dep_file() {
	ensure_newline_at_end_of_dep_file
	local DEP_FILE_PATH="$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME";
	create_file_separator "$DEP_FILE_PATH" "$FILE_WITH_SEPARATOR""_dep"
}
prepare_bootstrap_file() {
	ensure_newline_at_end_of_bootstrap_file
	local BOOTSTRAP_FILE_PATH="$ROOT_DIR_PATH/$BOOTSTRAP_FILENAME";
	create_file_separator "$BOOTSTRAP_FILE_PATH" "$FILE_WITH_SEPARATOR""_bootstrap"
}
get_handled_fileentrypoint_path() {
	local FILE_ENTRY_POINT_PATH="$1"
	echo "$TMP_COMPILE_WORKDIR/$(basename $FILE_ENTRYPOINT_PATH)"
}
prepare_fileentrypoint(){
	local FILE_ENTRY_POINT_PATH="$1"
	create_file_separator "$FILE_ENTRYPOINT_PATH" "$FILE_WITH_SEPARATOR""_entrypoint"
	
	reset_tmp_compilation_dir "$TMP_COMPILE_WORKDIR"
	
	HANDLED_FILE_ENTRYPOINT_PATH=$( get_handled_fileentrypoint_path "$FILE_ENTRY_POINT_PATH" )
	
	cp "$FILE_ENTRYPOINT_PATH" "$HANDLED_FILE_ENTRYPOINT_PATH"
	
	ensure_newline_at_end_of_file "HANDLED_FILE_ENTRYPOINT_PATH"
	
	remove_problematic_lines_of_entryfile
}
ensure_newline_at_end_of_src_files() {
  	shpm_log "- Ensure \\\n in end of src files to prevent file concatenation errors ..."
	find "$SRC_DIR_PATH"  -type f ! -path "sh-pm*" ! -name "$DEPENDENCIES_FILENAME" -name '*.sh' -exec sed -i -e '$a\' {} \;
}
ensure_newline_at_end_of_dep_file() {
  	shpm_log "- Ensure \\\n in end of src files to prevent file concatenation errors ..."
	find "$ROOT_DIR_PATH"  -type f ! -path "sh-pm*" -name "$DEPENDENCIES_FILENAME" -exec sed -i -e '$a\' {} \;
}
ensure_newline_at_end_of_bootstrap_file() {
  	shpm_log "- Ensure \\\n in end of src files to prevent file concatenation errors ..."
	find "$ROOT_DIR_PATH"  -type f ! -path "sh-pm*" -name "$BOOTSTRAP_FILENAME" -exec sed -i -e '$a\' {} \;
}
ensure_newline_at_end_of_file() {
	local P_FILEPATH="$1"
  	shpm_log "- Ensure \\\n in end of $( basename $P_FILEPATH ) file to prevent file concatenation errors ..."
	sed -i -e '$a\' $P_FILEPATH
}
get_tmp_compilation_dir() {
	echo "$TMP_DIR_PATH/compilation_$(date '+%s')"
}
reset_tmp_compilation_dir() {
	local TMP_COMPILE_WORKDIR="$1"
	
	remove_folder_if_exists "$TMP_COMPILE_WORKDIR"
	create_path_if_not_exists "$TMP_COMPILE_WORKDIR"
}
run_compile_app() {
	
	shpm_log_operation "Compile Application"
		
	if [[ ! -f "$MANIFEST_FILE_PATH" ]]; then
		shpm_log "\nERROR: $MANIFEST_FILE_PATH not found!\n" "red"
		return $FALSE
	fi
	
	local FILE_ENTRY_POINT
	local FILE_ENTRYPOINT_PATH
	
	local TMP_COMPILE_WORKDIR
	
	local FILE_WITH_CAT_SH_LIBS
	local FILE_WITH_CAT_SH_SRCS
	local FILE_WITH_SEPARATOR
	local FILE_WITH_BOOTSTRAP_SANITIZED
	local COMPILED_FILE_NAME
	local COMPILED_FILE_PATH
	
	local INCLUDE_LIB_AND_FILE
	local SHEBANG_FIRST_LINE
	local PATTERN_INCLUDE_BOOTSTRAP_FILE_1
	local PATTERN_INCLUDE_BOOTSTRAP_FILE_2
	local PATTERN_INCLUDE_BOOTSTRAP_FILE
	
	local SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_1
	local SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_2
	local SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE
	
	local FILE_SEPARATOR
	
	FILE_ENTRY_POINT="$( get_entry_point_file )"
	FILE_ENTRYPOINT_PATH="$( get_fileentrypoint_path )"
	
	TMP_COMPILE_WORKDIR=$( get_tmp_compilation_dir ) 
	
	reset_tmp_compilation_dir "$TMP_COMPILE_WORKDIR"	
	
	if [[ -z "$FILE_ENTRY_POINT" ]]; then
		display_file_entrypoint_error_message
		return $FALSE
	fi
	
	FILE_WITH_CAT_SH_LIBS="$TMP_DIR_PATH/lib_files_concat"
	FILE_WITH_CAT_SH_SRCS="$TMP_DIR_PATH/sh_files_concat"
	FILE_WITH_SEPARATOR="$TMP_DIR_PATH/separator"
	FILE_WITH_BOOTSTRAP_SANITIZED="$TMP_DIR_PATH/$BOOTSTRAP_FILENAME"
	
   	create_path_if_not_exists "$TARGET_DIR_PATH"
   
   	COMPILED_FILE_NAME=$( get_compiled_filename ) 
	
	COMPILED_FILE_PATH="$TARGET_DIR_PATH/$COMPILED_FILE_NAME"
	
	
	PATTERN_INCLUDE_BOOTSTRAP_FILE_1="source ./$BOOTSTRAP_FILENAME"
	PATTERN_INCLUDE_BOOTSTRAP_FILE_2="source ../../../$BOOTSTRAP_FILENAME"
	PATTERN_INCLUDE_BOOTSTRAP_FILE="$PATTERN_INCLUDE_BOOTSTRAP_FILE_1\|$PATTERN_INCLUDE_BOOTSTRAP_FILE_2"
	
	SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_1='source "$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME"'
	SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_2='source "$ROOT_DIR_PATH/'$DEPENDENCIES_FILENAME'"'
	SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE="$SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_1\|$SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_2"
	
	FILE_SEPARATOR=$( get_file_separator_delimiter_line );	
	
	display_running_compiler_msg
   	prepare_libraries
	prepare_source_code
	prepare_dep_file
	
	prepare_bootstrap_file
		
	prepare_fileentrypoint "$FILE_ENTRY_POINT_PATH"
	HANDLED_FILE_ENTRYPOINT_PATH=$( get_handled_fileentrypoint_path "$FILE_ENTRY_POINT_PATH" )
	shpm_log "- Generate compiled file ..."
	
	remove_file_if_exists "$COMPILED_FILE_PATH"
	
	cat \
		"$FILE_WITH_SEPARATOR""_dep" "$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME"  \
		"$FILE_WITH_SEPARATOR""_bootstrap" "$FILE_WITH_BOOTSTRAP_SANITIZED" \
		"$FILE_WITH_SEPARATOR" "$FILE_WITH_CAT_SH_LIBS" \
		"$FILE_WITH_SEPARATOR" "$FILE_WITH_CAT_SH_SRCS" \
		"$FILE_WITH_SEPARATOR""_entrypoint" "$HANDLED_FILE_ENTRYPOINT_PATH" \
			> "$COMPILED_FILE_PATH"
	
	shpm_log "- Remove extra lines ..."
	sed -i '/^$/d' "$COMPILED_FILE_PATH"
	
	shpm_log "- Remove tmp files ..."
	increase_g_indent
	#remove_file_if_exists "$FILE_WITH_CAT_SH_LIBS"
	#remove_file_if_exists "$FILE_WITH_CAT_SH_SRCS"
	#remove_file_if_exists "$FILE_WITH_BOOTSTRAP_SANITIZED"
	decrease_g_indent
	
	shpm_log "- Grant permissions in compiled file ..."
	chmod 755 "$COMPILED_FILE_PATH"
   	shpm_log ""	
	shpm_log "Compile pipeline finish."
   	shpm_log ""
	shpm_log "Compile successfull! File generated in:" "green"
	shpm_log "  |$COMPILED_FILE_PATH|"
	shpm_log ""
}
run_compile_lib() {
	
	shpm_log_operation "Compile Library"
	
	local FILE_WITH_CAT_SH_SRCS
	local FILE_WITH_SEPARATOR
	local COMPILED_FILE_NAME
	local COMPILED_FILE_PATH
	
	local INCLUDE_LIB_AND_FILE
	local SHEBANG_FIRST_LINE
	local PATTERN_INCLUDE_BOOTSTRAP_FILE_1
	local PATTERN_INCLUDE_BOOTSTRAP_FILE_2
	local PATTERN_INCLUDE_BOOTSTRAP_FILE
	
	local FILE_SEPARATOR
	
	FILE_WITH_CAT_SH_SRCS="$TMP_DIR_PATH/sh_files_concat"
	FILE_WITH_SEPARATOR="$TMP_DIR_PATH/separator"
	FILE_WITH_BOOTSTRAP_SANITIZED="$TMP_DIR_PATH/$BOOTSTRAP_FILENAME"
	
   	create_path_if_not_exists "$TARGET_DIR_PATH"
   
   	COMPILED_FILE_NAME=$( get_compiled_filename ) 
	
	COMPILED_FILE_PATH="$TARGET_DIR_PATH/$COMPILED_FILE_NAME"
	
	
	PATTERN_INCLUDE_BOOTSTRAP_FILE_1="source ./$BOOTSTRAP_FILENAME"
	PATTERN_INCLUDE_BOOTSTRAP_FILE_2="source ../../../$BOOTSTRAP_FILENAME"
	PATTERN_INCLUDE_BOOTSTRAP_FILE="$PATTERN_INCLUDE_BOOTSTRAP_FILE_1\|$PATTERN_INCLUDE_BOOTSTRAP_FILE_2"
	
	SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_1='source "$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME"'
	SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_2='source "$ROOT_DIR_PATH/'$DEPENDENCIES_FILENAME'"'
	SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE="$SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_1\|$SOURCE_DEPSFILE_CMD_IN_BOOTSTRAP_FILE_2"
	
	FILE_SEPARATOR=$( get_file_separator_delimiter_line );	
	
	display_running_compiler_msg
	prepare_source_code
	remove_file_if_exists "$COMPILED_FILE_PATH"
	
	shpm_log "- Generate compiled file ..."
	
	cat "$FILE_WITH_CAT_SH_SRCS" > "$COMPILED_FILE_PATH"
	
	shpm_log "- Remove extra lines ..."
	sed -i '/^$/d' "$COMPILED_FILE_PATH"
	
	shpm_log "- Remove tmp files ..."
	increase_g_indent
	remove_file_if_exists "$FILE_WITH_CAT_SH_SRCS"
	
	decrease_g_indent
	
	shpm_log "- Grant permissions in compiled file ..."
   	shpm_log ""	
	shpm_log "Compile pipeline finish."
   	shpm_log ""
	shpm_log "Compile successfull! File generated in:" "green"
	shpm_log "  |$COMPILED_FILE_PATH|"
	shpm_log ""
}
#### shpm_coverage.sh ##############################################################################################
run_coverage_analysis() {
	local PERCENT
	local COVERAGE_STR_LOG
	
	shpm_log_operation "Test coverage analysis"
	
	PERCENT=$(do_coverage_analysis)
	
	NOT_HAVE_MINIMUM_COVERAGE=$(echo "${PERCENT} < ${MIN_PERCENT_TEST_COVERAGE}"  | bc -l)
	
	COVERAGE_STR_LOG="$PERCENT%. Minimum is $MIN_PERCENT_TEST_COVERAGE% (Value configured in $BOOTSTRAP_FILENAME)"
	
	if (( "$NOT_HAVE_MINIMUM_COVERAGE" )); then
		
		do_coverage_analysis "-v"
		
		shpm_log ""
		shpm_log "Test Coverage FAIL! $COVERAGE_STR_LOG" "red"
	else
	    shpm_log "Test Coverage OK: $COVERAGE_STR_LOG" "green"
	fi
	
	shpm_log ""
}
do_coverage_analysis() {
	VERBOSE="$1"
	local TOTAL_FILES_ANALYSED_COUNT	
	local TOTAL_FUNCTIONS_FOUNDED_COUNT
	local TOTAL_FUNCTIONS_WITH_TEST_COUNT
	local TOTAL_COVERAGE
	local FILE_FUNCTIONS_COUNT
	local FILE_FUNCTIONS_WITH_TEST_COUNT
	local FILES_ANALYSIS_LOG_SEPARATOR
	TOTAL_FILES_ANALYSED_COUNT=0
	TOTAL_FUNCTIONS_FOUNDED_COUNT=0
	TOTAL_FUNCTIONS_WITH_TEST_COUNT=0
	TOTAL_COVERAGE=0
	FILE_FUNCTIONS_COUNT=0
	FILE_FUNCTIONS_WITH_TEST_COUNT=0
	
	FILES_ANALYSIS_LOG_SEPARATOR="\n----------------------------------------------------------------\n"
	
	if [[ "$VERBOSE" != "-v"  ]]; then
		SHPM_LOG_DISABLED="$TRUE"
	fi
	
	shpm_log ""
	shpm_log "Find src file/functions in SRC_DIR_PATH and respective tests file/functions in TEST_DIR_PATH:"
	shpm_log "  * SRC_DIR_PATH: $SRC_DIR_PATH"
	shpm_log "  * TEST_DIR_PATH: $TEST_DIR_PATH"
	shpm_log ""
	shpm_log "Start test coverage analysis ..."
	shpm_log ""
	
	
	while IFS=  read -r -d $'\0'; do
    	SH_FILES_FOUNDED+=("$REPLY")
	done < <(find "$SRC_DIR_PATH" -name "*.sh" -print0)
	
	TOTAL_FILES_ANALYSED_COUNT="${#SH_FILES_FOUNDED[@]}"
	
	shpm_log "$FILES_ANALYSIS_LOG_SEPARATOR"
	
	for i in "${!SH_FILES_FOUNDED[@]}"; do 
	
	    filepath="${SH_FILES_FOUNDED[$i]}"
	     
		FILE_FUNCTIONS_COUNT=0
		FILE_FUNCTIONS_WITH_TEST_COUNT=0
		 
		increase_g_indent 
		filename="$( basename "$filepath" )"
		
		FUNCTIONS_TO_TEST=( $(grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$filepath" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//') );
		FILE_FUNCTIONS_COUNT="${#FUNCTIONS_TO_TEST[@]}"
		TOTAL_FUNCTIONS_FOUNDED_COUNT=$(( TOTAL_FUNCTIONS_FOUNDED_COUNT + FILE_FUNCTIONS_COUNT )) 
		
		test_filename="${filename//.sh/}_test.sh"
		test_filepath="$TEST_DIR_PATH/$test_filename"
		 
		shpm_log "FILE: $filename - Analysis Start"
		
		shpm_log " - Location: $filepath"
		if [[ -f "$test_filepath" ]]; then
	
			shpm_log " - TestedBy: $test_filepath" 
			EXISTING_TEST_FUNCTIONS=( $(grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$test_filepath" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//') );
			
			shpm_log " - Function's coverage analysis:"
			
			increase_g_indent 
			increase_g_indent
			increase_g_indent
			
			FILE_FUNCTIONS_WITH_TEST_COUNT=0
			
			for function_name in "${FUNCTIONS_TO_TEST[@]}"; do
				
				foundtest=$FALSE
				for test_function in "${EXISTING_TEST_FUNCTIONS[@]}"; do
					if [[ "$test_function" =~ "test_""$function_name".* ]]; then
						foundtest=$TRUE
						break;
					fi
				done;
				
				if [[ "$foundtest" == "$FALSE" ]]; then
				   shpm_log "$function_name ... NO TEST FOUND!" "red"
				else
					FILE_FUNCTIONS_WITH_TEST_COUNT=$((FILE_FUNCTIONS_WITH_TEST_COUNT + 1))
				   shpm_log "$function_name ... OK, test found." "green"
				fi
				
			done
			
			TOTAL_FUNCTIONS_WITH_TEST_COUNT=$(( TOTAL_FUNCTIONS_WITH_TEST_COUNT + FILE_FUNCTIONS_WITH_TEST_COUNT ))
			
			decrease_g_indent 
			decrease_g_indent
			decrease_g_indent
			
		else		
			shpm_log " - TestedBy: NO FILE TEST FOUND!" "red"
			
			increase_g_indent 
			increase_g_indent
			increase_g_indent
			
			for function_name in "${FUNCTIONS_TO_TEST[@]}"; do
				shpm_log "$function_name ... NO TEST FOUND!" "red"
			done
			
			decrease_g_indent 
			decrease_g_indent
			decrease_g_indent
		fi
		
		if [ "$FILE_FUNCTIONS_COUNT" -gt 0 ]; then 
			PERCENT_COVERAGE=$(bc <<< "scale=2; $FILE_FUNCTIONS_WITH_TEST_COUNT / $FILE_FUNCTIONS_COUNT * 100")
		else
			PERCENT_COVERAGE=0
		fi
		
		shpm_log ""
		shpm_log "Found $FILE_FUNCTIONS_COUNT function(s) in $filename. $FILE_FUNCTIONS_WITH_TEST_COUNT function(s) have tests."
		shpm_log "Coverage in $filename: $PERCENT_COVERAGE"
		shpm_log "FILE: $filename - Analysis End"
	
		decrease_g_indent
		
		shpm_log "$FILES_ANALYSIS_LOG_SEPARATOR"
	done
	
	if [ $TOTAL_FUNCTIONS_WITH_TEST_COUNT -gt 0 ]; then 
		TOTAL_COVERAGE=$(bc <<< "scale=2; $TOTAL_FUNCTIONS_WITH_TEST_COUNT / $TOTAL_FUNCTIONS_FOUNDED_COUNT * 100")
	else
		TOTAL_COVERAGE=0
	fi
	
	shpm_log ""
	shpm_log "Finish test coverage analysis in $SRC_DIR_PATH:"
	shpm_log ""
	shpm_log "Found $TOTAL_FUNCTIONS_FOUNDED_COUNT function(s) in $TOTAL_FILES_ANALYSED_COUNT file(s) analysed. $TOTAL_FUNCTIONS_WITH_TEST_COUNT function(s) have tests."
	shpm_log ""
	
	shpm_log "Total Coverage in %:"
	SHPM_LOG_DISABLED="$FALSE"
	
	echo "$TOTAL_COVERAGE" # this is a "return" value for this function	
}
#### shpm_file_utils.sh ############################################################################################
create_path_if_not_exists() {
	local PATH_TARGET
	PATH_TARGET="$1"
	
	if [[ -z "$PATH_TARGET" ]]; then
		shpm_log "${FUNCNAME[0]} run with empty param: |$PATH_TARGET|"
		return 1
	fi 
	if [[ ! -d "$PATH_TARGET" ]]; then
	   shpm_log "- Creating $PATH_TARGET ..."
	   mkdir -p "$PATH_TARGET"
	fi
}
remove_folder_if_exists() {
	local PATH_TO_FOLDER
	local ACTUAL_DIR
	
	ACTUAL_DIR=$(pwd)
	PATH_TO_FOLDER="$1"
	
	if [[ -z "$PATH_TO_FOLDER" ]]; then
		shpm_log "${FUNCNAME[0]} run with empty param: |$PATH_TO_FOLDER|"
		return "$FALSE"
	fi 
	
	if [[ -d "$PATH_TO_FOLDER" ]]; then
		shpm_log "- Exec secure remove of folder $PATH_TO_FOLDER ..."
	
		##
		 # SECURE rm -rf: move content to TMP_DIR, and execute rm -rf only inside TMP_DIR
		 ##
		# If a folder not already in tmp dir 
		if [[ "$TMP_DIR_PATH/"$( basename "$PATH_TO_FOLDER") != "$PATH_TO_FOLDER" ]]; then
			mv "$PATH_TO_FOLDER" "$TMP_DIR_PATH"
		fi
		
		cd "$TMP_DIR_PATH" || exit
		
		rm -rf "$(basename "$PATH_TO_FOLDER")"
		
		cd "$ACTUAL_DIR" || exit
		
		return "$TRUE"
	else
	    return "$FALSE"	
	fi
}
remove_file_if_exists() {
	local PATH_TO_FILE
	local ACTUAL_DIR
	
	ACTUAL_DIR=$(pwd)
	PATH_TO_FILE="$1"
	
	if [[ -z "$PATH_TO_FILE" ]]; then
		shpm_log "${FUNCNAME[0]} run with empty param: |$PATH_TO_FILE|"
		return 1
	fi 
	
	if [[ -f "$PATH_TO_FILE" ]]; then
		shpm_log "- Exec secure remove of file $PATH_TO_FILE ..."
	
		# SECURE rm -rf: move content to TMP_DIR, and execute rm -rf only inside TMP_DIR
		if [[ "$PATH_TO_FILE" != "$TMP_DIR_PATH"/$(basename "$PATH_TO_FILE") ]]; then
			mv "$PATH_TO_FILE" "$TMP_DIR_PATH"
		fi
		
		cd "$TMP_DIR_PATH" || exit
		
		rm -f "$(basename "$PATH_TO_FILE")"
		
		cd "$ACTUAL_DIR" || exit
			
		return "$TRUE"
	else
	    return "$FALSE"	
	fi
}
remove_tar_gz_from_folder() {
	local ACTUAL_DIR
	local FOLDER
	
	ACTUAL_DIR=$(pwd)
	FOLDER="$1"
	
	if [[ ! -z "$FOLDER" && -d "$FOLDER" ]]; then
	
		shpm_log "Removing *.tar.gz files from $FOLDER ..."
		
		cd "$FOLDER" || exit 1
		rm ./*.tar.gz 2> /dev/null
		
		shpm_log "Done"		
	else
		shpm_log "ERROR: $FOLDER not found."
		return "$FALSE" 
	fi
	
	cd "$ACTUAL_DIR" || exit
	
	return "$TRUE"
}
#### shpm_release_manager.sh #######################################################################################
run_clean_release() {
	clean_release
}
clean_release() {
	local PROJECT_DIR
	local RELEASES_DIR
	
	PROJECT_DIR="$1"
	
	RELEASES_DIR="$PROJECT_DIR/releases"
	TARGET_DIR="$PROJECT_DIR/$TARGET_DIR_SUBPATH"
	shpm_log_operation "Cleaning release"
	
	remove_tar_gz_from_folder "$RELEASES_DIR"
		
	remove_folder_if_exists "$TARGET_DIR"
	
	create_path_if_not_exists "$TARGET_DIR"
}
run_release_package() {
    clean_release "$ROOT_DIR_PATH"
	run_shellcheck 
	
	run_all_tests
	
	# Verify if are unit test failures
	if [ ! -z "${TEST_STATUS+x}" ]; then
		if [[ "$TEST_STATUS" != "OK" ]]; then
			shpm_log "Unit Test's failed!"
			exit 1; 
		fi
	fi
	shpm_log_operation "Build Release"
	shpm_log "Remove $TARGET_DIR_PATH folder ..."
	remove_folder_if_exists "$TARGET_DIR_PATH"
	
	TARGET_FOLDER="$ARTIFACT_ID""-""$VERSION"
	
	create_path_if_not_exists "$TARGET_DIR_PATH/$TARGET_FOLDER"
	shpm_log "Coping .sh files from $SRC_DIR_PATH/* to $TARGET_DIR_PATH/$TARGET_FOLDER ..."
	cp -R "$SRC_DIR_PATH"/* "$TARGET_DIR_PATH/$TARGET_FOLDER"
	
	# if not build itself
	if [[ ! -f "$SRC_DIR_PATH/shpm.sh" ]]; then
		shpm_log "Coping $DEPENDENCIES_FILENAME ..."
		cp "$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME" "$TARGET_DIR_PATH/$TARGET_FOLDER"
	else 
		shpm_log "Creating $DEPENDENCIES_FILENAME ..."
	    cp "$SRC_DIR_PATH/../resources/template_$DEPENDENCIES_FILENAME" "$TARGET_DIR_PATH/$TARGET_FOLDER/$DEPENDENCIES_FILENAME"
	    
	    shpm_log "Coping $BOOTSTRAP_FILENAME from $ROOT_DIR_PATH ..."
    	cp "$ROOT_DIR_PATH/$BOOTSTRAP_FILENAME" "$TARGET_DIR_PATH/$TARGET_FOLDER"
	fi
	
	shpm_log "Add sh-pm comments in .sh files ..."
	cd "$TARGET_DIR_PATH/$TARGET_FOLDER" || exit
	sed -i 's/\#\!\/bin\/bash/\#\!\/bin\/bash\n# '"$VERSION"' - Build with sh-pm/g' ./*.sh
		
	# if not build itself
	if [[ ! -f $TARGET_DIR_PATH/$TARGET_FOLDER/"shpm.sh" ]]; then
		shpm_log "Removing $BOOTSTRAP_FILENAME sourcing command from .sh files ..."
		sed -i "s/source \.\/$BOOTSTRAP_FILENAME//g" ./*.sh		
		sed -i "s/source \.\.\/\.\.\/\.\.\/$BOOTSTRAP_FILENAME//g" ./*.sh
	else
		shpm_log "Update $BOOTSTRAP_FILENAME sourcing command from .sh files ..."
	   	sed -i "s/source \.\.\/\.\.\/\.\.\/$BOOTSTRAP_FILENAME/source \.\/$BOOTSTRAP_FILENAME/g" shpm.sh	   	
	fi
	
	shpm_log "Package: Compacting .sh files ..."
	cd "$TARGET_DIR_PATH" || exit
	tar -czf "$TARGET_FOLDER"".tar.gz" "$TARGET_FOLDER"
	
	if [[ -d "$TARGET_DIR_PATH/$TARGET_FOLDER" ]]; then
		rm -rf "${TARGET_DIR_PATH:?}/${TARGET_FOLDER:?}"
	fi
	
	shpm_log "Relese file generated in folder $TARGET_DIR_PATH"
	
	cd "$ROOT_DIR_PATH" || exit
	
	shpm_log "Done"
}
run_publish_release() {
	local GIT_PROJECT
	local VERBOSE=$1
	
	GIT_PROJECT="$( basename "$ROOT_DIR_PATH" )"
	clean_release "$ROOT_DIR_PATH"
	
	build_release
	shpm_log_operation "Starting publish release process"
	
	local TARGET_FOLDER=$ARTIFACT_ID"-"$VERSION
	local TGZ_FILE_NAME=$TARGET_FOLDER".tar.gz"
	local FILE_PATH=$TARGET_DIR_PATH/$TGZ_FILE_NAME
	
	shpm_log_operation "Copying .tgz file to releaes folder"
	local RELEASES_PATH
	RELEASES_PATH="$ROOT_DIR_PATH""/""releases"
	if [[ ! -d "$RELEASES_PATH" ]]; then
		mkdir -p "$RELEASES_PATH"
	fi
	cp "$FILE_PATH" "$RELEASES_PATH" 
	
	local GIT_REMOTE_USERNAME
	local GIT_REMOTE_PASSWORD
	
	echo "---> $GIT_PROJECT"
	
	read_git_username_and_password
	
	create_new_remote_branch_from_master_branch "github.com" "$GIT_PROJECT" "$GIT_REMOTE_USERNAME" "$GIT_REMOTE_PASSWORD" "$VERSION"
}
#### shpm_generator.sh #############################################################################################
run_init_project_structure() {
	shpm_log_operation "Running sh-pm init ..."
	
	local FILENAME
	FILENAME="/tmp/nothing"
	
	create_path_if_not_exists "$SRC_DIR_PATH"
	create_path_if_not_exists "$TEST_DIR_PATH"
	    
    cd "$ROOT_DIR_PATH" || exit 1
    
    shpm_log "Move source code to $SRC_DIR_PATH ..."
    for file in "$ROOT_DIR_PATH"/*
	do
        FILENAME=$( basename "$file" )
        
        if [[  "$FILENAME" != "."* && "$FILENAME" != *"*"* && "$FILENAME" != *"~"* && "$FILENAME" != *"\$"* ]]; then
		    if [[ -f $file ]]; then
		        if [[ "$FILENAME" != "bootstrap.sh" && "$FILENAME" != "pom.sh" && "$FILENAME" != "shpm.sh" && "$FILENAME" == *".sh" ]]; then
		            shpm_log " - Moving file $file to $SRC_DIR_PATH ..."
		            mv "$file" "$SRC_DIR_PATH"
		        else
		        	shpm_log " - Skipping $file"
		        fi
		    fi
		    if [[ -d $file ]]; then
		        if [[ "$FILENAME" != "src" && "$FILENAME" != "target" && "$FILENAME" != "tmpoldshpm" ]]; then
	   	            shpm_log " - Moving folder $file to $SRC_DIR_PATH ..."
	   	            mv "$file" "$SRC_DIR_PATH"
	   	        else
	   	        	shpm_log " - Skipping $file"	            
		        fi
		    fi
		else
		    shpm_log " - Skipping $file"
	    fi
	done
	
	cd "$SRC_DIR_PATH" || exit 1 
	
	shpm_log "sh-pm expected project structure initialized"
	exit 0
}
#### shpm_evict_catastrophic_remove.sh #############################################################################
evict_catastrophic_remove() {
	# Evict catastrophic rm's when ROOT_DIR_PATH not set 
	if [[ -z "$ROOT_DIR_PATH" ]]; then
		echo "bootstrap.sh file not loaded!"
		return 1
	fi
}
#### shpm_git_api.sh ###############################################################################################
export GIT_REMOTE_USERNAME=""
export GIT_REMOTE_PASSWORD=""
read_git_username_and_password() {
	if [[ -z "$GIT_REMOTE_USERNAME" ]]; then
		echo "GitHub username: "
		read -r GIT_REMOTE_USERNAME
		
		export GIT_REMOTE_USERNAME
	else
		echo "Advice: GitHub username already defined"
	fi
	
	if [[ -z "$GIT_REMOTE_PASSWORD" ]]; then
		echo "GitHub password: "
		read -r -s GIT_REMOTE_PASSWORD		
		GIT_REMOTE_PASSWORD="${GIT_REMOTE_PASSWORD//@/%40}"
		export GIT_REMOTE_PASSWORD
	else
		echo "Advice: GitHub password already defined"
	fi
}
git_clone() {
	local GIT_CMD
	local REPOSITORY
	local DEP_ARTIFACT_ID
	local DEP_VERSION
	
	REPOSITORY=$1
	DEP_ARTIFACT_ID=$2
	DEP_VERSION=$3
	
	GIT_CMD="$(which git)"
	if "$GIT_CMD" clone --branch "$DEP_VERSION" "https://""$REPOSITORY""/""$DEP_ARTIFACT_ID"".git"; then
		return $TRUE
	fi
	return $FALSE
}
download_from_git_to_tmp_folder() {
	local GIT_CMD
	local REPOSITORY
	local DEP_ARTIFACT_ID
	local DEP_VERSION
	
	REPOSITORY=$1
	DEP_ARTIFACT_ID=$2
	DEP_VERSION=$3
	remove_folder_if_exists "$TMP_DIR_PATH/$DEP_ARTIFACT_ID"
	
	cd "$TMP_DIR_PATH" || exit
	
	GIT_CMD="$(which git)"
	shpm_log "- Cloning from https://$REPOSITORY/$DEP_ARTIFACT_ID into /tmp/$DEP_ARTIFACT_ID ..."
	shpm_log "    $GIT_CMD clone --branch $DEP_VERSION https://$REPOSITORY/$DEP_ARTIFACT_ID.git"
	if git_clone "$REPOSITORY" "$DEP_ARTIFACT_ID" "$DEP_VERSION" &>/dev/null ; then
		return $TRUE
	fi
	return $FALSE
}
create_new_remote_branch_from_master_branch() {
	local ACTUAL_BRANCH
	local MASTER_BRANCH
	local GIT_CMD
	
	local GIT_HOST
	local GIT_REPO
	local GIT_PROJECT
	local GIT_USER
	local GIT_PASSWD
	local ORIGINAL_BRANCH
	local NEW_BRANCH
	
	GIT_HOST="$1"
	#GIT_REPO="$2"
	GIT_PROJECT="$3"
	GIT_USER="$4"
	#GIT_PASSWD="$5"
	ORIGINAL_BRANCH="$6"
	NEW_BRANCH="$7"
	
	GIT_ORIGINAL_URL="https://$GIT_HOST/$GIT_USER/$GIT_PROJECT.git"
	
	if [[ "$NEW_BRANCH" != "" ]]; then
		GIT_CMD=$( which git )
		
		REMOTE_BRANCH_FOUND=$( git branch -r | grep "origin/$NEW_BRANCH" | xargs )
		if [[ ! -z "$REMOTE_BRANCH_FOUND" ]]; then  # if branch already exists
			#TODO: ???
			echo "PENDING IMPLEMENTATION!!!" && exit 1
		else
			echo "Create new local branch"
			$GIT_CMD branch "$NEW_BRANCH" || exit 1		
		fi
		
		
		echo "Go to new branch"
		$GIT_CMD checkout "$NEW_BRANCH" || exit 1
		echo "Commit staged changes to local master"
		$GIT_CMD add .  || exit 1
		$GIT_CMD commit -m "Test" -m "Creation new branch with name $NEW_BRANCH"  || exit 1
		
		echo "Push branch to remote"
		$GIT_CMD push -u "$GIT_ORIGINAL_URL" "$NEW_BRANCH"  || exit 1
		
		echo "Goto $ORIGINAL_BRANCH branch again"
		$GIT_CMD checkout "$ORIGINAL_BRANCH"  || exit 1
		
		echo "Fetch to local branch \"see\" new remote branch"
		$GIT_CMD fetch  || exit 1
	fi
}
#### shpm_package_manager.sh #######################################################################################
run_update_dependencies() {
	shpm_log_operation "Update Dependencies"
	
    local VERBOSE="$1"
	
	shpm_log "Start update of ${#DEPENDENCIES[@]} dependencies ..."
	for DEP_ARTIFACT_ID in "${!DEPENDENCIES[@]}"; do 
		update_dependency "$DEP_ARTIFACT_ID" "$VERBOSE"
	done
	
	cd "$ROOT_DIR_PATH" || exit 1
	
	shpm_log "Done"
}
shpm_update_itself_after_git_clone() {
    shpm_log "WARN: sh-pm updating itself ..." "yellow"
    
    local PATH_TO_DEP_IN_TMP
    local PATH_TO_DEP_IN_PROJECT
    
    PATH_TO_DEP_IN_TMP="$1"
    PATH_TO_DEP_IN_PROJECT="$2"
    
    shpm_log "     - Copy $BOOTSTRAP_FILENAME to $PATH_TO_DEP_IN_PROJECT ..."
	cp "$PATH_TO_DEP_IN_TMP/$BOOTSTRAP_FILENAME" "$PATH_TO_DEP_IN_PROJECT"
			
	shpm_log "     - Update $BOOTSTRAP_FILENAME sourcing command from shpm.sh file ..."
	sed -i 's/source \.\.\/\.\.\/\.\.\/bootstrap.sh/source \.\/bootstrap.sh/g' "$PATH_TO_DEP_IN_PROJECT/shpm.sh"
    
    if [[ -f "$ROOT_DIR_PATH/shpm.sh" ]]; then
    	create_path_if_not_exists "$ROOT_DIR_PATH/tmpoldshpm"
    	
    	shpm_log "   - backup actual sh-pm version to $ROOT_DIR_PATH/tmpoldshpm ..."
    	mv "$ROOT_DIR_PATH/shpm.sh" "$ROOT_DIR_PATH/tmpoldshpm"
    fi
    
    if [[ -f "$PATH_TO_DEP_IN_PROJECT/shpm.sh" ]]; then
    	shpm_log "   - update shpm.sh ..."
    	cp "$PATH_TO_DEP_IN_PROJECT/shpm.sh"	"$ROOT_DIR_PATH"
    fi
    
    if [[ -f "$ROOT_DIR_PATH/$BOOTSTRAP_FILENAME" ]]; then
    	shpm_log "   - backup actual $BOOTSTRAP_FILENAME to $ROOT_DIR_PATH/tmpoldshpm ..."
    	mv "$ROOT_DIR_PATH/$BOOTSTRAP_FILENAME" "$ROOT_DIR_PATH/tmpoldshpm"
    fi
    
    if [[ -f "$PATH_TO_DEP_IN_PROJECT/$BOOTSTRAP_FILENAME" ]]; then
    	shpm_log "   - update $BOOTSTRAP_FILENAME ..."
    	cp "$PATH_TO_DEP_IN_PROJECT/$BOOTSTRAP_FILENAME"	"$ROOT_DIR_PATH"
    fi
}
set_dependency_repository(){
	local DEP_ARTIFACT_ID
	local R2_DEP_REPOSITORY # (R)eference (2)nd: will be attributed to 2nd param by reference	
	local ARTIFACT_DATA
	
	DEP_ARTIFACT_ID="$1"
	ARTIFACT_DATA="${DEPENDENCIES[$DEP_ARTIFACT_ID]}"
	
	if [[ "$ARTIFACT_DATA" == *"@"* ]]; then
		R2_DEP_REPOSITORY=$( echo "$ARTIFACT_DATA" | cut -d "@" -f 2 | xargs ) #xargs is to trim string!
		
		if [[ "$R2_DEP_REPOSITORY" == "" ]]; then
			shpm_log "Error in $DEP_ARTIFACT_ID dependency: Inform a repository after '@' in $DEPENDENCIES_FILENAME"
			exit 1
		fi
	else
		shpm_log "Error in $DEP_ARTIFACT_ID dependency: Inform a repository after '@' in $DEPENDENCIES_FILENAME"
		exit 1
	fi
	
	eval "$2=$R2_DEP_REPOSITORY"
}
set_dependency_version(){
	local DEP_ARTIFACT_ID
	local R2_DEP_VERSION	# (R)eference (2)nd: will be attributed to 2nd param by reference
	
	DEP_ARTIFACT_ID="$1"
	
	local ARTIFACT_DATA="${DEPENDENCIES[$DEP_ARTIFACT_ID]}"
	if [[ "$ARTIFACT_DATA" == *"@"* ]]; then
		R2_DEP_VERSION=$( echo "$ARTIFACT_DATA" | cut -d "@" -f 1 | xargs ) #xargs is to trim string!						
	else
		shpm_log "Error in $DEP_ARTIFACT_ID dependency: Inform a repository after '@' in $DEPENDENCIES_FILENAME"
		exit 1
	fi
	
	eval "$2=$R2_DEP_VERSION"
}
update_dependency() {
    local DEP_ARTIFACT_ID=$1
    local VERBOSE=$2
    
	local DEP_VERSION
	local REPOSITORY
	local DEP_FOLDER_NAME
	local PATH_TO_DEP_IN_PROJECT
	local PATH_TO_DEP_IN_TMP
	
	local ACTUAL_DIR
	
	ACTUAL_DIR=$( pwd )
	
	create_path_if_not_exists "$LIB_DIR_PATH" 
	
	set_dependency_repository "$DEP_ARTIFACT_ID" REPOSITORY 
	set_dependency_version "$DEP_ARTIFACT_ID" DEP_VERSION
	DEP_FOLDER_NAME="$DEP_ARTIFACT_ID""-""$DEP_VERSION"
	PATH_TO_DEP_IN_PROJECT="$LIB_DIR_PATH/$DEP_FOLDER_NAME"
	PATH_TO_DEP_IN_TMP="$TMP_DIR_PATH/$DEP_ARTIFACT_ID"
	
	shpm_log "----------------------------------------------------"
	reset_g_indent 
	increase_g_indent 	
	shpm_log "Updating $DEP_ARTIFACT_ID to $DEP_VERSION: Start"				
	 
	increase_g_indent
	if download_from_git_to_tmp_folder "$REPOSITORY" "$DEP_ARTIFACT_ID" "$DEP_VERSION"; then
	
		remove_folder_if_exists "$PATH_TO_DEP_IN_PROJECT"		
		create_path_if_not_exists "$PATH_TO_DEP_IN_PROJECT"
				
		shpm_log "- Copy artifacts from $PATH_TO_DEP_IN_TMP to $PATH_TO_DEP_IN_PROJECT ..."
		cp "$PATH_TO_DEP_IN_TMP/src/main/sh/"* "$PATH_TO_DEP_IN_PROJECT"
		cp "$PATH_TO_DEP_IN_TMP/pom.sh" "$PATH_TO_DEP_IN_PROJECT"
		
		# if update a sh-pm
		if [[ "$DEP_ARTIFACT_ID" == "sh-pm" ]]; then
			shpm_update_itself_after_git_clone "$PATH_TO_DEP_IN_TMP" "$PATH_TO_DEP_IN_PROJECT"
		fi
		
		shpm_log "- Removing $PATH_TO_DEP_IN_TMP ..."
		increase_g_indent
		remove_folder_if_exists "$PATH_TO_DEP_IN_TMP"
		decrease_g_indent
		
		cd "$ACTUAL_DIR" || exit
	
	else 		   		  
       shpm_log "$DEP_ARTIFACT_ID was not updated to $DEP_VERSION!"
	fi
	
	decrease_g_indent 	
	shpm_log "Update $DEP_ARTIFACT_ID to $DEP_VERSION: Finish"
	
	reset_g_indent 
	
	cd "$ACTUAL_DIR" || exit 1
}
#### main.sh #######################################################################################################
print_help() {
  	local SCRIPT_NAME
    SCRIPT_NAME="$ARTIFACT_ID"
    echo "SH-PM: Shell Script Package Manager"
	echo ""
	echo "USAGE:"
	echo "  [$SCRIPT_NAME] [OPTION]"
	echo ""
	echo "OPTIONS:"
    echo "  update                Download dependencies in local repository $LIB_DIR_SUBPATH"
	echo "  init                  Create expecte sh-pm project structure with files and folders " 
	echo "  clean                 Clean $TARGET_DIR_PATH folder"
    echo "  lint                  Run ShellCheck (if exists) in $SRC_DIR_SUBPATH folder"
    echo "  test                  Run sh-unit tests in $TEST_DIR_SUBPATH folder"
	echo "  coverage              Show sh-unit test coverage"
    echo "  package               Create compressed file in $TARGET_DIR_PATH folder"
    echo "  publish               Publish code and builded file in GitHub repositories (remote and local)"
	echo ""
	echo "EXAMPLES:"
	echo "  ./shpm update"
	echo ""
	echo "  ./shpm init"
	echo ""
	echo "  ./shpm package"
	echo ""
	echo "  ./shpm publish"
	echo ""
}
run_sh_pm() {
	if [ $# -eq 0 ];  then
		print_help
		exit 1
	else
		for (( i=1; i <= $#; i++)); do	
	        ARG="${!i}"
	
			if [[ "$ARG" == "update" ]];  then
				run_update_dependencies	"$VERBOSE"
			fi
			
			if [[ "$ARG" == "init" ]];  then
				run_init_project_structure
			fi
			
			if [[ "$ARG" == "clean" ]];  then
				run_clean_release "$ROOT_DIR_PATH"
			fi
			if [[ "$ARG" == "lint" ]];  then
				run_shellcheck
			fi
			
			if [[ "$ARG" == "test" ]];  then
				TEST="true"				
				shift # this discard 1st param and do $@ consider params from 2nd param to end
				run_testcases "$@" 				
			fi
			
			if [[ "$ARG" == "coverage" ]];  then
				run_coverage_analysis
			fi
						
			if [[ "$ARG" == "compile_app" ]];  then				
				i=$((i+1))
				SKIP_SHELLCHECK="${!i:-false}"
				
				run_compile_app
			fi
			
			if [[ "$ARG" == "compile_lib" ]];  then				
				i=$((i+1))
				SKIP_SHELLCHECK="${!i:-false}"
				
				run_compile_lib
			fi
		
			if [[ "$ARG" == "package" ]];  then
				PACKAGE="true"
				i=$((i+1))
				SKIP_SHELLCHECK="${!i:-false}"
				
				run_release_package
			fi
			
			if [[ "$ARG" == "publish" ]];  then
				PUBLISH="true"
				i=$((i+1))
				SKIP_SHELLCHECK="${!i:-false}"
				
				run_publish_release				
			fi
		done
	fi
}
evict_catastrophic_remove || exit 1
run_sh_pm "$@"
