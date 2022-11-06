#!/bin/bash

file_name=$1
threshold=60.0
coverage_threshold_output=go-coverage-threshold.out
coverage_percentage_output=go-coverage-percentage.out
coverage_message_output=go-coverage-message.out

# print to threshold output file
echo $threshold > ./$coverage_threshold_output

echo
echo "============================================="
echo "             GO TEST CHECKER                 "
echo "============================================="
echo

failed_test=$(grep -a "^FAIL.*\t" --text "$file_name")
failed_test_count=$(echo "$failed_test" | wc -l | xargs)

# print to percentage and message output file
printOutput () {
    echo "$1" > ./$coverage_percentage_output
    echo "$2" > ./$coverage_message_output
}

if [ "$failed_test" == "" ]
then
    failed_test_count=0
fi

if [ "$failed_test_count" -gt "0" ]
then
    msg="
    Test Failed! ($failed_test_count files)
    ==================================

    $failed_test"
    
    echo "$msg"
    echo ""

    printOutput 0 "$msg"
    exit 1
fi

zero_coverage=$(cat "$file_name" | grep -w "0.0" --text)
zero_coverage_count=$(echo "$zero_coverage" | wc -l)

if [ "$zero_coverage" == "" ]
then
    zero_coverage_count=0
fi

if [ "$zero_coverage_count" -gt "0" ]
then
    echo
    echo "WARNING: This file has zero percent coverage."
    echo "==================================================="
    echo
    echo "$zero_coverage"
    echo
fi

no_test=$(cat "$file_name" | grep -a "\[no\ test\ files\]" | grep -v cmd | grep -v mock)
no_test_count=$(echo "$no_test" | wc -l)

if [ "$no_test" == "" ]
then
    no_test_count=0
fi

if [ "$no_test_count" -gt "0" ]
then
    echo
    echo "WARNING: No Test Files."
    echo "=================================="
    echo
    echo "$no_test"
    echo
fi

percentage_max=100
percentage_avg=$(grep -i "total:" --text "$file_name" | awk '{ print $3 }' | sed 's/%//')

if [ "$percentage_avg" == "" ]
then
    percentage_avg=0
fi

echo
echo "Test Result"
echo "=================================="
echo
echo "Max Coverage:      $percentage_max%"
echo "Average Coverage:  $percentage_avg%"
echo "Threshold Coverage: $threshold%"
echo

if (( $(echo "$percentage_avg < $threshold" |bc -l) ));
then
    msg="
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!                                                        !!
    !!             WARNING: Average < $threshold%                   !!
    !!                                                        !!
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    Your repo coverage is below $threshold% (Currently $percentage_avg%).
    Please add more test case while you can."
    
    echo "$msg"
    echo ""

    printOutput $percentage_avg "$msg"
    exit 1
fi

printOutput $percentage_avg "ok"
exit 0
