use 'shukp' as username and API key(upper case) as password login for administration

    register
		SHUKP_USERNAME
		SHUKP_SOURCE_ID
		SHUKP_SOURCE_NAME
    get_identity_file (scp)
		SHUKP_USERNAME
    unregister*
		SHUKP_USERNAME


use registered username and login key for uploading samples and getting reports

    upload_sample (scp)
	filename format: [SHA1]_[filesize].tgz or [SHA1]_[filesize].zip
    get_report
	SHUKP_SHA1
    get_brief_report
	SHUKP_SHA1S

*argument
*permission
    chroot
    cannot allow scp for shukp
*key length
	dsa, rsa
*expiration
*share objects
