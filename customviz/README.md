# New Relic Custom Visualization Workshop

[![GitHub Codespaces](https://img.shields.io/badge/platform-GitHub%20Codespaces-blue)](https://github.com/features/codespaces)
[![New Relic](https://img.shields.io/badge/platform-New%20Relic-green)](https://newrelic.com)
[![Instruqt](https://img.shields.io/badge/legacy-Instruqt-lightgrey)](./instruqt/)

A comprehensive hands-on workshop that teaches developers how to build custom visualizations for New Relic dashboards using React, the nr1 CLI, and NRQL queries.

## 🚀 Quick Start with GitHub Codespaces

1. **Launch Codespaces**: Click the green "Code" button and select "Create codespace on main"
2. **Wait for Setup**: The environment will automatically install New Relic CLI and configure your workspace
3. **Start Learning**: Follow the workshop assignments in order

The Codespace will automatically configure:
- New Relic CLI (latest version)
- Node.js 20 LTS
- Development server on port 3000
- VS Code extensions for React/JavaScript development

Your development server will be available at: `https://YOUR-CODESPACE-NAME-3000.app.github.dev`

## 🎯 Workshop Overview

This interactive lab guides participants through the complete lifecycle of creating custom New Relic visualizations, from initial setup to production deployment. Students will build a fully functional radar chart visualization with configurable properties and professional styling.

## Learning Objectives

By the end of this workshop, you will be able to:

- Set up a New Relic development environment with the nr1 CLI
- Create custom visualizations using React and the New Relic One SDK
- Integrate NRQL queries into visualization components
- Customize visualization appearance and behavior
- Configure user-adjustable properties for your visualizations
- Test and iterate on visualizations using local development
- Publish and deploy visualizations to the New Relic catalog
- Add custom visualizations to New Relic dashboards

## Workshop Structure

### Challenge 1: Setting up Your New Relic Development Environment (5 minutes)
- Install and configure Node.js and the New Relic CLI
- Understand the basic nr1 CLI workflow
- Verify your development environment

### Challenge 2: Create Your First Custom Visualization (10 minutes)
- Learn about Nerdpacks and their structure
- Generate a new visualization using the nr1 CLI
- Explore the generated code and understand the default implementation
- Examine the radar chart component structure

### Challenge 3: Local Development and Testing (15 minutes)
- Set up local development workflow
- Install dependencies and serve visualization locally
- Understand hot reloading and development best practices
- Make test changes and see them reflected immediately

### Challenge 4: Customize Your Visualization (20 minutes)
- Add new configuration options to nr1.json
- Enhance the React component with new props
- Apply custom styling with SCSS
- Improve data transformation and error handling
- Test customizations for correctness

### Challenge 5: Publish and Deploy Your Visualization (15 minutes)
- Understand the publishing and subscription workflow
- Learn about versioning and deployment channels
- Create deployment documentation and checklists
- Prepare visualization for production use
- Understand dashboard integration

## Prerequisites

- Basic understanding of JavaScript and React
- Familiarity with web development concepts
- Interest in data visualization and dashboards
- No prior New Relic experience required

## Technical Requirements

The workshop environment provides:
- Ubuntu 22.04 container
- Node.js 18.x
- npm package manager
- New Relic CLI (nr1)
- Pre-configured development workspace

## What You'll Build

You'll create a **custom radar chart visualization** that:

- Displays NRQL query results in a polar coordinate system
- Supports configurable colors and opacity
- Includes robust error handling and loading states
- Features responsive design that adapts to container size
- Provides a professional UI with custom styling
- Can be added to any New Relic dashboard

## Key Technologies

- **React**: Component-based UI framework
- **Recharts**: React-based charting library built on D3
- **NRQL**: New Relic Query Language for data retrieval
- **SCSS**: Enhanced CSS with variables and mixins
- **New Relic One SDK**: Platform integration components

## Workshop Flow

```
Setup Environment → Create Visualization → Local Development → Customize → Publish & Deploy
      ↓                    ↓                    ↓              ↓              ↓
   CLI Tools          Nerdpack + React      Hot Reloading   New Features   Production Ready
```

## Real-World Applications

After completing this workshop, you can create visualizations for:

- **Application Performance**: Custom charts for response times, throughput, error rates
- **Infrastructure Monitoring**: Server metrics, resource utilization, capacity planning
- **Business Metrics**: KPIs, conversion rates, user engagement metrics
- **Security Monitoring**: Threat detection, access patterns, compliance metrics
- **Custom Analytics**: Domain-specific visualizations for your unique data

## Additional Resources

- [New Relic Custom Visualizations Documentation](https://docs.newrelic.com/docs/new-relic-solutions/build-nr-ui/custom-visualizations/)
- [New Relic One SDK Reference](https://docs.newrelic.com/docs/new-relic-solutions/build-nr-ui/)
- [Recharts Documentation](https://recharts.org/)
- [NRQL Reference](https://docs.newrelic.com/docs/nrql/)

## Support

If you encounter issues during the workshop:
1. Check the error messages in the terminal
2. Verify all commands were typed correctly
3. Ensure you're in the correct directory
4. Review the step-by-step instructions carefully

## What's Next?

After completing this workshop, consider:
- Building more complex visualizations with multiple data sources
- Creating visualization libraries for your organization
- Contributing to the New Relic community
- Exploring advanced features like NerdStorage and custom styling

---

**Ready to start building amazing data visualizations for New Relic?** 

Click "Start" to begin your journey into custom visualization development!

## File Structure

```
customvizworkshop/
├── track.yml                          # Main track configuration
├── docker-compose.yml                 # Container configuration
├── track_scripts/
│   └── setup-newrelic-environment     # Global setup script
├── 01-setup-environment/
│   ├── assignment.md                  # Challenge instructions
│   ├── setup-newrelic-dev            # Challenge setup script
│   └── check-newrelic-dev            # Challenge validation script
├── 02-create-visualization/
│   ├── assignment.md
│   ├── setup-newrelic-dev
│   └── check-newrelic-dev
├── 03-local-development/
│   ├── assignment.md
│   ├── setup-newrelic-dev
│   └── check-newrelic-dev
├── 04-customize-visualization/
│   ├── assignment.md
│   ├── setup-newrelic-dev
│   └── check-newrelic-dev
├── 05-publish-deploy/
│   ├── assignment.md
│   ├── setup-newrelic-dev
│   └── check-newrelic-dev
└── README.md                          # This file
```
