# OTel Codespace demo environment startup

Your environment is configured automatically at startup. This may take a few moments for the terminal to appear...

Please refer to the terminal instructions to provide necessary configuration for startup.

----

# Feature flags
The demo uses feature flags to trigger perfromance degradation scenarios.  View the [feature flag instructions](flagd_intructions.md) to learn how to apply them.

----

# Help
If you need to run the installer again:
> /install_demo.sh deploy_demo

How to get frontend URL once demo is running:
> echo "https://$CODESPACE_NAME-3000.app.github.dev/"