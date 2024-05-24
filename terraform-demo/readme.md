
# Terraform Codespace Demo
> Follow the [instructions](../README.md) to start the demo Codespace using the `nr-terraform-demo-codespaces` configuration and then follow along.


For local development we recommend using [tfenv](https://github.com/tfutils/tfenv) to manage your Terraform versions. `tfenv` is already installed on this environment, we'll use it to install the latest stable version of terraform.

Exercise 1: Install Terraform
===
Learn how to install terraform using `tfenv`
<details>
	<summary>View instructions</summary>

1. List all the versions of Terraform that are available to install and scroll to the top of the list and find the most recent (highest version number number) *stable* (non alpha/beta) version using the `list-remote` command.
 ```run
 tfenv list-remote | head -n20
 ```

2. Install the latest version (as found in the list above) using the `install` command:
```run
tfenv install VERSION.NUMBER.HERE
```
```
e.g: tfenv install 1.7.5
```

3. Switch to the installed version you want to use using the `use` command:

```run
tfenv use VERSION.NUMBER.HERE
```

4. Confirm terraform is installed correctly:

```run
terraform -v
```
</details>


Exercise 2: Configure and initialise the provider
===
The "provider" defines what resources Terraform can manage. In this case we'll need to use the [New Relic provider.](https://registry.terraform.io/providers/newrelic/newrelic/3.32.0)

> [!IMPORTANT]
>  You will need an UserAPI key and your New Relic account number to complete this step.

<details>
	<summary>View instructions</summary>

Terraform configuration is provided via plain text files with the `.tf` extension.

1. View the [provider documentation](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/guides/provider_configuration) and copy the example provider block into a file called `provider.tf`
2. Update the provider block to include your account ID and API Key in the relevant positions.
3. Initialise the Terraform configuration with the `init` command:
```run
terraform init
```
</details>

Exercise 3: Create an alert
===
In this exercise we'll use terraform to create an alert policy and add an alert condition to it.

<details><summary>View instructions</summary>
	
## Task 1: Create alert policy

First create an alert policy. This is one of the most simple resources to configure.

1. View the documentation for the [alert policy resource](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_policy)
2. Copy the example into a file called `alerts.tf`
3. Update the name of the resource to  `example`
4.  Use the documentation to set the incident preference of the policy  to "One issue per condition"
5.  Set the name of the policy to "Example terraform alert policy" (this is how it will appear in New Relic)

It should look something like this:
```
resource "newrelic_alert_policy" "example" {
  name = "Example Terraform alert policy"
  incident_preference = "PER_CONDITION"
}
```

## Task 2: Add a condition to the policy
We need to add a condition to this policy. We will need to add the condition resource and then link it to the policy we configured previously.

### Add the condition resource
1. View the documentation for the [nrql alert condition resource](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/nrql_alert_condition)
2. Copy from the first example the `newrelic_nrql_alert_condition` block (don't copy the `newrelic_alert_policy` we already have that!)
3. Change the name of the resource to `simple_nrql_condition`.
4. Add your account ID in the relevant position.
5. Set the name of the condition to `Example NRQL condition` (this is the name as it appears in New Relic)

### Link the condition  to the policy
We can provide resources as inputs to other resources using dot notation. As you can see in the [documentation for the nrql policy resource](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_policy#attributes-reference) the resource exposes the `id` of the policy. We can reference resource attribute as follows:

```
[resource_type].[resource_name].[attribute_name]
```
In this example the `id` of the policy resource  is:
```
newrelic_alert_policy.example.id
```

1. Set the NRQL condition resource `policy_id` attribute to be the value `newrelic_alert_policy.example.id`

> [!NOTE]
> Don't worry terraform knows what order to create things by building a dependency graph between the resources.


## Task 3: Plan and apply the configuration
Terraform has a two stage commit `plan` and `apply`. You can use the `plan` to see what changes would be made. By default the `apply` will also run a `plan` automatically.

1.  Run a plan using the `plan` command:
```run
terraform plan
```
Review the changes the plan shows.

2. Apply the changes:
```run
terraform apply
```
(You need to respond `yes` when prompted)

3. Find the generated policy and condition in the New Relic user interface.


## Task 4: Make changes
In this task we'll make some changes and see how the terraform responds.

### Make a change in the terraform configuration
1. Make a change in the NRQL condition resource, for instance change the critical threshold to a different value.
2. Apply the change and review the delta changes terraform intends to make:
```run
terraform apply
```
3. Confirm in the New Relic UI the change has been made

### Make a UI change
1.  In the New Relic UI make a change to the NRQL condition (change a threshold for instance)
2.  Run the terraform apply to and see that the change is noticed and reverted:
```run
terraform apply
```
</details>

Exercise 4: Creating dynamic resources
===
This exercise shows how resources can be generated from simple configuration. We will generate multiple synthetic monitors from a single, simple configuration.

<details>
	<summary>View instructions</summary>
	
## Task 1: Create configuration
Before we create the synthetic monitor resource we need to create the configuration to drive it. This configuration can be passed in many ways, but to keep things simple we'll use [terraform local variables](https://developer.hashicorp.com/terraform/language/values/locals).
For this example our configuration will be a simple list of websites we'd like to check. We'll check two sites in this example, but you could add as many as you like.
- New Relic: https://www.newrelic.com
- BBC News: https://www.bbc.co.uk/news

For each site we need to specify the name of the site and the URL to check. We could of course supply all sorts of configuration attributes here, its entirely up to us.  For example each site is like this:
```
{
	name = "New Relic"
	uri = "https://www.newrelic.com"
	}
```

### Add the configuration
1. Add the following configuration to a file called `synth.tf`. Configure it to your liking!
```
locals {
  sites = {
       relic = {
    	name = "New Relic"
    	uri = "https://www.newrelic.com"
       },
       bbc = {
    	name = "BBC"
    	uri = "https://www.bbc.co.uk/news"
      }
  }
}
```
You can see that both sites are added to the `sites` object within `locals`. We'll iterate over this to generate the configuration.

## Task 2: Add synthetic monitor resource

1. Find the documentation for the [synthetics monitor resource](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/synthetics_monitor)
2. Copy the first example into the file `synth.tf`

If we left it like this then we would get a single monitor. To generate a monitor for each site in our list we need to use the [Terraform for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) feature.

3. Immediately before the `status` attribute at the top of the resource definition add an attribute `for_each` referencing our local variable `local.sites` (note the `s` is removed).
```
for_each = local.sites
```

For each iteration of the sites variable the object will become available in a special value called `each`. This contains the key and value.

4.  Update the `name` attribute so that the site name is automatically added to the monitor name, extracting the name field from our site object. We use interpolation on the string to do this:
```
name = "Simple check: ${each.value.name}"
```

5. Update the uri attribute to reference the `uri` value of the site object. As we're not appending any strings we can reference this directly:
```
uri = each.value.uri
```

6. Apply the configuration
```run
terraform apply
```
7. Confirm that both synthetic monitors were created in the UI.
</details>

Exercise 5: Clean up
===
Complete the exercises by tidying up and deleting the resources you created.

> [!WARNING]
> Don't forget this step, otherwise you might incur charges for those synthetics!

<details>
	<summary>View instructions</summary>
	
One of the nice things about using terraform is its easy to clean up after yourself! Now we're done with the exercise you can remove everything you created by running the `destroy` command.

```run
terraform destroy
```

</details>

Summary
===

Well done! You've learnt to install and use Terraform to manage New Relic resources.

If you want to learn more about Observability as Code with New Relic check out some of these resources:
- [Observability as Code Guide](https://docs.newrelic.com/docs/new-relic-solutions/observability-maturity/operational-efficiency/observability-as-code-guide/)
- [Terraform & New Relic Video Guides](https://developer.newrelic.com/terraform/)
- [Terraform Provider Documentation](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs)
