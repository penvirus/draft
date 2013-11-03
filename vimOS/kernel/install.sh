#!/bin/sh
#
# Arguments:
#   $1 - kernel version
#   $2 - kernel image file
#   $3 - kernel map file
#   $4 - default install path (blank if root directory)
#

verify () {
	if [ ! -f "$1" ]; then
		echo ""                                                   1>&2
		echo " *** Missing file: $1"                              1>&2
		echo ' *** You need to run "make" before "make install".' 1>&2
		echo ""                                                   1>&2
		exit 1
 	fi
}

# Make sure the files actually exist
verify "$2"
verify "$3"

install -D -m 644 $2 $4/vmlinuz-$1
install -D -m 644 $3 $4/System.map-$1
ln -sf vmlinuz-$1    $4/vmlinuz
ln -sf System.map-$1 $4/System.map

