---
title: 'Memos: A Self-Hosted Timeline for Your Notes'
date: '2026-11-05 15:58:28 -0800'
description: 'Run a private Memos instance and organize short notes with tags, search, and a timeline.'
categories: [selfhosting]
tags: [self-hosting, docker, notes, open-source]
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/82de272453aa4559833d275ea228332f/public
  alt: Note cards linked to a private server
  hide_caption: true
---
A useful note doesn't always deserve a whole document. A command to revisit, a link with a sentence of context, or a quick homelab observation can disappear into a pile of browser tabs. [Memos](https://github.com/usememos/memos) gives those fragments a home: a self-hosted Markdown notebook organized around a chronological timeline, with tags and search to find them later.

Memos is an established MIT-licensed project, not a new launch. Its [current documentation](https://usememos.com/docs) covers release 26.11.0. This guide walks through a local Docker instance and the operational choices that matter before relying on it. The steps below follow the project's documentation; they have not been tested as a deployment for this article.

## What makes the timeline useful?

Each memo can be a sentence or a longer Markdown entry. Notes stay associated with the day they were written, while hashtags connect related entries across dates. The [usage guide](https://usememos.com/docs/usage) also describes attachments, saved filter Views, search, and Spaces for collaboration.

For example, keep brief notes tagged `#homelab` as you change a service, then search that tag when troubleshooting weeks later. A View can save a recurring filter. This is a different shape from a hierarchical wiki: it favors capturing a thought quickly and finding it again, while a larger, carefully structured manual may still belong elsewhere.

Visibility deserves attention. Memos supports private and shared content, and its docs say assigning a memo to a Space does not automatically make it visible to members. Check the audience of a memo and its attachments before sharing it.

## Start locally with Docker

You'll need Docker running on a Linux host and an available port 5230. The following adapts the [official Docker instructions](https://usememos.com/docs/deploy/docker) by binding the published port to loopback, so the initial instance is accessible only from that host:

```bash
docker run -d \
  --name memos \
  --restart unless-stopped \
  -p 127.0.0.1:5230:5230 \
  -v "$HOME/.memos:/var/opt/memos" \
  neosmemo/memos:26.11.0
```

Open `http://localhost:5230` on that machine and create the first account. Docker should print a container ID when it starts. The versioned image tag makes the selected release explicit; unlike `stable`, it won't silently follow a later release when pulled again. The directory mount holds the default SQLite database and local assets beyond the lifetime of the container.

If the page doesn't load, check `docker logs memos` and confirm port 5230 is free. A container name conflict means another container already uses `memos`; inspect it before removing or replacing anything. For a remote server, access the loopback-bound page through an SSH tunnel, or deliberately configure a reverse proxy and access controls instead of exposing the port casually.

## Make the data recoverable

Self-hosting puts the backup job on you. The [backup guide](https://usememos.com/docs/operations/backup-restore) identifies the database, local attachments, and deployment configuration as separate things to preserve. For the default SQLite setup, stop Memos before copying the data directory for an offline backup; store the copy somewhere other than the host and test a restore. If you use external databases or object storage, include those in the plan as well.

Before an upgrade, read the release and upgrade notes, take a recoverable backup, and record the image version and configuration. In particular, the [repository](https://github.com/usememos/memos) directs installations older than v0.31.0 to run that version once before upgrading further. A data volume survives container replacement, but it does not replace a backup or guarantee that an older release can read a migrated database.

## If you put it on a network

The local example avoids opening a service to the network. For a shared or internet-facing installation, review the [security guidance](https://usememos.com/docs/configuration/security): use HTTPS at a reverse proxy, choose the intended instance access policy, disable registration when it isn't needed, and review public memo visibility. A canonical instance URL and the access policy are separate settings; changing the URL does not change the policy of an existing instance.

Treat API tokens like passwords and give integrations their own tokens with appropriate expiry. Memos can be a convenient personal log, but operating it means maintaining the host, protecting accounts, applying updates, and checking backups. Start with a small private instance, then add access only when you know who needs it.
