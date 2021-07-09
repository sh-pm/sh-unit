#!/usr/bin/env bash

source ./bootstrap.sh

evict_catastrophic_remove() {
	# Evict catastrophic rm's when ROOT_DIR_PATH not set 
	if [[ -z "$ROOT_DIR_PATH" ]]; then
		echo "bootstrap.sh file not loaded!"
		return 1
	fi
}

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
	echo -e $( right_pad_string "\n" 133 "#" )"\n"
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

concat_all_lib_files() {
	shpm_log "- Concat all .sh lib files that will be used in compile ..."
			
	local LIB_FILES=$( find "$LIB_DIR_PATH"  -type f ! -name "$DEPENDENCIES_FILENAME" ! -name 'sh-pm*' -name '*.sh' )
	
	local FILENAME
	
	for file in ${LIB_FILES[@]}; do
	
		FILENAME=$( basename "$file" ) 
	
		echo "### $FILENAME ${FILE_SEPARATOR:0:-${#FILENAME}}" > "$FILE_WITH_SEPARATOR"
		
		cat "$FILE_WITH_SEPARATOR" "$file" >> "$FILE_WITH_CAT_SH_LIBS""_tmp"
	done
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
	shpm_log ""	
	shpm_log "Running compile pipeline:"
	shpm_log ""
}

concat_all_src_files(){
	shpm_log "- Concat all .sh src files that will be used in compile except entrypoint file ..."	
	local SRC_FILES=$( find "$SRC_DIR_PATH"  -type f ! -path "sh-pm*" ! -name "pom.sh" -name '*.sh' )
	local FILE_ENTRYPOINT_PATH=""
	
	for file in ${SRC_FILES[@]}; do
		if [[ "$FILE_ENTRY_POINT" == "$( basename "$file" )" ]]; then
			FILE_ENTRYPOINT_PATH="$file"
		else	
		
			FILENAME_AUX=$( basename "$file" )
			
			FILECONTENT_SEP=$( right_pad_string "" 133 "#" )
			 		
			echo "######## $FILENAME_AUX ${FILECONTENT_SEP:0:-${#FILENAME_AUX}}" > "$FILE_WITH_SEPARATOR"
			
			cat "$FILE_WITH_SEPARATOR" "$file" >> "$FILE_WITH_CAT_SH_SRCS""_tmp"
		fi 		
	done
}

remove_problematic_lines_of_src_concat_file() {
	shpm_log "- Remove problematic lines in all .sh src files ..."
	grep -v "$PATTERN_INCLUDE_BOOTSTRAP_FILE" < "$FILE_WITH_CAT_SH_SRCS""_tmp" | grep -v "$SHEBANG_FIRST_LINE" | grep -v "$INCLUDE_LIB_AND_FILE" > "$FILE_WITH_CAT_SH_SRCS"
	remove_file_if_exists "$FILE_WITH_CAT_SH_SRCS""_tmp"
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

ensure_newline_at_end_of_src_files() {
  	shpm_log "- Ensure \\\n in end of src files to prevent file concatenation errors ..."
	find "$SRC_DIR_PATH"  -type f ! -path "sh-pm*" ! -name "$DEPENDENCIES_FILENAME" -name '*.sh' -exec sed -i -e '$a\' {} \;
}

run_compile_app() {
	
	shpm_log_operation "Compile Application"
		
	if [[ ! -f "$MANIFEST_FILE_PATH" ]]; then
		shpm_log "\nERROR: $MANIFEST_FILE_PATH not found!\n" "red"
		return $FALSE
	fi
	
	local FILE_ENTRY_POINT
	
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
	
	FILE_ENTRY_POINT=$( get_entry_point_file )
	
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
	
	INCLUDE_LIB_AND_FILE="include_lib\|include_file"
	SHEBANG_FIRST_LINE="#!/bin/bash\|#!/usr/bin/env bash"
	
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

	remove_file_if_exists "$COMPILED_FILE_PATH"
	
	shpm_log "- Generate compiled file ..."
	
	local DEP_FILE_PATH="$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME";
	echo "### $DEP_FILE_PATH ${FILE_SEPARATOR:0:-${#DEP_FILE_PATH}}" > "$FILE_WITH_SEPARATOR""_dep"
	
	local BOOTSTRAP_FILE_PATH="$ROOT_DIR_PATH/$BOOTSTRAP_FILENAME";
	echo "### $BOOTSTRAP_FILE_PATH ${FILE_SEPARATOR:0:-${#BOOTSTRAP_FILE_PATH}}" > "$FILE_WITH_SEPARATOR""_bootstrap"
		
	echo "### $FILE_ENTRYPOINT_PATH ${FILE_SEPARATOR:0:-${#FILE_ENTRYPOINT_PATH}}" > "$FILE_WITH_SEPARATOR""_entrypoint"
	
	cat "$FILE_WITH_SEPARATOR""_dep" "$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME"  \
	"$FILE_WITH_SEPARATOR""_bootstrap" "$FILE_WITH_BOOTSTRAP_SANITIZED" \
	"$FILE_WITH_SEPARATOR" "$FILE_WITH_CAT_SH_LIBS" \
	"$FILE_WITH_SEPARATOR""_entrypoint" "$FILE_ENTRYPOINT_PATH" \
	"$FILE_WITH_SEPARATOR" "$FILE_WITH_CAT_SH_SRCS" \
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
	
	INCLUDE_LIB_AND_FILE="include_lib\|include_file"
	SHEBANG_FIRST_LINE="#!/bin/bash\|#!/usr/bin/env bash"
	
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
				
				run_compile_application
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

run_sh_pm compile_lib
