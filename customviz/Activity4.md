# Customize Your Visualization

Now you'll learn how to customize your visualization by modifying the React component and styling your chart.

## What You'll Learn
- How to modify React component properties
- How to customize chart appearance and behavior
- How to add custom styling

## Examine the Current Configuration

Let's start by looking at the current configuration:

```bash
# Navigate to your Nerdpack (if not already there)
cd /root/workspace
cd */  # Enter the generated nerdpack directory

# View the current configuration in nr1.json
cat visualizations/my-awesome-visualization/nr1.json
```

## Customize the Chart Appearance

Let's make some visual customizations to your radar chart:

```bash
# Create a backup of the original component
cp visualizations/my-awesome-visualization/index.js visualizations/my-awesome-visualization/index.js.backup

# Change the fillOpacity to make it more visible
sed -i 's/fillOpacity={0.6}/fillOpacity={0.8}/' visualizations/my-awesome-visualization/index.js

# Verify the change
grep -n "fillOpacity" visualizations/my-awesome-visualization/index.js
```

## Add Custom Styling

Let's add some custom styles to your visualization:

```bash
# Look at the current styles
cat visualizations/my-awesome-visualization/styles.scss

# Add some custom styling
echo '
.radar-chart-container {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
' >> visualizations/my-awesome-visualization/styles.scss
```

## Test Your Changes

Let's test the changes by serving the visualization locally:

```bash
# Serve your updated visualization
nr1 nerdpack:serve
```

Great job! You've learned how to customize your visualization.

Continue with [Activity 5](Activity5.md)