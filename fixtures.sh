#!/usr/bin/env bash

FAIL_COUNT=0

cRED(){ echo "$(tput setaf 1)$1$(tput sgr0)" ; }
cGREEN(){ echo "$(tput setaf 2)$1$(tput sgr0)" ; }
cYELLOW(){ echo "$(tput setaf 3)$1$(tput sgr0)" ; }

doPass(){
    local NAME EXPECTED ACTUAL JJ_EXIT
    NAME=$1
    EXPECTED=$2
    shift; shift;

    ACTUAL=`./jiffy-json "$@" 2>&1`
    JJ_EXIT=$?
    if [[ 0 -ne $JJ_EXIT ]]; then
        echo "$(cRED 'error') $NAME"
        echo " Command exited with code $JJ_EXIT"
        echo " $(cRED "$ACTUAL")"
    elif [[ "$ACTUAL" != "$EXPECTED" ]]; then
        echo "$(cRED 'fail ') $NAME"
        echo " Expected: $(cYELLOW "$EXPECTED")"
        echo " Actual  : $(cRED "$ACTUAL")"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    else
        echo "$(cGREEN 'ok   ') $NAME"
    fi
}

doFail(){
    local EXPECTED_ERROR JJ_OUT JJ_EXIT
    EXPECTED_ERROR=$1
    shift;

    ACTUAL=$(./jiffy-json "${@}" 2>&1)
    JJ_EXIT=$?

    if [[ 0 -eq $JJ_EXIT ]]; then
        echo "$(cRED 'error') $EXPECTED_ERROR"
        echo " Expected error but command completed"
        echo " Result: `tput setaf 1`$ACTUAL`tput sgr0`"
    elif [[ "$ACTUAL" != "Error: ${EXPECTED_ERROR}"* ]]; then
        echo "$(cRED 'fail ') $EXPECTED_ERROR"
        echo " Received incorrect error message"
        echo " $(cRED "$ACTUAL")"
    else
        echo "$(cGREEN 'ok   ') $EXPECTED_ERROR"
    fi
}

report_test_status(){
    if [[ $FAIL_COUNT -eq 0 ]]; then
        echo "### All Tests Pass ###"
    else
        echo "### $FAIL_COUNT tests failed ###"
        exit 1
    fi
}