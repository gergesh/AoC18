#!/usr/bin/env bash
# I know the extension is .sh, but no way in hell I'm doing brainfuck.
# This also takes forever to run, debug it on your own if you feel like it.
# A similar (algorithmically) python solution runs instantly.

function ctTwoThree() { # receives a string and a number, does stuff
    word="$1"
    f2=0
    f3=0
    len=${#1}
    for i in $(seq 0 $len); do
        ct=0
        for j in $(seq 0 $len); do
            if [ "${word:i:1}" == "${word:j:1}" ]; then
                ((ct++))
            fi
        done
        if [[ $ct -eq 2 ]]; then
            f2=1
        elif [[ $ct -eq 3 ]]; then
            f3=1
        fi

        if [[ $f2 -eq 1 && $f3 -eq 1 ]]; then
            echo "11"
            return
        fi
    done
    echo "$f2$f3"
}

function goodDist() { # receives two strings, returns 1 if the distance is 1, 0 otherwise.
    len=${#1}
    w1="$1"
    w2="$2"
    diff=0
    for x in $(seq 0 $len); do
        if [ "${w1:x:1}" != "${w2:x:1}" ]; then
            if [ $diff -eq 1 ]; then
                echo 0
                return
            fi
            diff=1
        fi
    done
    echo "$diff"
}

function printCommon() {
    len=${#1}
    w1="$1"
    w2="$2"
    diff=0
    for x in $(seq 0 $len); do
        if [ "${w1:x:1}" == "${w2:x:1}" ]; then
            echo -n "${w1:x:1}"
        fi
    done
    echo
}

twos=0
threes=0
line=0
foundsimilar=0
IFS=$'\n'
for i in `cat "$1"`; do
    ans=$(ctTwoThree $i)
    ((twos+="${ans:0:1}"))
    ((threes+="${ans:1:1}"))
    if [ $foundsimilar -eq 0 ]; then
        for j in `cat "$1" | head -n "$line"`; do
            if [ $(goodDist $i $j) == "1" ]; then
                printCommon "$i" "$j"
                foundsimilar=1
                break
            fi
        done
    fi
    ((line++))
done
echo "$(($twos * $threes))"
