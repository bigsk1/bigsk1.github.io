---
title: "Kept: A Self-Hosted Inventory for Your Homelab and Home"
date: 2026-11-14 16:00:00 -0800
categories: [selfhosting]
tags: [homelab, inventory, docker, self-hosted]
description: "Track hardware, boxes, receipts, and loans with a self-hosted inventory app."
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/792d9bf7bd9e4c2ab8ca549296f578bc/public
  alt: A scanner points at a labeled component box beside a small server
  hide_caption: true
---
A spare SSD is only useful if you can find it. So is the warranty for the switch that failed, or the adapter you lent to a friend six months ago. [Kept](https://github.com/keptinventory/kept) is a self-hosted inventory application for recording those things, where they live, and the documents and history attached to them. It's an established project discovery, not a claim of a new launch.

The useful part is the relationship between a physical container and its contents. Label a box, scan it, and the inventory opens to the items inside. You can start with one shelf instead of attempting to catalogue the whole house in a weekend.

## Model the shelf before the entire house

Kept organizes inventory into locations, places, boxes, and things. A practical homelab might use a location for the house, a place for the office closet, and a box for spare network parts. Add a few items with quantities, photographs, and tags. The project also supports custom fields, purchases, documents, and racks measured in rack units. Search and saved views help when the number of items grows.

Its [feature list](https://github.com/keptinventory/kept) describes QR labels with short IDs, scan sessions for counting or moving items, and lending records with due dates. Those are useful for different problems: a label locates a box, a count tells you how much remains, and a loan record tells you who has the missing tool. A 3D location map and graph are available if a tree or list is not enough; building a map is optional overhead, not a prerequisite for an inventory.

## Run it with Docker Compose

The maintainers' [Compose guide](https://keptinventory.info/install/compose/) uses Docker with the Compose plugin and runs Kept alongside PostgreSQL. The following is the documented v1.14.7 example; inspect the downloaded Compose file and the current installation guide before running it. These commands have not been tested locally for this article.

```bash
mkdir kept && cd kept
curl -fsSLO https://raw.githubusercontent.com/keptinventory/kept/v1.14.7/compose.yaml
docker compose run --rm init
docker compose up -d
```

The `init` step asks for the address you will use, writes `.env`, and displays a setup code. Choose a stable DNS name reachable from your devices: the guide says printed QR links use that address. Open it, enter the code, and create the first account, which becomes the instance administrator. The default host port is 8080; the guide documents how to change it.

The stack starts the database, creates its logins, applies migrations, and starts Kept. The database does not need a published host port. If setup fails, inspect `docker compose ps` and `docker compose logs kept`, and consult the installation guide before changing configuration. Treat logs and the setup code as sensitive.

## HTTPS, backups, and the recovery kit

A working container is only the beginning. The documentation says camera access, app installation, push notifications, and location require HTTPS. Its optional full Compose file includes Caddy and Ollama profiles; review the [HTTPS instructions](https://keptinventory.info/install/compose/) and your network configuration before exposing the service.

Kept generates secrets used to protect stored sensitive values. The maintainers instruct administrators to retrieve the recovery kit with `docker compose exec kept kept admin recovery-kit` and store it somewhere other than the server. That command prints secrets: run it in a private terminal and keep the output in a secure location. The project documents encrypted restic backups to a directory, S3, or SFTP. Configure a separate backup destination and practice a restore; a backup stored only on the same failed disk is not a recovery plan.

## Where it fits

Kept can link receipts and manuals, track loans, and integrate with Home Assistant and Paperless-ngx. Its optional AI capture can suggest details from photos or receipts, but the project says a provider must be configured; manual entry remains available. Consider what data an external provider receives before enabling one. Self-hosting also means maintaining the host, updates, access controls, and backups yourself.

For a small collection, a spreadsheet may be quicker. Kept earns its place when you regularly need to answer where something is, what is inside a box, or who borrowed it. Start with the shelf that causes the most searching, label its containers, and expand only if the records stay useful.
