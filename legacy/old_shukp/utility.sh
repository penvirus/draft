#!/bin/sh

get_error_message() {
	index="${1}"
	grep "${index}" shukp.h | cut -d' ' -f3- | sed 's/"//g'
}

