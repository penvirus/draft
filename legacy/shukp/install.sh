#!/bin/sh

. ./config.sh

install() {
	if [ -n "$(grep -e "^${COMMON_ACCOUNT_USERNAME}:" /etc/passwd)" ]; then
		echo "already installed"
		exit 1
	fi

	useradd -M ${COMMON_ACCOUNT_USERNAME}
	mkdir -p /home/${COMMON_ACCOUNT_USERNAME}
	chmod 755 /home/${COMMON_ACCOUNT_USERNAME}
	mkdir -p /home/${COMMON_ACCOUNT_USERNAME}/.ssh
	echo "$COMMON_ACCOUNT_PUBLIC_KEY" >> /home/${COMMON_ACCOUNT_USERNAME}/.ssh/authorized_keys
	chmod 700 /home/${COMMON_ACCOUNT_USERNAME}/.ssh/authorized_keys
	chown -R ${COMMON_ACCOUNT_USERNAME}:${COMMON_ACCOUNT_USERNAME} /home/${COMMON_ACCOUNT_USERNAME}

	# lock this account and only allow it login by key
	passwd -l ${COMMON_ACCOUNT_USERNAME}

	make

	mkdir -p `dirname ${SERVER_INSTALL_PATH}`
	cp server "${SERVER_INSTALL_PATH}"

	mkdir -p `dirname ${CLIENT_INSTALL_PATH}`
	cp client "${CLIENT_INSTALL_PATH}"

	mkdir -p `dirname ${EXTERNAL_COMMAND_PATH}`
	cp -r external_commands/ ${EXTERNAL_COMMAND_PATH}

	# special case
	cp register ${EXTERNAL_COMMAND_PATH}/
	chown root:${COMMON_ACCOUNT_USERNAME} ${EXTERNAL_COMMAND_PATH}/register
	chmod 4750 ${EXTERNAL_COMMAND_PATH}/register 
}

deinstall() {
	if [ -z "$(grep -e "^${COMMON_ACCOUNT_USERNAME}:" /etc/passwd)" ]; then
		echo "did not install yet"
		exit 1
	fi

	userdel -r ${COMMON_ACCOUNT_USERNAME}
	rm -f ${SERVER_INSTALL_PATH}
	rm -f ${CLIENT_INSTALL_PATH}
	rm -f ${SERVER_LOG_PATH}
	rm -rf ${EXTERNAL_COMMAND_PATH}
}

reinstall() {
	deinstall
	install
}

usage() {
	echo "Usage: $0 [install | deinstall | reinstall]"
	exit 1
}

if [ -z $1 ]; then
	usage
fi

case $1 in
	install) install ;;
	deinstall) deinstall ;;
	reinstall) reinstall ;;
	*) usage ;;
esac

