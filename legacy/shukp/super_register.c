#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "common.h"

int main(int argc, char ** argv) {
	char buf[40960];

	setuid(0);

	snprintf(buf, 40960, "%s/__real_register", EXTERNAL_COMMAND_PATH);
	system(buf);

	return 0;
}

