#!/bin/bash

. ./utility.sh
. ./core.sh

username=${SHUKP_USERNAME}
source_id=${SHUKP_SOURCE_ID}
source_name=${SHUKP_SOURCE_NAME}

if [ -z "${username}" -o -z "${source_id}" -o -z "${source_name}" ]; then
	get_error_message "#define SHUKP_501"
	exit 1
fi

is_empty=`sqlite3 data.db "SELECT id FROM source WHERE id=${source_id}"`
if [ -z "${is_empty}" ]; then
	sqlite3 data.db "INSERT INTO source (id,name) VALUES ('${source_id}','${source_name}')"
	sqlite3 data.db "INSERT INTO account (id,username) VALUES ('${source_id}','${username}')"

	useradd -c ${source_name} -d /home/shukp/home/shukp/${username} -g shukp_group -s /bin/bash ${username}
	ssh-keygen -q -N '' -f ${username}_id_rsa
	mkdir -p /home/shukp/home/shukp/${username}/.ssh
	mv ${username}_id_rsa.pub /home/shukp/home/shukp/${username}/.ssh/authorized_keys
#	create_jail /home/shukp/home/${username} ${username} shukp_group
	chroot_config="${username} /home/shukp/home/${username}"
	if [ -z "$(grep "${chroot_config}" /etc/security/chroot.conf)" ]; then
		echo ${chroot_config} >> /etc/security/chroot.conf
	fi
	service sshd restart
else
	get_error_message "#define SHUKP_207"
fi

