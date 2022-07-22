# Terraforming Minecraft

This is an example of how to write Terraform code and use a Git workflow to manage resources.

In this example we use the Minecraft Terraform provider to give a visual representation of what Terraform does in the background.

## Prerequisites

- shipyard
- ngrok
- docker

## Demo setup

Start ngrok in order to forward traffic to GitLab. In a new terminal window, run:

```shell
make ngrok
```

Create a Minecraft server and GitLab instance and configure them.

```shell
make shipyard
```

Take the url that the previous command outputs and use it to close the minecraft repository.

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
