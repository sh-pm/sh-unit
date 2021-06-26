#!/usr/bin/env bash

source ./bootstrap.sh

SHPM_LOG_DISABLED="$FALSE"

G_SHPMLOG_TAB="  "
G_SHPMLOG_INDENT=""

#-----------------------------------
evict_catastrophic_remove() {
	# Evict catastrophic rm's when ROOT_DIR_PATH not set 
	if [[ -z "$ROOT_DIR_PATH" ]]; then
		echo "bootstrap.sh file not loaded!"
		return 1
	fi
}
evict_catastrophic_remove || exit 1
#-----------------------------------

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

print_help() {
  
    SCRIPT_NAME=shpm

    echo "SH-PM: Shell Script Package Manager"
	echo ""
	echo "USAGE:"
	echo "  [$SCRIPT_NAME] [OPTION]"
	echo ""
	echo "OPTIONS:"
    echo "  update                Download dependencies in local repository $LIB_DIR_SUBPATH"
	echo "  init                  Create expecte sh-pm project structure with files and folders " 
	echo "  clean                 Clean $TARGET_DIR_PATH folder"
    echo "  test                  Run sh-unit tests in $TEST_DIR_SUBPATH folder"
	echo "  coverage              Show sh-unit test coverage"
    echo "  lint                  Run ShellCheck (if exists) $SRC_DIR_SUBPATH folder"
    echo "  package               Create compressed file in $TARGET_DIR_PATH folder"
    echo "  publish               Publish code and builded file in GitHub repositories (remote and local)"
	echo "  install               Install in local repository $LIB_DIR_SUBPATH"            
	echo "  uninstall             Remove from local repository $LIB_DIR_SUBPATH"
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
	local GIT_CMD

	local UPDATE=false
 	local INIT=false
	local LINT=false	
	local TEST=false
	local COMPILE=false
	local PACKAGE=false
	local INSTALL=false	
	local PUBLISH=false
	local SKIP_SHELLCHECK=false
	local AUTOUPDATE=false
	local UNINSTALL=false
	local COVERAGE=false
	local CLEAN=false
	
	local VERBOSE=false	
	
	GIT_CMD=$(which git)
	
	if [ $# -eq 0 ];  then
		print_help
		exit 1
	else
		for (( i=1; i <= $#; i++)); do	
	        ARG="${!i}"
	
			if [[ "$ARG" == "update" ]];  then
				UPDATE="true"
			fi

			if [[ "$ARG" == "lint" ]];  then
				LINT="true"
			fi

			if [[ "$ARG" == "test" ]];  then
				TEST="true"
			fi
			
			if [[ "$ARG" == "clean" ]];  then
				CLEAN="true"
			fi
		
			if [[ "$ARG" == "compile" ]];  then
				COMPILE="true"
				i=$((i+1))
				SKIP_SHELLCHECK="${!i:-false}"
			fi
		
			if [[ "$ARG" == "package" ]];  then
				PACKAGE="true"
				i=$((i+1))
				SKIP_SHELLCHECK="${!i:-false}"
			fi
			
			if [[ "$ARG" == "install" ]];  then
				INSTALL="true"
			fi
			
			if [[ "$ARG" == "publish" ]];  then
				PUBLISH="true"
				i=$((i+1))
				SKIP_SHELLCHECK="${!i:-false}"
			fi
			
			if [[ "$ARG" == "autoupdate" ]];  then
				AUTOUPDATE="true"
			fi
			
			if [[ "$ARG" == "uninstall" ]];  then
				UNINSTALL="true"
			fi
			if [[ "$ARG" == "init" ]];  then
				INIT="true"
			fi
			if [[ "$ARG" == "coverage" ]];  then
				COVERAGE="true"
			fi
			if [[ "$ARG" == "-v" ]];  then
				VERBOSE="true"
			fi
		done
	fi
	
	if [[ "$UPDATE" == "true" ]];  then
		update_dependencies	"$VERBOSE"
	fi
	
	if [[ "$CLEAN" == "true" ]];  then
		clean_release "$ROOT_DIR_PATH"
	fi
	
	if [[ "$LINT" == "true" ]];  then
		run_shellcheck 
	fi
	
	if [[ "$TEST" == "true" ]];  then
		run_all_tests
	fi
	
	if [[ "$PACKAGE" == "true" ]];  then
		run_release_package
	fi
	
	if [[ "$COMPILE" == "true" ]];  then
		compile_sh_project
	fi
	
	if [[ "$INSTALL" == "true" ]];  then
		install_release
	fi
	
	if [[ "$PUBLISH" == "true" ]];  then	
		publish_release "$VERBOSE"
	fi
	
	if [[ "$AUTOUPDATE" == "true" ]];  then	
		auto_update
	fi
	
	if [[ "$UNINSTALL" == "true" ]];  then
		uninstall_release
	fi
		
	if [[ "$INIT" == "true" ]];  then
		init_project_structure
	fi
	
	if [[ "$COVERAGE" == "true" ]];  then
		run_coverage_analysis		
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

update_dependencies() {
	shpm_log_operation "Update Dependencies"
	
    local VERBOSE="$1"
	
	shpm_log "Start update of ${#DEPENDENCIES[@]} dependencies ..."
	for DEP_ARTIFACT_ID in "${!DEPENDENCIES[@]}"; do 
		update_dependency "$DEP_ARTIFACT_ID" "$VERBOSE"
	done
	
	cd "$ROOT_DIR_PATH" || exit 1
	
	shpm_log "Done"
}

uninstall_release () {
	shpm_log_operation "Uninstall lib"
	
	local TARGET_FOLDER
	local TGZ_FILE
	local TGZ_FILE_PATH
	
	local ACTUAL_DIR

	TARGET_FOLDER="$ARTIFACT_ID""-""$VERSION"
	TGZ_FILE="$TARGET_FOLDER"".tar.gz"
	TGZ_FILE_PATH="$TARGET_DIR_PATH/$TGZ_FILE"
	
	ACTUAL_DIR="$(pwd)"
	
	clean_release "$ROOT_DIR_PATH"
	
	build_release
	
	remove_tar_gz_from_folder "$LIB_DIR_PATH"
	
	remove_folder_if_exists "$LIB_DIR_PATH/$TARGET_FOLDER"
	
	cd "$ACTUAL_DIR" || exit
	
	shpm_log "Done"
}

install_release () {
	local TARGET_FOLDER
	local TGZ_FILE
	local TGZ_FILE_PATH
	
	local ACTUAL_DIR

	TARGET_FOLDER="$ARTIFACT_ID""-""$VERSION"
	TGZ_FILE="$TARGET_FOLDER"".tar.gz"
	TGZ_FILE_PATH="$TARGET_DIR_PATH/$TGZ_FILE"

	ACTUAL_DIR=$(pwd)
	
	build_release
	
	uninstall_release
	
	shpm_log_operation "Install Release into local repository"
	
	shpm_log "Install $TGZ_FILE_PATH into $LIB_DIR_PATH ..."
	cd "$LIB_DIR_PATH/" || exit
	
	cp "$TGZ_FILE_PATH" "$LIB_DIR_PATH/"	
	
	tar -xzf "$TGZ_FILE"
		
	remove_file_if_exists "$TGZ_FILE_PATH"
	
	cd "$ACTUAL_DIR" || exit
	
	shpm_log "Done"
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
	local DEP_ARTIFACT_ID="$1"
	local R_DEP_REPOSITORY
	
	local ARTIFACT_DATA="${DEPENDENCIES[$DEP_ARTIFACT_ID]}"
	if [[ "$ARTIFACT_DATA" == *"@"* ]]; then
		R_DEP_REPOSITORY=$( echo "$ARTIFACT_DATA" | cut -d "@" -f 2 | xargs ) #xargs is to trim string!
		
		if [[ "$R_DEP_REPOSITORY" == "" ]]; then
			shpm_log "Error in $DEP_ARTIFACT_ID dependency: Inform a repository after '@' in $DEPENDENCIES_FILENAME"
			exit 1
		fi
	else
		shpm_log "Error in $DEP_ARTIFACT_ID dependency: Inform a repository after '@' in $DEPENDENCIES_FILENAME"
		exit 1
	fi
	
	eval "$2=$R_DEP_REPOSITORY"
}

set_dependency_version(){
	local DEP_ARTIFACT_ID="$1"
	local R_DEP_VERSION	
	
	local ARTIFACT_DATA="${DEPENDENCIES[$DEP_ARTIFACT_ID]}"
	if [[ "$ARTIFACT_DATA" == *"@"* ]]; then
		R_DEP_VERSION=$( echo "$ARTIFACT_DATA" | cut -d "@" -f 1 | xargs ) #xargs is to trim string!						
	else
		shpm_log "Error in $DEP_ARTIFACT_ID dependency: Inform a repository after '@' in $DEPENDENCIES_FILENAME"
		exit 1
	fi
	
	eval "$2=$R_DEP_VERSION"
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

	local HOST="${REPOSITORY[host]}"
	local PORT="${REPOSITORY[port]}"	

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


create_new_remote_branch_from_master_branch() {
	local ACTUAL_BRANCH
	local MASTER_BRANCH
	local NEW_BRANCH
	local GIT_CMD

	NEW_BRANCH="$1"
	
	if [[ "$NEW_BRANCH" != "" ]]; then
		GIT_CMD=$( which git )
		
		cd "$ROOT_DIR_PATH" || exit 1;
	
		$GIT_CMD add .
	
		$GIT_CMD commit -m "$NEW_BRANCH" -m "- New release version"
		
		ACTUAL_BRANCH=$( $GIT_CMD rev-parse --abbrev-ref HEAD | xargs )

		if [[ "$ACTUAL_BRANCH" != "master" && "$ACTUAL_BRANCH" != "main" ]]; then
			MASTER_BRANCH=$( $GIT_CMD branch | grep "master\|main" | xargs )
			$GIT_CMD checkout "$MASTER_BRANCH" 
		fi
		
		$GIT_CMD push origin "$MASTER_BRANCH"

		$GIT_CMD checkout -b "$NEW_BRANCH"

		$GIT_CMD push -u origin "$NEW_BRANCH"
	fi
}

publish_release() {

	local VERBOSE=$1

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
	
	create_new_remote_branch_from_master_branch "$VERSION" 
}

send_to_sh_archiva () {
	local VERBOSE=$1

	if [[ "$SSO_API_AUTHENTICATION_URL" == "" ]]; then
		shpm_log "In order to publish release, you must define SSO_API_AUTHENTICATION_URL variable in your pom.sh."
		exit 1
	fi

	clean_release "$ROOT_DIR_PATH"
	
	build_release

	shpm_log_operation "Starting publish release process"
	
	local HOST=${REPOSITORY[host]}
	local PORT=${REPOSITORY[port]}	

	local TARGET_FOLDER=$ARTIFACT_ID"-"$VERSION
	local TGZ_FILE_NAME=$TARGET_FOLDER".tar.gz"
	local FILE_PATH=$TARGET_DIR_PATH/$TGZ_FILE_NAME


	local TARGET_REPO="https://$HOST:$PORT/sh-archiva/snapshot/$GROUP_ID/$ARTIFACT_ID/$VERSION"
	shpm_log "----------------------------------------------------------------------------"
	shpm_log "From: $FILE_PATH"
	shpm_log "  To: $TARGET_REPO"
	shpm_log "----------------------------------------------------------------------------"
	
	echo Username:
	read -r USERNAME
	
	echo Password:
	read -r -s PASSWORD
	
	shpm_log "Authenticating user \"$USERNAME\" in $SSO_API_AUTHENTICATION_URL ..."
	#echo "curl -s -X POST -d '{"username" : "'"$USERNAME"'", "password": "'"$PASSWORD"'"}' -H 'Content-Type: application/json' "$SSO_API_AUTHENTICATION_URL""	
	TOKEN=$( curl -s -X POST -d '{"username" : "'"$USERNAME"'", "password": "'"$PASSWORD"'"}' -H 'Content-Type: application/json' "$SSO_API_AUTHENTICATION_URL" )
	
	if [[ "$TOKEN" == "" ]]; then
		shpm_log "Authentication failed"
		exit 2
	else
		shpm_log "Authentication successfull"
		shpm_log "Sending release to repository $TARGET_REPO  ..."
		TOKEN_HEADER="Authorization: Bearer $TOKEN"
		
		CURL_OPTIONS="-s"
		if [[ "$VERBOSE" == "true" ]]; then
		    CURL_OPTIONS="-v"
		fi
			
		MSG_RETURNED=$( curl "$CURL_OPTIONS" -F file=@"$FILE_PATH" -H "$TOKEN_HEADER" "$TARGET_REPO" )
		shpm_log "Sended"
		
		shpm_log "Return received from repository:"
		shpm_log "----------------------------------------------------------------------------"
		shpm_log "$MSG_RETURNED"
		shpm_log "----------------------------------------------------------------------------"
		
		shpm_log "Done"
	fi 

}

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
	    		shpm_log "FAIL!" "re"
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

run_all_tests() {

	local ACTUAL_DIR
	ACTUAL_DIR=$(pwd)
	
	shpm_log_operation "Searching unit test files to run ..."


	if [[ -d "$TEST_DIR_PATH" ]]; then
	
		cd "$TEST_DIR_PATH" || exit
		
		local TEST_FILES
		TEST_FILES=( $(ls ./*_test.sh 2> /dev/null) );
		
		shpm_log "Found ${#TEST_FILES[@]} test files" 
		if (( "${#TEST_FILES[@]}" > 0 )); then
			for file in "${TEST_FILES[@]}"
			do
				shpm_log "Run file ..."
				source "$file"
			done
		else
			shpm_log "Nothing to test"
		fi
	
	else 
		shpm_log "Nothing to test"
	fi
	
	cd "$ACTUAL_DIR" || exit 1

	shpm_log "Done"
}

auto_update() {

	shpm_log_operation "Running sh-pm auto update ..."
	 
    local HOST=${REPOSITORY[host]}
	local PORT=${REPOSITORY[port]}	
	
	for DEP_ARTIFACT_ID in "${!DEPENDENCIES[@]}"; do 
	    if [[ "$DEP_ARTIFACT_ID" == "sh-pm" ]]; then		
			update_dependency "$DEP_ARTIFACT_ID"
			
			shpm_log "Done"
	        exit 0    
	    fi
	done
	
	shpm_log "Could not update sh-pm: sh-pm not present in dependencies of pom.sh"
	exit 1004
}

init_project_structure() {

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
}

do_coverage_analysis() {
	VERBOSE="$1"

	FILE_COUNT=0
	FUNCTIONS_COUNT=0
	FUNCTIONS_WITH_TEST_COUNT=0
	
	if [[ "$VERBOSE" != "-v"  ]]; then
		SHPM_LOG_DISABLED="$TRUE"
	fi
	
	shpm_log ""
	shpm_log "Run test coverage analysis in $SRC_DIR_PATH:"
	shpm_log ""
	
	SH_FILES_FOUNDED=$( find "$SRC_DIR_PATH" -name "*.sh" )
	
	for filepath in "${SH_FILES_FOUNDED[@]}"; do 
		FILE_COUNT=$((FILE_COUNT+1))
		 
		shpm_log ""
		shpm_log "-- $filepath ---------------------- "
		
		FUNCTIONS_TO_TEST=( $(grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$filepath" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//') );
		  
		filename="$( basename "$filepath" )"
		test_filename="${filename//.sh/}_test.sh"
		test_filepath="$TEST_DIR_PATH/$test_filename"
		 
		if [[ -f "$test_filepath" ]]; then
			EXISTING_TEST_FUNCTIONS=( $(grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$test_filepath" | tr \(\)\}\{ ' ' | sed 's/^[ \t]*//;s/[ \t]*$//') );
		fi
		
		FILE_FUNCTIONS_COUNT=0
		FILE_FUNCTIONS_WITH_TEST_COUNT=0
		for function_name in "${FUNCTIONS_TO_TEST[@]}"; do
			FILE_FUNCTIONS_COUNT=$((FILE_FUNCTIONS_COUNT+1))
			FUNCTIONS_COUNT=$((FUNCTIONS_COUNT+1))
			
			foundtest=$FALSE
			for test_function in "${EXISTING_TEST_FUNCTIONS[@]}"; do
				if [[ "$test_function" == "test_""$function_name" ]]; then
					foundtest=$TRUE
					FILE_FUNCTIONS_WITH_TEST_COUNT=$((FILE_FUNCTIONS_WITH_TEST_COUNT+1))
					FUNCTIONS_WITH_TEST_COUNT=$((FUNCTIONS_WITH_TEST_COUNT+1))
					break;
				fi
			done;
			
			if [[ "$foundtest" == "$FALSE" ]]; then
			   shpm_log "     $function_name ... No tests found!" "red"
			else
			   shpm_log "     $function_name ... OK" "green"
			fi
		done
		
		PERCENT_COVERAGE=$(bc <<< "scale=2; $FILE_FUNCTIONS_WITH_TEST_COUNT / $FILE_FUNCTIONS_COUNT * 100")
		
		shpm_log ""
		shpm_log "   Found $FILE_FUNCTIONS_COUNT functions in $filepath."
	
	done
	
	shpm_log "--------------------------"
	shpm_log ""
	shpm_log "Found $FUNCTIONS_COUNT functions in $FILE_COUNT file(s) analysed."
	shpm_log ""
	
	shpm_log "Coverage in %:"
	SHPM_LOG_DISABLED="$FALSE"
	
	echo "$PERCENT_COVERAGE" # this is a "return" value for this function	
}

compile_sh_project() {
	
	local FILE_WITH_CAT_SH_LIBS
	local FILE_WITH_CAT_SH_SRCS
	local FILE_WITH_SEPARATOR
	local COMPILED_FILE
	
	local REGEX_INCLUDE_LIB_AND_FILE
	local REGEX_SHEBANG
	local PATTERN_INCLUDE_BOOTSTRAP_FILE
	
	FILE_WITH_CAT_SH_LIBS="$TMP_DIR_PATH/lib_files_concat"
	FILE_WITH_CAT_SH_SRCS="$TMP_DIR_PATH/sh_files_concat"
	FILE_WITH_SEPARATOR="$TMP_DIR_PATH/separator"
	
	COMPILED_FILE="$TARGET_DIR_PATH/compiled.sh"
	
	REGEX_INCLUDE_LIB_AND_FILE="^include_.+i"
	REGEX_SHEBANG="^#\!"
	PATTERN_INCLUDE_BOOTSTRAP_FILE="source ./bootstrap.sh"
	
	find "$LIB_DIR_PATH"  -type f ! -path "sh-pm*" ! -name "$DEPENDENCIES_FILENAME" -name '*.sh' -exec cat {} + > "$FILE_WITH_CAT_SH_LIBS""_tmp"
	
	grep -v "$PATTERN_INCLUDE_BOOTSTRAP_FILE" <"$FILE_WITH_CAT_SH_LIBS""_tmp" | grep -E -v "$REGEX_SHEBANG" | grep -E -v "$REGEX_INCLUDE_LIB_AND_FILE" > "$FILE_WITH_CAT_SH_LIBS"
	remove_file_if_exists "$FILE_WITH_CAT_SH_LIBS""_tmp"
	
	find "$SRC_DIR_PATH"  -type f ! -path "sh-pm*" ! -name "$DEPENDENCIES_FILENAME" -name '*.sh' -exec cat {} + > "$FILE_WITH_CAT_SH_SRCS""_tmp"
	
	grep -v "$PATTERN_INCLUDE_BOOTSTRAP_FILE" <"$FILE_WITH_CAT_SH_SRCS""_tmp" | grep -E -v "$REGEX_SHEBANG" | grep -E -v "$REGEX_INCLUDE_LIB_AND_FILE" > "$FILE_WITH_CAT_SH_SRCS"
	remove_file_if_exists "$FILE_WITH_CAT_SH_SRCS""_tmp"

	remove_file_if_exists "$COMPILED_FILE"
	
	printf "\n# ================================================================================================\n" > "$FILE_WITH_SEPARATOR"
	
	cat \
	"$FILE_WITH_SEPARATOR" "$ROOT_DIR_PATH/$BOOTSTRAP_FILENAME" \
	"$FILE_WITH_SEPARATOR" "$ROOT_DIR_PATH/$DEPENDENCIES_FILENAME"  \
	"$FILE_WITH_SEPARATOR" "$FILE_WITH_CAT_SH_LIBS" \
	"$FILE_WITH_SEPARATOR" "$FILE_WITH_CAT_SH_SRCS" \
		> "$COMPILED_FILE"
	
	sed -i '/^$/d' "$COMPILED_FILE"
	
	remove_file_if_exists "$FILE_WITH_CAT_SH_LIBS"
	remove_file_if_exists "$FILE_WITH_CAT_SH_SRCS"
	
	chmod 755 "$COMPILED_FILE"
}

run_sh_pm "$@"
