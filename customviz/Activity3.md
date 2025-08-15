# Local Development and Publishing

You'll learn **two approaches** for accessing your custom visualization in New Relic One:

1. **Publishing** (Primary workshop method) - Reliable deployment that always works
2. **Development Server** (Educational/Real-world context) - Understand local development workflow

## Which Method Should You Use?

| Scenario | Workshop Approach | Real Development | Why |
|----------|------------------|------------------|-----|
| **Actually using your visualization** | ✅ **Publishing** | Development Server | Workshop: Reliable access |
| **Learning the complete workflow** | ✅ **Publishing** | Publishing | Same in both environments |
| **Understanding development process** | Development Server | ✅ **Development Server** | Educational value |
| **Production deployment** | ✅ **Publishing** | ✅ **Publishing** | Stable, permanent |
| **Team collaboration** | ✅ **Publishing** | ✅ **Publishing** | Shared access |

**Workshop Strategy**:
1. **Focus on publishing** - This will actually work and let you see your visualization
2. **Try the development server** - To understand the workflow, even if connection fails
3. **Learn both approaches** - Complete knowledge for real-world development

**Real-World Strategy**:
- Use development server for rapid iteration during creation
- Publish when ready for production use and team sharing

You'll learn **two approaches** for accessing your custom visualization in New Relic One:

1. **Publishing** (Primary workshop method) - Reliable deployment that always works
2. **Development Server** (Educational/Real-world context) - Understand local development workflow

**Workshop Reality Check:**
The development server approach (`?nerdpacks=local`) faces authentication constraints in workshop environments. While we've proven that external access works (the development server starts successfully and external URLs route correctly), New Relic One cannot authenticate with development servers running in Instruqt due to:

- **Authentication barriers**: New Relic One requires specific authentication tokens for development server connections
- **Cross-domain restrictions**: Security policies between instruqt.com and newrelic.com domains
- **Workshop isolation**: Instruqt's security model prevents the complete authentication handshake

**What We've Proven:**
- ✅ External URLs work (traffic routes to your VM)
- ✅ New Relic development server starts successfully
- ✅ VM configuration allows external access
- ❌ Authentication layer blocks the final connection

**Don't worry!** This is a workshop security limitation, not a New Relic limitation. In real development environments, the local development server works perfectly because your machine can complete the full authentication flow.

Let's explore both approaches so you understand the complete workflow!

## What You'll Learn
- **Publishing workflow** - The reliable method for workshop and production use
- **Development server concepts** - How local development works in real environments
- **When to use each approach** - Understanding the trade-offs and use cases
- **Complete New Relic visualization lifecycle** - From creation to deployment

## Prepare Your Visualization

First, let's navigate to your Nerdpack and ensure it's ready:

```bash
# Navigate to your workspace and find the generated Nerdpack
cd /root/workspace
ls -la

# Navigate into the generated nerdpack (it will have a random name like "bustling-pocket")
cd */

# Install dependencies to ensure everything is ready
npm install
```

## Method 1: Publish Your Visualization (Primary Workshop Method)

Publishing is the most reliable way to access your visualization in New Relic One. This method always works and mirrors real production workflows:

```bash
# Navigate to your nerdpack directory first
cd /root/workspace
cd */  # Go into your nerdpack directory

# Build and publish your Nerdpack
nr1 nerdpack:publish

# Subscribe to your published Nerdpack to make it available
nr1 nerdpack:subscribe
```

**Why Publishing Works Reliably:**
- ✅ **No networking dependencies** - Hosted on New Relic's infrastructure
- ✅ **Always accessible** - Works regardless of workshop environment constraints
- ✅ **Production workflow** - Learn the complete deployment process
- ✅ **Team sharing** - Available to all users in your New Relic account

### Access Your Published Visualization

1. **Open New Relic One**: Click the **New Relic One** tab
2. **Navigate to Apps**: Go to "Apps" in the main navigation
3. **Find Custom Visualizations**: Look for "Custom Visualizations" section
4. **Select Your Nerdpack**: Find your visualization by name
5. **Create Instance**: Configure your visualization with NRQL query
6. **Add to Dashboard**: Save it to any dashboard for reuse

**Success Indicators:**
- ✅ No error messages during publish
- ✅ Your nerdpack appears in "Apps" → "Custom Visualizations"
- ✅ You can create instances of your visualization
- ✅ Visualization renders with data when configured**Important:** The key is that New Relic One needs to know your external URL. However, if external URL construction fails, you have alternatives:

**Primary Approach**: External URL
- ✅ Bind to `0.0.0.0:3000` (accessible externally)
- ✅ Set proper CORS headers
- ✅ Enable external connections

**Fallback Approach**: Published Nerdpack
- If external access fails due to "could not parse target env" errors
- Use Method 2 (Publishing) instead for reliable access
- Publishing doesn't require external URL configuration

**If you get "Unexpected arguments" errors:**
- Don't use `--host` or `--port` flags
- Use environment variables: `HOST=0.0.0.0 PORT=3000 nr1 nerdpack:serve`
- Or just run: `nr1 nerdpack:serve` (environment is pre-configured)

### Access Your Visualization in New Relic One

**Step 1: Start Your Development Server**
```bash
# In your nerdpack directory
nr1 nerdpack:serve
```

**Step 2: Discover Your External URL**

Since external access is now possible with VM configuration, let's construct your external URL:

```bash
# Get your participant ID and hostname
PARTICIPANT_ID=$INSTRUQT_PARTICIPANT_ID
HOSTNAME=$(hostname)
echo "Your external URL should be:"
echo "https://${HOSTNAME}-3000-${PARTICIPANT_ID}.env.play.instruqt.com"
```

**Alternative method - Check service tabs:**
1. Click the **Nerdpack Server** tab
2. Copy the URL from the address bar (this is your external URL)
3. This URL follows Instruqt's format for VMs with external ingress

**Step 2: Get the External URL from Service Tab**
1. Click the **Nerdpack Server** tab
2. Copy the URL from the address bar (this is your external URL)
3. This URL follows Instruqt's format: `https://hostname-3000-participantid.env.play.instruqt.com`

**Step 3: Configure New Relic One**
1. Click the **New Relic One** tab
2. Navigate to: `https://one.newrelic.com/?nerdpacks=local`
3. New Relic One should detect your development server automatically

**If Manual Configuration is Needed:**
- In New Relic One: Apps → Custom Visualizations → Local Development
- Enter the URL from your **Nerdpack Server** tab
- This tells New Relic One exactly where to connect

**Why This Works:**
- ✅ **Service tabs use authenticated traffic** - Only logged-in learners can access
- ✅ **Instruqt handles URL construction** - No manual hostname resolution needed
- ✅ **Automatic port forwarding** - Instruqt proxy forwards requests to your server
- ✅ **HTTPS termination** - Instruqt proxy handles SSL certificates

**How It Works:**
- Your development server runs on `0.0.0.0:3000` (accessible from anywhere)
- Instruqt exposes it as `https://hostname-3000.env.play.instruqt.com`
- New Relic One makes HTTP requests to your external URL
- Your visualization loads in real-time from your development environment

**Troubleshooting Connection Issues:**

```bash
# Step 1: Verify development server is running
nr1 nerdpack:serve

# Step 2: Test the service tab
# Click "Nerdpack Server" tab - you should see your development server

# Step 3: Verify server is binding correctly
netstat -tlnp | grep :3000

# Step 4: Test external URL access
echo "Testing external URL construction..."
echo "VM Hostname: $(hostname)"
echo "Participant ID: $INSTRUQT_PARTICIPANT_ID"
echo "External access should be available at:"
echo "https://$(hostname)-3000-${INSTRUQT_PARTICIPANT_ID}.env.play.instruqt.com"

# Step 5: If service tab doesn't work, check server binding
HOST=0.0.0.0 PORT=3000 nr1 nerdpack:serve
```

**Common Issues:**

1. **Service tab shows "Connection refused"**:
   ```bash
   # Ensure server binds to all interfaces, not just localhost
   export HOST=0.0.0.0
   nr1 nerdpack:serve
   ```

2. **New Relic One can't connect**:
   - Copy the exact URL from the **Nerdpack Server** tab
   - Paste it in New Relic One's local development configuration
   - Make sure the development server shows "Server ready!" message

3. **"Could not parse target env" error**:
   - This was likely due to incorrect URL format
   - Use the service tab approach instead of manual URL construction
   - Service tabs use Instruqt's proper URL format automatically

**What You'll See:**
- ✅ Your visualization loads in real-time from the development server
- ✅ Changes you make to code are reflected immediately
- ✅ You can test with real New Relic data
- ✅ Perfect for rapid development iteration

**Key Advantages:**
- 🚀 **Instant feedback** - See changes immediately
- 🔧 **Easy debugging** - Full development tools available
- 📊 **Real data testing** - Test with actual New Relic telemetry
- 🔄 **No publishing needed** - Skip the publish/subscribe cycle

## Method 2: Development Server (Educational Context)

Understanding the development server workflow is important for real-world New Relic development. While external connectivity has limitations in this workshop environment, you'll learn how it works:

### Start the Development Server

```bash
# Start the development server to understand the workflow
nr1 nerdpack:serve
```

**What This Demonstrates:**
- ✅ Local development server startup process
- ✅ Webpack bundling and hot reloading concepts
- ✅ File watching and automatic rebuilding
- ✅ Development URLs and external access patterns

**Workshop Reality:**
- ❌ The URL `https://one.newrelic.com/?nerdpacks=local` will show connection errors
- ❌ This is expected due to workshop networking constraints
- ✅ In real development environments, this connection works seamlessly

**Understanding the Process:**
1. Click the **Nerdpack Server** tab to see your development server running
2. Note the generated URL - this shows how external access would work
3. The `?nerdpacks=local` parameter tells New Relic One to look for local development servers
4. In production development, New Relic One would connect to your local machine

**Real-World Benefits:**
- 🚀 **Instant feedback** - See changes immediately without republishing
- 🔧 **Easy debugging** - Full development tools and console access
- 📊 **Live data testing** - Test with actual New Relic telemetry
- 🔄 **Rapid iteration** - Make changes and see results instantly

### Troubleshooting Development Server Connection

**If you see "Local nerdpacks failed to load" or connection errors:**

This is **expected in the workshop environment**. The error occurs despite the fact that:

1. ✅ **External URL works**: `https://newrelic-dev-3000-{participant-id}.env.play.instruqt.com` resolves and routes correctly
2. ✅ **Development server starts**: The `nr1 nerdpack:serve` command builds and starts successfully
3. ✅ **Traffic reaches your VM**: External requests get HTTP 401 responses (not connection refused)
4. ❌ **Authentication fails**: New Relic One cannot complete the authentication handshake

**What the error means:**
- The infrastructure works perfectly
- The development server is running and responding
- Workshop security policies prevent the final authentication step
- This would work seamlessly in a real development environment

**This is normal and expected!** Focus on the publishing method to actually use your visualization.

## Which Method Should You Use?

| Scenario | Workshop Recommendation | Real Development | Why |
|----------|------------------------|------------------|-----|
| **Learning the workflow** | Development Server | Development Server | Understand local development process |
| **Actually using the visualization** | Published Nerdpack | Development Server | Reliable access in workshop environment |
| **Production deployment** | Published Nerdpack | Published Nerdpack | Stable, permanent, accessible to all |
| **Team sharing** | Published Nerdpack | Published Nerdpack | Available to all users in account |

**Workshop Strategy**:
1. **Start the development server** to learn the workflow
2. **Publish your Nerdpack** to actually use the visualization
3. **Understand both approaches** for real-world development

**Real-World Strategy**:
- Use development server for rapid iteration and testing
- Publish when ready for production use and team sharing## Test Your Published Visualization

Let's verify that your visualization was published successfully:

```bash
# List your published Nerdpacks
nr1 nerdpack:info

# Check subscription status
nr1 subscription:list
```

**Success Indicators:**
- ✅ Your Nerdpack appears in the published list
- ✅ You're subscribed to your own Nerdpack
- ✅ No compilation errors during publish
- ✅ Visualization is accessible in New Relic One

## Next Steps

Perfect! You've successfully:

1. ✅ **Created** a custom visualization using `nr1 create`
2. ✅ **Fixed** compatibility issues with modern libraries
3. ✅ **Published** your visualization to New Relic
4. ✅ **Made it available** for use with real telemetry data

**In a Real Environment:**
- Your visualization would be available to query live New Relic data
- You could add it to dashboards alongside other charts
- Team members could discover and use your visualization
- You could iterate and republish updated versions

**Workshop Achievement:**
You've completed the full lifecycle of New Relic custom visualization development - from creation to publication!

## Make a Test Change

Let's make a small change to see how updates work:

```bash
# First, let's look at the current fillOpacity in the component
grep -n "fillOpacity" visualizations/my-awesome-visualization/index.js

# Create a backup of the original file
cp visualizations/my-awesome-visualization/index.js visualizations/my-awesome-visualization/index.js.backup

# Change fillOpacity from 0.6 to 1.0 (making it completely opaque)
sed -i 's/fillOpacity={0.6}/fillOpacity={1.0}/g' visualizations/my-awesome-visualization/index.js

# Verify the change
grep -n "fillOpacity" visualizations/my-awesome-visualization/index.js

# Republish with your changes
nr1 nerdpack:publish
```

**Development Best Practices:**
1. Always test changes before publishing
2. Use semantic versioning for your releases
3. Document what your visualization does and how to use it
4. Consider backward compatibility when making changes

**Congratulations!** You've successfully created, published, and updated a New Relic custom visualization!

Click **Check** to continue to the next challenge where we'll explore more advanced visualization features.
3. Make small, incremental changes
4. Test with real NRQL queries when possible
5. Restart the server after configuration changes

Great job! You've learned the local development workflow. 

Continue with [Activity 4](Activity4.md)
