# Terraforming Minecraft

This is an example of how to write Terraform code and use a Git workflow to manage resources.

In this example we use the Minecraft Terraform provider to give a visual representation of what Terraform does in the background.

## Prerequisites

- shipyard
- ngrok
- docker

## Demo setup

### Route external traffic to GitLab and Minecraft

Start ngrok in order to forward traffic to GitLab. In a new terminal window, run:

```shell
make ngrok
```

### Create environment

Create a Minecraft server and GitLab instance and configure them.

```shell
make shipyard
```

### Configure Terraform Cloud VCS provider

Now that both GitLab and Minecraft are running, we need to configure Terraform Cloud to use GitLab to drive our Terraform runs.
Navigate to `Settings > Version control > Providers > Add VCS provider` and fill out the forms using the gitlab url that was output by Shipyard as the HTTPS url (even if it is HTTP), and the gitlab url followed by `/api/v4` for the API url.

Then following the steps provided by the wizard, log in to GitLab using the credentials for the root user (root / password by default).
Then navigate to `User Profile > Preferences > Applications` and fill out the form using the details provided by Terraform Cloud, and in the final steps fill out the information provided by GitLab into the form in Terraform Cloud. Now that we have the VCS provider set up, we can setup the workspace to use this provider.

### Configure Terraform Cloud workspace

Navigate to your workspace and `Settings > Version Control`, select Gitlab CE as the source and select the repository. Then set the branch to `main`.

### Clone git repository

We are now ready to clone the `demo/minecraft` git repository and write Terraform code.

```shell
eval $(shipyard env)
git clone $gitlab/demo/minecraft.git
```

## Revert commit

An easy way to revert to a previous commit:

```shell
git revert --no-commit <commit>..HEAD
git commit -m "Revert back to <commit> because ..."
```

The safest way to revert to a previous commit, even when there have been merges in between:

```shell
git branch backup_main
git reset --hard <commit>
git reset --soft backup_main
git commit -m "Revert back to <commit> because ..."
git branch -d backup_main
```
