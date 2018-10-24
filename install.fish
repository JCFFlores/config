#!/usr/bin/env fish

set REPOS_FILE repositories

function download_repo
    if not test -d $argv[2]
        git clone $argv[1] $argv[2]
        if test -n $argv[3]
            git -C $argv[2] checkout $argv[3]
        end
    end
end

function replace_with_home
    echo $argv | sed -e "s@~@$HOME@g"
end

for line in (cat $REPOS_FILE)
    set repo (replace_with_home $line | string split ' ')
    download_repo $repo
end

