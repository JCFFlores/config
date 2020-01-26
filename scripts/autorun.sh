#!/bin/dash

run() {
    if ! pgrep -f "$1" ;
    then
        $@&
    fi
}

run cbatticon
run dropbox
run light-locker
