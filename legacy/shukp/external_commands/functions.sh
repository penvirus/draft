#!/bin/sh

send_continue_response() {
	echo "150 Continue"
}

send_sending_response() {
	echo "151 Sending <${1}>"
}

send_ok_response() {
	echo "250 OK"
}

send_warning_response() {
	echo "251 Warning <${1}>"
}

send_request_rejected_response() {
	echo "450 Request Rejected"
}

send_bad_request_response() {
	echo "451 Bad Request"
}

send_insufficient_metadata_response() {
	echo "452 Insufficient Meta-data"
}

send_internal_error_response() {
	echo "550 Internal Error <${1}>"
}

