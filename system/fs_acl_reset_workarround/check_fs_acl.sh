#!/bin/sh
#ACL_HOSTS="10.21.7.30 217.12.247.214 217.12.247.215"

function check_acl_host() {
    local ACL_HOST=$1
    local RC
    RESULT=$(fs_cli -x "acl $ACL_HOST trusted" 2> /dev/null)
    RC=$?
    if [ $RC -ne 0 ]; then
        echo "Cannot get FreeSwitch ACL status for host $ACL_HOST"
        exit $RC
    fi
    if [ -z "$RESULT" -o "$RESULT" == "false" ]; then
        echo "Host $ACL_HOST is not in trusted ACL"
        reload_acl
#        exit $RC
    fi
    return 0
}

function reload_acl() {
    echo Reloading acl
    fs_cli -x "reloadacl" 2> /dev/null
}

for ACL_HOST in $ACL_HOSTS; do
    check_acl_host $ACL_HOST
done

exit 0
