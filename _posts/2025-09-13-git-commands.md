---
title: Git Commands
author: jay
date: 2025-09-13 22:32:46 +0200
categories: [Blogging, Tutorial]
tags: [writing]
render_with_liquid: false
toc: true
description: Setting up the git config when starting and some basic commands.

---

## Configuring Git

### Identity

Setting up user name and email address is the first thing one should do, since all the commits will have this information. You can set up the identity either globally with `--global` option or only for a local repo with `--local`.

```bash
git config --global user.name "User Name"
git config --global user.email "user@example.com"
```

### Having multiple config files

If we want to have a personal config and a work config we can tell git to look for config files that are specific for that directory.

```ini
[includeIf "gitdir:~/home/work/"]
    path = ~/home/work/.gitconfig
[includeIf "gitdir:~/home/personal/"]
    path = ~/home/personal/.gitconfig
```

Whenever you do something from these directory git will use these config files.

### Default Branch

Whenever you initialize a git repository it will create a branch with the name **master**, you can change this by:

```bash
git config --global init.defaultBranch main
```

Now any new `git init` will create a branch called main.

### Aliases

We can create aliases for our most used commands in git:

```bash
git config --global alias.cmt 'commit -m'
git config --global alias.st 'status'
git config --global alias.co 'checkout'
git config --global alias.br 'branch'
```

Now we can commit by using `git cmt "our message"` or check status with `git st`.

When using the `--global` option the config is saved to the `~/.gitconfig` or `~/.config/git/config`.

The same action can be performed with the `--local` option which saves the changes to the current repositories `.git/config`.

You can check all the **config Settings** with `git config --list`.

### Having multiple SSH Keys

When creating the ssh key, create one for your personal github and another one for you work account.
Create a config file to tell it, when to use which key in the file ~/.ssh/config. 

Companies will host their own remote server, so change the HostName according to it. For example here 
the company uses the own domain work-git.work.com

```config
Host github.com
	HostName github.com
	User git
	IdentityFile ~/.ssh/id_ed25519

Host gitlab.com-work
	HostName work-git.work.com
	User git
	IdentityFile ~/.ssh/work_ed25519
```

When cloning from different remotes, use the appropriate host:

```bash
# Clone from personal GitHub
git clone git@github.com:username/repo.git

# Clone from work GitLab (using the host alias)
git clone git@gitlab.com-work:username/repo.git
```

## Multiple Remotes

You can set up multiple remotes for a single local repository:

```bash
# Add personal GitHub as origin
git remote add origin git@github.com:username/repo.git

# Add work GitLab as work remote
git remote add work git@gitlab.com-work:username/repo.git

# View all remotes
git remote -v

# Push to specific remotes
git push origin main
git push work main

# Push to all remotes at once
git push origin main && git push work main
```

You can also configure one remote to push to multiple URLs:

```bash
# Set up origin to push to both repositories
git remote set-url --add --push origin git@github.com:username/repo.git
git remote set-url --add --push origin git@gitlab.com-work:username/repo.git
```


## Common Commands

### Viewing Changes and History

```bash
# View file changes
git diff                    # Changes in working directory
git diff --staged          # Changes in staging area
git diff --word-diff       # Word-by-word changes
git diff HEAD~1 HEAD       # Compare commits

# View commit history
git log                    # Full commit history
git log --oneline          # Condensed one-line format
git log --graph            # Show branch graph
git log <file>             # History for specific file
git log -S "search"        # Search for changes in commits
git log -p                 # Show patches/diffs
```

### File Analysis

```bash
# Blame/annotation
git blame <file>                           # Full file blame
git blame -L 1,20 <file>                  # Specific line range
git blame -w -C -C -C -L 1,20 <file>      # Ignore whitespace, detect moves/copies

# Reference log
git reflog                 # Shows history of HEAD changes
```

### Stashing Changes

```bash
git stash                  # Stash current changes
git stash pop              # Apply and remove latest stash
git stash list             # List all stashes
git stash apply stash@{0}  # Apply specific stash
git stash drop stash@{0}   # Delete specific stash
```

### Branch Management

```bash
git branch                 # List local branches
git branch -r              # List remote branches
git branch -a              # List all branches
git branch <name>          # Create new branch
git checkout <branch>      # Switch branches
git checkout -b <branch>   # Create and switch to new branch
git branch -d <branch>     # Delete branch (safe)
git branch -D <branch>     # Force delete branch
```

### Advanced Operations

```bash
# Cherry-pick commits
git cherry-pick <commit>   # Apply specific commit to current branch

# Rebase
git rebase main            # Rebase current branch onto main
git rebase -i HEAD~3       # Interactive rebase for last 3 commits

# Reset operations
git reset --soft HEAD~1    # Undo commit, keep changes staged
git reset --mixed HEAD~1   # Undo commit and staging
git reset --hard HEAD~1    # Undo everything (dangerous)

# Clean untracked files
git clean -n               # Preview what would be deleted
git clean -fd              # Force delete untracked files and directories
```



### References

[Git](https://git-scm.com/book/en/v2/)

