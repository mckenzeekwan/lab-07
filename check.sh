#!/bin/bash

status=yes

for n in 1 2 3 4
do
    folder=Testcase$n
    results=${folder}Diff
    ok=yes
    found_diff=no

    for old in $folder/*.1.txt
    do
        version=$(basename $old .1.txt)
        new=$folder/$version.2.txt
        saved=$results/${version}Diff.txt

        # no saved file for identical pairs
        if cmp -s $old $new
        then
            if [ -f $saved ]
            then
                ok=no
            fi
            continue
        fi

        found_diff=yes

        # saved file must exist for different pairs
        if [ ! -f $saved ]
        then
            ok=no
            continue
        fi

        # and match a fresh diff, ignore first 2 lines w the timestamps
        if [ "$(diff -u $old $new | tail -n +3)" != "$(tail -n +3 $saved)" ]
        then
            ok=no
        fi
    done

    # results folder should exist when nothing differed
    if [ $found_diff = no ] && [ -d $results ]
    then
        ok=no
    fi

    if [ $ok = yes ]
    then
        echo "$folder: PASS"
    else
        echo "$folder: FAIL"
        status=no
    fi
done

if [ $status = no ]
then
    exit 1
fi