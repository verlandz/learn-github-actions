### Issue
I need to use specific tools but can't download via sudo due restricted access from runner's owner.

### Solution
#### A. Docker
You can build docker inside the runner and create your own environment then run the script.

#### B. Download via non-sudo
For example, we will use `wget` to download `bc` and extract it.
```
- name: Setup custom tools
  env:
    CUSTOM_TOOLS_PATH: custom_tools
  run: |
    mkdir -p $CUSTOM_TOOLS_PATH
    # bc (basic calculator)
    wget http://archive.ubuntu.com/ubuntu/pool/main/b/bc/bc_1.07.1-2build1_amd64.deb
    dpkg -x bc_1.07.1-2build1_amd64.deb $CUSTOM_TOOLS_PATH
    echo "$PWD/$CUSTOM_TOOLS_PATH/usr/bin" >> $GITHUB_PATH
```