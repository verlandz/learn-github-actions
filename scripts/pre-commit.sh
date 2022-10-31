#!/bin/bash
goFiles=$(git diff --cached --name-only --diff-filter=ACM | grep '\.go$')
[[ -z "$goFiles" ]] && exit 0

unformatted=$(gofmt -l ${goFiles})
if [[ -n "$unformatted" ]];
then
    printf "!!! Needs formatting !!!\n$unformatted\n"
    exit 2
fi

# build
printf "### Build... ###\n"
go build -o /dev/null ./...
if [[ $? -ne 0 ]];
then
    printf "!!! Build failed !!!\n"
    exit 3
fi

# tests
printf "### Tests... ###\n"
srcFolders=$( go list ./... | grep -v vendor/ )
testTmp=$( mktemp )
go test -v -race -cover ${srcFolders} > ${testTmp}

if [[ $? -ne 0 ]];
then
    cat ${testTmp} | grep --text FAIL
    rm -f ${testTmp}
    printf "!!! Test failed !!!\n"
    exit 1
fi
rm -f ${testTmp}
printf "### ...Done ###\n"
exit 0
