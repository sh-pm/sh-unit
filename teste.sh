#!/bin/bash

create_new_remote_branch_from_master_branch() {
	local ACTUAL_BRANCH
	local MASTER_BRANCH
	local NEW_BRANCH
	local GIT_CMD

	NEW_BRANCH=$1

	if [[ "$NEW_BRANCH" != "" ]]; then
		GIT_CMD=$( which git )

		ACTUAL_BRANCH=$( $GIT_CMD rev-parse --abbrev-ref HEAD | xargs )

		echo "---> $ACTUAL_BRANCH"

		if [[ "$ACTUAL_BRANCH" != "master" && "$ACTUAL_BRANCH" != "main" ]]; then
			MASTER_BRANCH=$( $GIT_CMD branch | grep "master\|main" | xargs )
			echo "---> $MASTER_BRANCH"
			$GIT_CMD checkout $MASTER_BRANCH 
		fi

		git checkout -b $NEW_BRANCH

		git push -u origin $NEW_BRANCH
	fi
}


create_new_remote_branch_from_master_branch $@
