### Issue
How to enable the bot to work under *Private Organization (SSO)* ?

### Solution
1. Invite the bot into organization
2. Authorize the PAT with organization
3. Add this script in the beginning of steps for needed job(s), example:
```
- name: Configure private git
  env:
    BOT_NAME: verlandz-bot
    BOT_PAT: ${{ secrets.BOT_PAT }}
  run: git config --global url."https://$BOT_NAME:$BOT_PAT@github.com".insteadOf "https://github.com"
```

> **Note**\
This is HTTP style. You can also use SSH style or others.\
Please readjust according to your needs