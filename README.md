# Learn Github Actions

> GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline. You can create workflows that build and test every pull request to your repository, or deploy merged pull requests to production.
> 
> \- from [Official Docs](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)

## Documentation
- [Official Docs](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)
- [Personal Docs](TBA)

## Note
- This repo will be in private (mainly) and public (sometimes) due billing limitations. 
- If the bot (verlandz-bot) need to work under SSO / private organization then you need to:
    - Invite the bot into organization
    - Authorize the PAT with organization
    - Add this step in the beginning of the steps for needed job(s).
    This is HTTP style. You can also use SSH style (need PoC).
        ```
        - name: Configure private git
          env:
            BOT_NAME: verlandz-bot
            BOT_PAT: ${{ secrets.BOT_PAT }}
          run: git config --global url."https://$BOT_NAME:$BOT_PAT@github.com".insteadOf "https://github.com"
        ```
