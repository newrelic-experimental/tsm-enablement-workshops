# Activity 1: Setting up Your New Relic Development Environment

## What You Will Learn
- How to verify your Node.js, npm, and New Relic CLI installation
- How to configure your New Relic CLI profile
- How to test your CLI setup

## Exercises

### 1. Verify Prerequisites
```bash
node --version
npm --version
nr1 --version
```

### 2. Configure New Relic CLI
Get your API key from your New Relic account, then run:
```bash
nr1 profiles:add --name=workshop --api-key=YOUR_API_KEY --region=us
nr1 profiles:default --name=workshop
nr1 profiles:list
```
Replace `YOUR_API_KEY` with your actual key. Use `--region=eu` if needed.

### 3. Test CLI Setup
```bash
nr1 --version
```

## What You Learned
- You verified your environment is ready for New Relic development
- You configured and tested the New Relic CLI

## Continue to Next Activity
Continue with [Activity 2](Activity2.md)
