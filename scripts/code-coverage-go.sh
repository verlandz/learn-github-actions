#!/bin/bash

# var
threshold=60.0
start_date="$(date -I seconds)"
start_date_seconds="$(date +%s)"
profile_output=code-coverage-go-profile.out
data_output=code-coverage-go-data.out
threshold_output=code-coverage-go-threshold.out
percentage_output=code-coverage-go-percentage.out
message_output=code-coverage-go-message.out

# clear the output
cat /dev/null > ./$profile_output
cat /dev/null > ./$data_output
cat /dev/null > ./$threshold_output
cat /dev/null > ./$percentage_output
cat /dev/null > ./$message_output

# print to threshold output file
echo $threshold > ./$threshold_output

doCoverage () {
    # run test
    go test -v -race -covermode=atomic -coverprofile=./$profile_output $(go list ./... | grep -v /tests | grep -v /vendor/ | grep -v /mocks) -ldflags "-X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=warn"
    echo -e "\n"

    # run coverage
    if [ -f $profile_output ]; then
        go tool cover -func=$profile_output
    fi
}

doCoverage | tee ./$data_output

failed_test=$(grep -a "^FAIL.*\t" --text "$data_output")
failed_test_count=$(echo "$failed_test" | wc -l | xargs)

# print to percentage and message output file
printOutput () {
    echo "$1" > ./$percentage_output
    echo "$2" > ./$message_output

    end_date="$(date -I seconds)"
    end_date_seconds="$(date +%s)"
    elapsed_seconds="$(($end_date_seconds-$start_date_seconds))"

    echo
    echo "============================================="
    echo "          GO TEST COVERAGE REPORT            "
    echo "============================================="
    echo -e "Start Date:\t$start_date"
    echo -e "End Date:\t$end_date"
    echo -e "Elapsed:\t$elapsed_seconds s"
    echo -e "Go Version:\t$(go version)"
    echo -e "GoTool Version:\t$(go tool cover -V)"
    echo -e "Threshold:\t$threshold%"
    echo -e "Data Output:\t$data_output"
    echo -e "% Output:\t$percentage_output"
    echo

    if [ "$3" == "0" ]
    then
        echo "Result: PASS"
        exit 0
    else
        echo "Result: NOT PASS"
        exit 1
    fi
}

# check: failed test

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

    printOutput 0 "$msg" 1
fi

# check: zero coverage

zero_coverage=$(cat "$data_output" | grep -w "0.0" --text)
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

# check: no test files

no_test=$(cat "$data_output" | grep -a "\[no\ test\ files\]" | grep -v cmd | grep -v mock)
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

# check: check threshold

percentage_max=100
percentage_avg=$(grep -i "total:" --text "$data_output" | awk '{ print $3 }' | sed 's/%//')

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

    printOutput $percentage_avg "$msg" 1
fi

printOutput $percentage_avg "ok" 0
