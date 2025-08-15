# Activity 3: Local Development

## What You Will Learn
- How to install dependencies and run your visualization locally
- How to make and test code changes

## Exercises

### 1. Local Development
```bash
cd /workspace/my-nerdpack
npm install --legacy-peer-deps
nr1 nerdpack:serve
```
Open the provided link to view your live visualization. Any code changes will be reflected instantly.

### 2. Make a Test Change
Edit your visualization's main component (e.g., `index.js`) and try one of the following changes:

**A. Change the chart title**
Find the line that renders the chart title (often a `HeadingText` or similar) and update it:
```js
<HeadingText type={HeadingText.TYPE.HEADING_3}>
  My Custom Radar Chart (Activity 3)
</HeadingText>
```

**B. Change the default fill color**
Find the `Radar` component and update the `fill` and `stroke` props:
```js
<Radar
  dataKey="value"
  stroke="#FF5733"
  fill="#FF5733"
  fillOpacity={0.6}
/>
```

Save the file and refresh your visualization. You should see the updated title or color.

## What You Learned
- You ran your visualization locally and made meaningful code changes

## Continue to Next Activity
Continue with [Activity 4](Activity4.md)
