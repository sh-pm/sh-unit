#!/bin/bash

source ../../../bootstrap.sh

string_start_with(){
	STRING=$1
	SUBSTRING=$2
	if [[ $STRING == "$SUBSTRING"* ]]; then
		return 0;
	else
		return 1;
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