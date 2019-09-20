#!/bin/bash

chk_cmd()
{
    hash $1 2>/dev/null
    [[ $? -ne 0 ]] && echo "[$1] cmd needed." && exit 2
}

function get_cmd_etime()
{
    CMD_ETIME=`ps -heo etime -q $CMDPID`
    CMD_ETIME=`echo $CMD_ETIME`
}

function set_make_dir()
{
    CMD="make"
    SECONDS=0
    while [ 1 ]; do
        CMDPID=`pgrep -u $USER -xo $CMD | tail -1`
        [[ "$CMDPID" != "" ]] && break
        printf "No $CMD in progress. ${SECONDS}sec\r"
        sleep 1
    done
    folder=`pwdx $CMDPID`
    [[ "$folder" == "" ]] && echo "Cudnot switch to $CMD dir [$folder]"
    folder=${folder/* /}
    [[ ! -d "$folder" ]] && echo "Could not find dir [$folder]"
    get_cmd_etime
    echo "Switching to active $CMD dir: [$folder]"
    echo "$CMD already active since: [$CMD_ETIME] time"
    cd $folder
}

function parse_args()
{
    chk_cmd pwdx
    chk_cmd pgrep
    set_make_dir
}

function get_pending_work()
{
    pending=`make -j$(nproc) -nk 2>/dev/null | grep -w "ar\|libtool\|ld\|g++\|gcc\|cc\|c++\|cpp" | wc -l`
}

function poll_execution()
{
    SECONDS=0
    cnt=3
    while [ 1 ]; do
        ps $CMDPID >/dev/null
        [[ $? -ne 0 ]] && break
        get_pending_work
        if [ $pending -le 0 ]; then
            let cnt=$cnt-1
            [[ $cnt -le 0 ]] && break
        else
            cnt=3
        fi
        get_cmd_etime
        printf "Pending: $pending work items. $CMD active for $CMD_ETIME time.%20s\r" " "
        sleep 1
    done
    printf "\rDONE. Took ${SECONDS}sec %20s\n" " "
}

parse_args $*
poll_execution
