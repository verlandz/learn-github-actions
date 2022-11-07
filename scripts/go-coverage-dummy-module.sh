#!/bin/bash

# var
old_ifs=$IFS
threshold=60.0
target_path="dummy-module/"
coverage_dummy_module_data_output=go-coverage-dummy-module-data.out
coverage_dummy_module_result_output=go-coverage-dummy-module-result.out
coverage_dummy_module_threshold_output=go-coverage-dummy-module-threshold.out

# clear the output
cat /dev/null > ./$coverage_dummy_module_data_output
cat /dev/null > ./$coverage_dummy_module_result_output

# print to threshold output file
echo $threshold > ./$coverage_dummy_module_threshold_output

git fetch origin main
files=$(git diff --name-status origin/main | grep $target_path | awk '$1 != "D" {print $NF}')
for file in $files
do
    # IFS (Input Field Separator)
    # must put in here to avoid $files being affected
    IFS='/'

    read -ra arr <<< "$file"
    if [ "${#arr[@]}" -gt "2" ]
    then
        echo "${arr[1]}" >> $coverage_dummy_module_data_output
    fi
done

IFS=$old_ifs # revert IFS
is_pass=true

uniq_modules=$(cat $coverage_dummy_module_data_output | sort | uniq)
for uniq_module in $uniq_modules
do
    res="PASS"
    coverage=$(go test -race -covermode=atomic "$PWD/$target_path$uniq_module" | grep "coverage:" | awk '{print $(NF-2)}' | tr -d "%")

    # check if coverage is below 0 or not valid value
    if [[ $(echo "$coverage > 0" | bc) != 1 ]]
    then
        echo " \_ $uniq_module"
        coverage=0.00
    fi

    # check pass/not pass
    if [[ $(echo "$coverage >= $threshold" | bc) != 1 ]]
    then
        res="NOT PASS"
        is_pass=false
    fi

    echo -e "$uniq_module\\t$coverage%\\t$res" >> ./$coverage_dummy_module_result_output
done

echo
echo "============================================="
echo "          GO TEST COVERAGE REPORT            "
echo "============================================="
echo -e "Date:\t\t$(date)"
echo -e "Go Version:\t$(go version)"
echo -e "Target Path:\t$target_path"
echo -e "Threshold:\t$threshold%"
echo -e "Data Output:\t$coverage_dummy_module_data_output"
echo -e "Result Output:\t$coverage_dummy_module_result_output"
echo
echo "============================================="
echo -e "Module\tCov\tStatus"
echo "============================================="
cat $coverage_dummy_module_result_output
echo

if $is_pass
then
    echo "Result: PASS"
    exit 0
else
    echo "Result: NOT PASS"
    exit 1
fi
