#!/bin/sh

. ./config.sh

install() {
	# create API settings
	create_api_settings /home/${COMMON_USER_NAME} "${APIs}" "${AcceptENVs}"

	# create jail settings
	create_jail_settings

	# create common group
	create_group ${COMMON_GROUP_NAME}

	# create common user
	create_user ${COMMON_USER_NAME} ${COMMON_GROUP_NAME} ${API_KEY} "${PROJECT_NAME} root directory"
	create_jail_user ${COMMON_USER_NAME} /home/${COMMON_USER_NAME}

	# create jail directory
	create_jail_directory /home/${COMMON_USER_NAME} ${COMMON_USER_NAME} ${COMMON_GROUP_NAME}
	
	# create DB
	create_database

	# restart all related services
	service sshd restart
}

create_api_settings() {
	local root_path=${1}
	local apis="${2}"
	local envs="${3}"

	local api
	for api in ${apis}
	do
		local config=`printf "Subsystem ${api} /bin/form ${api}"`
		echo ${config} >> /etc/ssh/sshd_config
	done

	local env
	for env in ${envs}
	do
		local config=`printf "AcceptEnv ${env}"`
		echo ${config} >> /etc/ssh/sshd_config
	done
}

create_jail_settings() {
	local pam_sshd_config="session optional pam_chroot.so"
	echo ${pam_sshd_config} >> /etc/pam.d/sshd
}

create_jail_directory() {
	local root_path=${1}
	local username=${2}
	local groupname=${3}

	mkdir -p ${root_path}
	chown -R root:${groupname} ${root_path}
	chmod -R 755 ${root_path}

	local dir
	local dirlist="bin dev dev/pts etc home home/${username} lib lib64 proc tmp"
	for dir in ${dirlist}
	do
		mkdir -p ${root_path}/${dir}
	done
	chmod 555 ${root_path}/home/${username}
	chmod 777 ${root_path}/tmp

	local bin
	local binlist="/bin/bash /bin/ls /usr/bin/scp /root/shukp/form"
	for bin in ${binlist}
	do
		cp -a ${bin} ${root_path}/bin/
	done

	local lib
	local lib_1=`ldd ${binlist} | awk '{print $1}' | grep "/lib" | sort | uniq`
	local lib_2=`ldd ${binlist} | awk '{print $3}' | grep "/lib" | sort | uniq`
	for lib in ${lib_1}
	do
		cp -f ${lib} ${root_path}/lib64/
	done
	for lib in ${lib_2}
	do
		cp -f ${lib} ${root_path}/lib64/
	done

	mknod ${root_path}/dev/zero c 1 2
	chmod 666 ${root_path}/dev/zero
	mknod ${root_path}/dev/null c 1 5
	chmod 666 ${root_path}/dev/null
	mknod ${root_path}/dev/ptmx c 5 2
	chmod 666 ${root_path}/dev/ptmx
	grep "^root" /etc/passwd > ${root_path}/etc/passwd
	grep "^${username}" /etc/passwd >> ${root_path}/etc/passwd
	grep root /etc/group > ${root_path}/etc/group
	grep ${groupname} /etc/group >> ${root_path}/etc/group
	cp -f /usr/bin/groups ${root_path}/bin/
	cp -f /usr/bin/id ${root_path}/bin/
	cp -f /lib64/libnss_files.so.2 ${root_path}/lib64/
	cp -f /lib64/libnss_compat.so.2 ${root_path}/lib64/
	mount proc ${root_path}/proc -t proc
	mount devpts ${root_path}/dev/pts -t devpts
}

create_group() {
	local groupname=${1}

	groupadd -f ${groupname}
	[ $? -ne 0 ] && echo "groupadd error" && exit 1
}

create_user() {
	local username=${1}
	local groupname=${2}
	local password=${3}
	local comment=${4}

	useradd -c "${comment}" -d /home/${username} -g ${groupname} -s /bin/bash -M ${username}
	[ $? -ne 0 ] && echo "useradd error" && exit 1

	echo ${password} | passwd --stdin ${username} >/dev/null 2>&1
}

create_jail_user() {
	local username=${1}
	local root_path=${2}

	local chroot_config="${username} ${root_path}"
	echo "${chroot_config}" >> /etc/security/chroot.conf
}

create_database() {
	rm -f data.db
	sqlite3 data.db <<EOF
	CREATE TABLE source (
		id INTEGER NOT NULL PRIMARY KEY UNIQUE,
		name TEXT NOT NULL
	);
	CREATE TABLE account (
		id INTEGER,
		username TEXT NOT NULL,
		FOREIGN KEY(id) REFERENCES source(id)
	);
EOF
}

install

