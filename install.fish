#!/usr/bin/env fish

set REPOS_FILE repositories
set LINKS_FILE links

function create_link
    if test -f $argv[2] ;or test -L $argv[2]
        rm -vf $argv[2]
    end
    ln -sv $argv
end

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

for line in (cat $LINKS_FILE)
    set link (replace_with_home $line | string split ' ')
    create_link $link
end

