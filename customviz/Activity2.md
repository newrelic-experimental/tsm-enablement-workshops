# Activity 2: Create Your First Custom Visualization

## What You Will Learn
- How to create a Nerdpack and visualization using the New Relic CLI
- How to explore the generated files and structure
- Key files and their purpose

## Exercises

### 1. Create a Nerdpack and Visualization
```bash
cd ~/workshop
nr1 create --type visualization --name my-awesome-visualization
```
Accept the suggested Nerdpack name when prompted.

### 2. Explore the Generated Files
```bash
ls -la
cd */
ls -la visualizations/my-awesome-visualization/
cat visualizations/my-awesome-visualization/nr1.json
head -25 visualizations/my-awesome-visualization/index.js
```
Key files:
- `nr1.json`: Visualization configuration
- `index.js`: React component
- `styles.scss`: Styles

## What You Learned
- You created a Nerdpack and visualization
- You explored the structure and key files

## Continue to Next Activity
Continue with [Activity 3](Activity3.md)
