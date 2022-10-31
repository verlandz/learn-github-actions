#!/bin/bash

# var
coverage_output=coverage.out
coverage_result_output=coverage-result.out

# clear the output
cat /dev/null > ./$coverage_output
cat /dev/null > ./$coverage_result_output

doCoverage () {
    # description
    echo "> Golang Test Coverage"
    echo "| Go Version: $(go version)"
    echo "| Date: $(date)"
    echo "| Coverage Output: $coverage_output"
    echo "| Coverage Result Output: $coverage_result_output"
    echo

    # run test
    echo "> Run Test"
    go test -v -race -covermode=atomic -coverprofile=./$coverage_output $(go list ./... | grep -v /tests | grep -v /vendor/ | grep -v /mocks) -ldflags "-X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=warn"
    echo

    # run coverage
    echo "> Run Coverage"
    echo "| Go Tool Version: $(go tool cover -V)"
    if [ -f $coverage_output ]; then
        go tool cover -func=$coverage_output
    fi
}

# execute
doCoverage | tee ./$coverage_result_output && bash ./scripts/test-checker.sh ./$coverage_result_output