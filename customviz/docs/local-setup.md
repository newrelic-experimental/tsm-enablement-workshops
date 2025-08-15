# Local Development Setup

If you prefer to run the workshop locally instead of using GitHub Codespaces, follow this setup guide.

## Prerequisites

- **Node.js 20 LTS**: [Download from nodejs.org](https://nodejs.org/)
- **Git**: [Download from git-scm.com](https://git-scm.com/)
- **New Relic Account**: [Sign up for free](https://newrelic.com/signup)

## Setup Steps

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/customvizworkshop.git
cd customvizworkshop
```

### 2. Install New Relic CLI

**macOS (Homebrew):**
```bash
brew install newrelic-cli
```

**Linux/macOS (Direct Install):**
```bash
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash
```

**Windows:**
```powershell
# Download and run the Windows installer from:
# https://github.com/newrelic/newrelic-cli/releases
```

### 3. Configure Authentication
```bash
nr1 profiles:add --name default --api-key YOUR_USER_API_KEY --region US
```

Get your User API Key from: https://one.newrelic.com/launcher/api-keys-ui.api-keys-launcher

### 4. Verify Installation
```bash
nr1 version
node --version  # Should be v20.x.x
npm --version
```

## Development Workflow

1. **Create a visualization:**
   ```bash
   nr1 create --type nerdpack --name my-viz
   cd my-viz
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start development server:**
   ```bash
   nr1 nerdpack:serve
   ```

4. **Access at:** http://localhost:3000

## Troubleshooting

**Command not found: nr1**
- Ensure the New Relic CLI is properly installed and in your PATH
- Try restarting your terminal

**Authentication errors**
- Verify your User API Key is correct
- Check that you're using the right region (US vs EU)

**Port conflicts**
- The development server uses port 3000 by default
- If occupied, it will automatically try the next available port

## Ready to Start?

Once your local environment is set up, continue to [Assignment 1: Getting Started](../01-getting-started/README.md)!
