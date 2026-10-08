#!/bin/sh
#

# If command starts with an option, prepend storvia.
# Also accept legacy "minio" as the command name for backwards compatibility.
if [ "${1}" != "storvia" ] && [ "${1}" != "minio" ]; then
	if [ -n "${1}" ]; then
		set -- storvia "$@"
	fi
fi

# Normalize legacy "minio" invocation to "storvia".
if [ "${1}" = "minio" ]; then
	shift
	set -- storvia "$@"
fi

docker_switch_user() {
	if [ -n "${MINIO_USERNAME}" ] && [ -n "${MINIO_GROUPNAME}" ]; then
		if [ -n "${MINIO_UID}" ] && [ -n "${MINIO_GID}" ]; then
			chroot --userspec=${MINIO_UID}:${MINIO_GID} / "$@"
		else
			echo "${MINIO_USERNAME}:x:1000:1000:${MINIO_USERNAME}:/:/sbin/nologin" >>/etc/passwd
			echo "${MINIO_GROUPNAME}:x:1000" >>/etc/group
			chroot --userspec=${MINIO_USERNAME}:${MINIO_GROUPNAME} / "$@"
		fi
	else
		exec "$@"
	fi
}

## DEPRECATED and unsupported - switch to user if applicable.
docker_switch_user "$@"
