#!/bin/sh

. ./config.sh

uninstall() {
	# remove ALL existing users in DB
	{
		if [ -e data.db ]; then
			local usernames=`sqlite3 data.db "SELECT username FROM account"`
			local username
			for username in $usernames
			do
				destroy_user ${username}
				destroy_jail_user ${username} /home/${COMMON_USER_NAME}/home/${username}
				rm -f ${username}_id_rsa
			done
		fi
	}

	# remove DB
	rm -f data.db

	# remove common user
	destroy_user ${COMMON_USER_NAME}
	destroy_jail_user ${COMMON_USER_NAME} /home/${COMMON_USER_NAME}

	# remove common group
	destroy_group ${COMMON_GROUP_NAME}

	# remove jail directory
	destroy_jail_directory /home/${COMMON_USER_NAME}

	# remove jail settings
	destroy_jail_settings

	# remove API settings
	destroy_api_settings /home/${COMMON_USER_NAME} "${APIs}" "${AcceptENVs}"

	# restart all related services
	service sshd restart
}

destroy_group() {
	local groupname=${1}

	if [ -n "$(grep ${groupname} /etc/group)" ]; then
		groupdel ${groupname} >/dev/null 2>&1
		[ $? -ne 0 ] && echo "groupdel error" && exit 1
	fi
}

destroy_user() {
	local username=${1}

	if [ -n "$(grep ${username} /etc/passwd)" ]; then
		userdel -r "${username}" >/dev/null 2>&1
		[ $? -ne 0 -a $? -ne 12 ] && echo "userdel error" && exit 1
	fi
}

destroy_jail_directory() {
	local root_path=${1}

	if [ -n "$(grep ${root_path}/proc /etc/mtab)" ]; then
		umount ${root_path}/proc
	fi
	if [ -n "$(grep ${root_path}/dev/pts /etc/mtab)" ]; then
		umount ${root_path}/dev/pts
	fi

	rm -rf ${root_path}
}

destroy_jail_user() {
	local username=${1}
	local root_path=${2}

	local chroot_config="${username} ${root_path}"
	sed -i "\\#${chroot_config}#d" /etc/security/chroot.conf
}

destroy_jail_settings() {
	local pam_sshd_config="session optional pam_chroot.so"
	sed -i "\\#${pam_sshd_config}#d" /etc/pam.d/sshd
}

destroy_api_settings() {
	local root_path=${1}
	local apis="${2}"
	local envs="${3}"

	local api
	for api in ${apis}
	do
		local config=`printf "Subsystem ${api} /bin/form ${api}"`
		sed -i "\\#${config}#d" /etc/ssh/sshd_config
	done

	local env
	for env in ${envs}
	do
		local config=`printf "AcceptEnv ${env}"`
		sed -i "\\#${config}#d" /etc/ssh/sshd_config
	done
}

uninstall

