---
layout: post
title: 'Transmute: Run a File Conversion Service on Your Own Server'
date: 2026-11-23 19:35:00 -0800
categories: [selfhosting]
tags: [docker, selfhosting, file-conversion]
description: 'Run a shared file conversion and compression service with Docker, and understand its storage and network boundaries.'
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/c9e099be54ff49b7bbcd83d2ff3a6593/public
  alt: Files passing through a server-side conversion machine
  hide_caption: true
---
A file converter is useful until the file you need to convert is one you would rather not upload to a stranger's server. [Transmute](https://github.com/transmute-app/transmute) puts a conversion and compression service on your own machine, with a browser interface and an API for repeat jobs. It handles categories including images, audio, video, documents and structured data. The project is MIT licensed and is worth a look for a homelab or a small trusted team that already runs Docker.

The project appears in a [self-hosted open-source discovery list](https://github.com/tawanorg/trending-open-sources). This is a project discovery, not a new release announcement. Transmute's [latest release, v2.1.1](https://github.com/transmute-app/transmute/releases/tag/v2.1.1), dates to October 3, 2026. Its maintainers still caution that the app is designed for trusted networks. That warning matters when the service processes files through a collection of format-specific tools.

## One service for several conversion jobs

Instead of installing a separate desktop utility on each computer, you can run Transmute on a server and use its web interface from machines that can reach it. The project documents conversion and compression for images, media, documents, spreadsheets, subtitles and other formats. Check the [supported conversion list](https://transmute.sh/conversions) for the exact input and output pair before relying on it; support for a file type does not imply every possible conversion works.

The repository describes built-in accounts, role-based access, API keys and optional OIDC sign-in. Its running API documentation is available at `/api/docs`. That makes the service interesting for scripts as well as occasional browser uploads, though an API key is a credential and should be stored and scoped accordingly.

Compared with the site's earlier [File Converter for Windows](/posts/File-Converter/), Transmute is a shared web service rather than an Explorer context-menu utility. A desktop converter may be the simpler choice for one Windows machine. Transmute trades that integration for a service to install, secure, update and back up. The maintainers also say their project is not yet on par with the established services they list as alternatives.

## Start with the supplied Compose file

You need Docker Engine with the Compose plugin and enough disk space for uploaded files, output and temporary work. Review the [current Compose file](https://github.com/transmute-app/transmute/blob/main/docker-compose.yml) before starting it; downloading a file and executing it without reading it gives its author control over your deployment.

```bash
mkdir -p transmute && cd transmute
curl -fL -o compose.yaml https://raw.githubusercontent.com/transmute-app/transmute/refs/heads/main/docker-compose.yml
```

The supplied file uses `ghcr.io/transmute-app/transmute:latest`, publishes port 3313 and mounts the named volume `transmute_data` at `/app/data`. For an initial test on the Docker host, edit the port mapping in `compose.yaml` to bind only to loopback:

```yaml
ports:
  - "127.0.0.1:3313:3313"
```

Then start it and check its status:

```bash
docker compose up -d
docker compose ps
docker compose logs --tail=100 transmute
```

Open `http://127.0.0.1:3313` on that host. If you administer a remote server, a local SSH tunnel can reach the loopback-only service: `ssh -L 3313:127.0.0.1:3313 user@server`, then open the same URL on your workstation. The [getting-started guide](https://transmute.sh/docs/getting-started/) has the project's original quickstart.

For a repeatable deployment, choose a tested version tag instead of assuming `latest` will remain unchanged, and plan updates deliberately. The repository's release notes list the available version tags. Pinning does not remove the need to track security fixes.

## Treat files and storage as part of the deployment

The named volume keeps application data outside the container's writable layer. Include it in your backup plan and test restoration; replacing a container is not the same as having a recoverable copy of its data. Conversion output and uploads can also fill a disk, especially with large video jobs. Watch available space and review the application's retention settings for your use case.

Self-hosting changes where processing happens; it does not make a file automatically safe to open or guarantee privacy against everyone with access to the host, backups or service. Use trusted accounts, protect API keys, and consider the sensitivity of the files stored on disk. The project says files are processed on your server, but the operator remains responsible for the surrounding system and network.

## Keep the network boundary narrow

The [repository warning](https://github.com/transmute-app/transmute) recommends a reverse proxy with TLS and rate limiting if the service is exposed beyond the LAN. A private network or VPN is a sensible starting point. Authentication is useful, but it is not a reason to expose a conversion service broadly without considering the risks of parsing untrusted files.

The release history provides a concrete reason to update. [Version 2.1.0](https://github.com/transmute-app/transmute/releases) fixed several issues involving OIDC account linking, guest sessions and document conversion. Version 2.1.1 then disabled telemetry in a dependency introduced in 2.1.0, according to the maintainers. These are historical fixes, not a claim that an updated installation has no vulnerabilities. Check the current advisories and release notes before deployment, and keep the host and container image maintained.
