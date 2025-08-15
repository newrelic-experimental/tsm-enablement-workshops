# Publish and Deploy Your Visualization

In this final challenge, you'll learn how to publish your visualization and make it available in New Relic dashboards and the platform.

## What You'll Learn
- How to publish a Nerdpack to New Relic
- Understanding the publication process
- How to subscribe to published visualizations
- Best practices for deployment

## Prepare for Publishing

First, let's navigate to your Nerdpack and prepare for publishing:

```bash
# Navigate to your Nerdpack (if not already there)
cd /root/workspace
cd */  # Enter the generated nerdpack directory

# Check that everything is ready
ls -la
```

## Build the Nerdpack

Before publishing, you need to build your Nerdpack:

```bash
# Build the Nerdpack for production
nr1 nerdpack:build

# Check the build output
ls -la dist/
```

## Simulate Publishing

In a real environment, you would publish with:

```bash
# This would publish to New Relic (simulation only)
echo "nr1 nerdpack:publish"
echo "Publishing visualization to New Relic..."
echo "✓ Nerdpack published successfully!"
```

## Understanding the Publishing Process

When you publish a Nerdpack, it:
1. Uploads your code to New Relic's infrastructure
2. Makes it available in the Apps section
3. Allows others to subscribe to it
4. Enables use in dashboards and applications

## Subscription Process

After publishing, users can subscribe:

```bash
echo "Users would run: nr1 nerdpack:subscribe"
echo "This makes the visualization available in their account"
```

## Using in Dashboards

Your published visualization can be added to dashboards:
- Navigate to New Relic Dashboards
- Click "Add widget"
- Select "Custom visualizations"
- Choose your published visualization
- Configure NRQL queries and properties

## Best Practices

Key points for publishing:
1. Test thoroughly in local development
2. Use semantic versioning
3. Include clear documentation
4. Test with real data before publishing
5. Monitor usage and performance

## Congratulations!

You've successfully completed the New Relic Custom Visualization Workshop! You've learned:

✅ How to set up a New Relic development environment
✅ How to create custom visualizations with the nr1 CLI
✅ How to develop and test locally
✅ How to customize visualizations
✅ How to publish and deploy your work

## Next Steps

Continue your journey:
- Explore the New Relic Developer documentation
- Join the New Relic Developer community
- Build more complex visualizations
- Share your creations with the community

Great job completing the workshop!
