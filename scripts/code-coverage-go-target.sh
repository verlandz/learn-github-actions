#!/bin/bash

# var
old_ifs=$IFS
threshold=60.0
start_date="$(date)"
start_date_seconds="$(date +%s)"
target_path="dummy-module/"
data_output=code-coverage-go-target-data.out
result_output=code-coverage-go-target-result.out
threshold_output=code-coverage-go-target-threshold.out

# define base branch
base_branch="main"
if [ "$1" != "" ]
then
    base_branch=$1
fi

# clear the output
cat /dev/null > ./$data_output
cat /dev/null > ./$result_output
cat /dev/null > ./$threshold_output

# print to threshold output file
echo $threshold > ./$threshold_output

# fetch $base_branch
if !(res=$(git fetch origin $base_branch 2>&1))
then
    echo "Unknown base_branch: $base_branch !"
    exit 1
fi

# get diff between $base_branch and $head_branch
files=$(git diff --name-status origin/$base_branch | grep $target_path | awk '$1 != "D" {print $NF}')
for file in $files
do
    # IFS (Input Field Separator)
    # must put in here to avoid $files being affected
    IFS='/'

    read -ra arr <<< "$file"
    if [ "${#arr[@]}" -gt "2" ]
    then
        echo "${arr[1]}" >> $data_output
    fi
done

IFS=$old_ifs # revert IFS
is_pass=true

# get diff between $base_branch and $head_branch
uniq_modules=$(cat $data_output | sort | uniq)
for uniq_module in $uniq_modules
do
    res="PASS"
    coverage=0.00
    
    if files=$(go test -race -covermode=atomic "$PWD/$target_path$uniq_module" 2>&1)
    then
        echo $files > files.tmp
        coverage=$(cat files.tmp | grep "coverage:" | awk '{print $(NF-2)}' | tr -d "%")
        rm files.tmp

        # check if coverage is below 0 or not valid value
        if [[ $(echo "$coverage > 0.00" | bc) != 1 ]]
        then
            coverage=0.00
        fi
    else
        echo -n "::error:: $files"
    fi

    # check pass/not pass
    if [[ $(echo "$coverage >= $threshold" | bc) != 1 ]]
    then
        res="NOT PASS"
        is_pass=false
    fi

    echo -e "$uniq_module\\t$coverage%\\t$res" >> ./$result_output
done

end_date="$(date)"
end_date_seconds="$(date +%s)"
elapsed_seconds="$(($end_date_seconds-$start_date_seconds))"

echo
echo "============================================="
echo "          GO TEST COVERAGE REPORT            "
echo "============================================="
echo -e "Base Branch:\t$base_branch"
echo -e "Start Date:\t$start_date"
echo -e "End Date:\t$end_date"
echo -e "Elapsed:\t$elapsed_seconds s"
echo -e "Go Version:\t$(go version)"
echo -e "Target Path:\t$target_path"
echo -e "Threshold:\t$threshold%"
echo -e "Data Output:\t$data_output"
echo -e "Result Output:\t$result_output"
echo
echo "============================================="
echo -e "Module\tCov\tStatus"
echo "============================================="
cat $result_output
echo

if $is_pass
then
    echo "Result: PASS"
    exit 0
else
    echo "Result: NOT PASS"
    exit 1
fi
