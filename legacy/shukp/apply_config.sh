#!/bin/sh

. ./config.sh

common_config="common.h"

sed -i 's|#define PROJECT_NAME .*|#define PROJECT_NAME "'${PROJECT_NAME}'"|' ${common_config}
sed -i 's|#define VERSION .*|#define VERSION "'${VERSION}'"|' ${common_config}
sed -i 's|#define API_KEY .*|#define API_KEY "'${API_KEY}'"|' ${common_config}

sed -i 's|#define RAM_DIR_PATH .*|#define RAM_DIR_PATH "'${RAM_DIR_PATH}'"|' ${common_config}
sed -i 's|#define TEMP_DIR_PATH .*|#define TEMP_DIR_PATH "'${TEMP_DIR_PATH}'"|' ${common_config}
sed -i 's|#define SERVER_INSTALL_PATH .*|#define SERVER_INSTALL_PATH "'${SERVER_INSTALL_PATH}'"|' ${common_config}
sed -i 's|#define CLIENT_INSTALL_PATH .*|#define CLIENT_INSTALL_PATH "'${CLIENT_INSTALL_PATH}'"|' ${common_config}
sed -i 's|#define SERVER_LOG_PATH .*|#define SERVER_LOG_PATH "'${SERVER_LOG_PATH}'"|' ${common_config}
sed -i 's|#define EXTERNAL_COMMAND_PATH .*|#define EXTERNAL_COMMAND_PATH "'${EXTERNAL_COMMAND_PATH}'"|' ${common_config}

sed -i 's|#define COMMON_ACCOUNT_USERNAME .*|#define COMMON_ACCOUNT_USERNAME "'${COMMON_ACCOUNT_USERNAME}'"|' ${common_config}
sed -i 's|#define COMMON_ACCOUNT_PUBLIC_KEY .*|#define COMMON_ACCOUNT_PUBLIC_KEY "'"${COMMON_ACCOUNT_PUBLIC_KEY}"'"|' ${common_config}
sed -i 's|#define COMMON_ACCOUNT_PRIVATE_KEY .*|#define COMMON_ACCOUNT_PRIVATE_KEY "'"${COMMON_ACCOUNT_PRIVATE_KEY}"'"|' ${common_config}

