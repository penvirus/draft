#!/bin/sh

if [ $# -lt 1 ]; then
	echo "Usage: $0 [launch program] [files or directories]..."
	exit 0
fi

launch_program=$1
installer_script=${launch_program}.run
outter_archive_sha1=`tar zcf - $* | sha1sum | awk '{print $1}'`

cat > $installer_script <<EOF
#!/bin/sh

# integrity test
inner_archive_sha1="\$(sed -e '1,/^###### mkinstaller end ######$/d' \$0 | sha1sum | awk '{print \$1}')"
if [ "${outter_archive_sha1}" != "\${inner_archive_sha1}" ]; then
	echo "File corrupted."
	exit 1
fi

# extract
working_directory=\$(openssl rand -hex 32 2>/dev/null)
mkdir -p \${working_directory}
sed -e '1,/^###### mkinstaller end ######$/d' \$0 | tar zxf - -C \${working_directory}

# execute launch program
cd \${working_directory}
chmod a+x ${launch_program}
./${launch_program}
cd ..

rm -rf \${working_directory}
exit 0

###### mkinstaller end ######
EOF

tar zcf - $* >> $installer_script
chmod a+x $installer_script

