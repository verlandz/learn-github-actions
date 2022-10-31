#!/usr/bin/env bash

projectpath=$1
projectpath="$1"
if [ -z "$projectpath" ] 
then
    echo "Please set \$projectpath for example . , ../ , \$GOPATH/src/github.com/tokopedia/mojito-ranker"
    exit 1;
fi

# Check gofmt
echo "Checking that code complies with gofmt requirements..."
echo "if its to long maybe you set wrong path"
gofmt_files=$(gofmt -l `find ${projectpath} -name '*.go' | grep -v vendor`)
if [[ -n ${gofmt_files} ]]; then
    echo 'gofmt needs running on the following files:'
    echo "${gofmt_files}"
    echo "You can use the command: \`make fmt\` to reformat code."
    exit 1
fi

exit 0
