#!/bin/sh

root=$1

for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
	cp -uv $file{,.orig}
	sed -e 's@/lib\(64\)\?\(32\)\?/ld@'$root'/usr/&@g' \
		-e 's@/usr/include@'$root'/usr/include@g' $file.orig > $file
	echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "'$root'/usr/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
	touch $file.orig
done
