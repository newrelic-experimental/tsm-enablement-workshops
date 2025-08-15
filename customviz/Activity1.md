# Setting up Your New Relic Development Environment

Welcome to the New Relic Custom Visualization Workshop! In this first challenge, you'll set up your development environment and get familiar with the New Relic CLI.

## What You'll Learn
- How to verify your Node.js installation
- How to use the New Relic CLI (nr1)
- How to configure your New Relic profile

## Prerequisites Check

Your environment comes pre-configured with Node.js and the New Relic CLI. Let's verify everything is ready:

```bash
# Quick environment check
node --version && npm --version && nr1 --version
```

## Configure New Relic CLI

To create and deploy visualizations, you need to configure the New Relic CLI with your API key from your New Relic account.

### Step 1: Get Your New Relic API Key

1. **Log in to New Relic**: Go to [one.newrelic.com](https://one.newrelic.com)
2. **Access API Keys**: Click your user menu (bottom left) → **API keys**
3. **Create User Key**: Click **Create a key** → Select **User** type
4. **Copy the Key**: Name it "Workshop CLI" and copy the generated key (starts with `NRAK-`)

### Step 2: Configure Your Profile

```bash
# Add your New Relic profile (replace YOUR_API_KEY with your actual key)
nr1 profiles:add --name=workshop --api-key=YOUR_API_KEY --region=us

# Set it as default
nr1 profiles:default --name=workshop

# Verify the setup - you should see "workshop [default]"
nr1 profiles:list
```

**Important**:
- Replace `YOUR_API_KEY` with your actual API key from Step 1
- Use `--region=eu` if your New Relic account is in the EU region
- Keep your API key secure and never share it publicly

### Step 3: Final Check

```bash
# Navigate to your workspace and test CLI
cd /root/workspace
nr1 --version
```

**Pro tip**: The New Relic CLI has extensive help available. Use `nr1 --help` or `nr1 <command> --help` to explore any command.

## What's Next?

Perfect! Your development environment is ready. In the next challenge, you'll create your first New Relic visualization using the nr1 CLI. Continue with [Activity 2](Activity2.md)
