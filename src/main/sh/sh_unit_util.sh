#!/bin/bash

source ../../../bootstrap.sh

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