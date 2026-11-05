#!/bin/bash

for n in 1 2 3 4
do
    folder=Testcase$n
    results=${folder}Diff

    # remove results from prev runs
    rm -rf $results

    for old in $folder/*.1.txt
    do
        version=$(basename $old .1.txt)
        new=$folder/$version.2.txt

        # identical pairs need nothing, so continue
        if cmp -s $old $new
        then
            continue
        fi

        mkdir -p $results
        diff -u $old $new > $results/${version}Diff.txt
    done
done