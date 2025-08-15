# Create Your First Custom Visualization

Now that your environment is set up, you'll create your first New Relic custom visualization! You'll learn about Nerdpacks and use the nr1 CLI to generate the boilerplate code for a visualization.

## What You'll Learn
- What a Nerdpack is and its structure
- How to create a new visualization using nr1 CLI
- Understanding the generated file structure
- Exploring the default visualization code

## Understanding Nerdpacks

A **Nerdpack** is a package that contains one or more Nerdlets (applications) or visualizations. Think of it as a container for your New Relic custom applications and visualizations.

## Create Your Visualization

Let's create a new visualization. The CLI will automatically create a Nerdpack for you:

```bash
# Navigate to your workspace
cd /root/workspace

# Create a new visualization (this will create a Nerdpack automatically)
nr1 create --type visualization --name my-awesome-visualization
```

**What you'll see:**
1. The CLI will notice you're outside a Nerdpack and offer to create one
2. You'll be asked to name the Nerdpack (accept the suggested name)
3. Dependencies will be installed automatically
4. Your visualization will be created inside the new Nerdpack

## Explore the Generated Structure

Now let's see what was created:

```bash
# List the contents - you should see a new directory with a random name
ls -la

# Navigate into the generated nerdpack
cd */

# Look at the overall structure
ls -la

# Examine the visualizations directory
ls -la visualizations/

# Look at your specific visualization
ls -la visualizations/my-awesome-visualization/
```

You should see these key files:
- `nr1.json` - Metadata and configuration for your visualization
- `index.js` - The React component that renders your visualization
- `styles.scss` - Sass styles for your visualization

## Examine the Generated Code

Let's look at the key files that were generated:

```bash
# View the visualization metadata
cat visualizations/my-awesome-visualization/nr1.json

# View the beginning of the main component
head -25 visualizations/my-awesome-visualization/index.js
```

You can also explore the full code using the **Editor** tab to browse all the files.

## Understanding the Default Visualization

The generated code creates a **RadarChart** visualization that:
- Uses the Recharts library for data visualization
- Accepts NRQL queries as input from New Relic
- Displays data in a radar/polar chart format
- Includes error handling and loading states
- Has configurable properties for colors and styling

## Key Files Explained

**`nr1.json`** - Defines the visualization configuration:
- Configurable properties (colors, queries)
- Metadata like display name and description

**`index.js`** - The main React component:
- Handles NRQL query data
- Renders the chart using Recharts
- Manages loading and error states

**`styles.scss`** - Styling for your visualization

## Next Steps

Perfect! You've successfully created your first New Relic visualization. The generated code provides:
- A complete working React component
- NRQL query integration
- Configurable properties
- Professional error handling

In the next challenge, you'll run this visualization locally and see it in action with real data.

Great work! Continue with [Activity 3](Activity3.md)
