# Activity 4: Customize Your Visualization

## What You Will Learn
- How to edit chart properties in your visualization
- How to add custom styles
- How to test your changes locally

## Exercises

### 1. Edit Chart Properties
```bash
cp /workspace/my-nerdpack/visualizations/my-custom-visualization/index.js /workspace/my-nerdpack/visualizations/my-custom-visualization/index.js.backup
sed -i 's/fillOpacity={0.6}/fillOpacity={0.8}/' /workspace/my-nerdpack/visualizations/my-custom-visualization/index.js
grep -n "fillOpacity" /workspace/my-nerdpack/visualizations/my-custom-visualization/index.js
```

### 2. Add Custom Styles
```bash
cat /workspace/my-nerdpack/visualizations/my-custom-visualization/styles.scss
echo '
.radar-chart-container {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
' >> /workspace/my-nerdpack/visualizations/my-custom-visualization/styles.scss
```

### 3. Test Your Changes
```bash
cd /workspace/my-nerdpack
nr1 nerdpack:serve
```

## What You Learned
- You customized chart properties and styles
- You tested your changes locally

## Continue to Next Activity
Continue with [Activity 5](Activity5.md)