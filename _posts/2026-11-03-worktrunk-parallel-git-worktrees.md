---
title: 'Worktrunk: Manage Parallel Git Worktrees'
date: 2026-11-03 16:05:00 -0800
categories: [development]
tags: [git, developer-tools, worktrees, open-source]
description: 'Use Worktrunk to organize parallel branches in separate working directories, and understand what those directories do and do not isolate.'
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/e7226830eb914ef188a5d677846d0ac7/public
  alt: Parallel workbenches connected to a shared repository
  hide_caption: true
---
A long-running change and an urgent fix do not have to fight over the same working directory. Git worktrees let you keep multiple branches checked out at once; [Worktrunk](https://github.com/max-sixty/worktrunk) adds a command-line interface for creating, switching between, and reviewing those directories. It is useful for parallel human work as well as the AI-agent workflows it was designed around.

This is a look at an established open-source project, not a new release announcement. The examples below follow the project's documentation; they have not been run for this article.

## What a worktree gives you

A linked worktree has its own working directory and checked-out branch, but belongs to the same repository. Git maintains the metadata tying it to the main worktree. The [Git manual](https://git-scm.com/docs/git-worktree) explains the underlying commands and restrictions. Separate directories make it easier to keep one unfinished change in place while working on another, without repeatedly switching a single checkout.

Worktrunk adds branch-oriented navigation and status information on top of Git. Its [documentation](https://worktrunk.dev/) describes commands for creating a worktree, listing changes across worktrees, and cleaning up when work is complete. The project is licensed under MIT or Apache-2.0, according to its repository.

## Start with a small parallel task

On a machine with Git and Cargo installed, the project documents this installation route:

```bash
cargo install worktrunk
wt config shell install
```

Shell integration allows `wt` to change the current shell's directory. Follow the [installation instructions](https://worktrunk.dev/) for your shell and platform; Windows users should note the documented `wt` name conflict with Windows Terminal.

From an existing repository, create a branch and its worktree:

```bash
wt switch --create feature-auth
```

The documented command creates the branch and worktree and switches into it. Work normally there, then use:

```bash
wt list
```

The list shows worktrees and status information, including indicators for changes and commits. To return to an existing worktree by branch name, use `wt switch main`, substituting your actual branch name. Paths are calculated from a configurable template, so check the output before assuming where a directory was created.

## Review before combining changes

Separate directories reduce collisions in files on disk, but their changes can still conflict when integrated. Review the diff and run the relevant tests in each branch. The project documents `wt merge` as an automated local workflow involving squash, rebase, merge, and cleanup; read its [merge documentation](https://worktrunk.dev/merge/) before using it on a branch whose history or uncommitted work matters. A normal pull-request workflow remains an option.

After a branch is integrated and you have checked that its work is preserved, the documented `wt remove` command can clean up its worktree. Removal changes local files and branch state, so inspect the worktree first and consult the [removal documentation](https://worktrunk.dev/remove/) for the exact behavior and safeguards.

## What stays shared

A worktree is a separate checkout, not a separate machine. Repository history and shared Git state still connect the directories. Ports, databases, external APIs, credentials, and other services are also outside the checkout: two development servers can still compete for the same port, and two test suites can still modify the same database. Assign separate resources where concurrent work needs them.

Worktrunk also offers hooks for setup and cleanup. Those hooks run commands, so review project configuration before approving or enabling them, especially in an unfamiliar repository. Start with explicit commands until you understand what automation will do. For occasional work, plain `git worktree` may be enough; Worktrunk becomes more appealing when navigating and tracking several branches is a recurring task.
