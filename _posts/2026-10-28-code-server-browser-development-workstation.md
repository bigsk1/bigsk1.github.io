---
title: 'code-server: A Browser-Based Development Workstation You Control'
date: '2026-10-28 20:16:39 -0700'
description: 'Run a browser-accessible development environment on your own Linux machine, with SSH forwarding and practical security boundaries.'
categories: [technology]
tags: [self-hosting, developer-tools, linux, open-source]
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/3df39397ed1a4ffdbbf5d57fe1c6101b/public
  alt: A remote workstation connected to a browser terminal
  hide_caption: true
---
A laptop need not carry every compiler, SDK, and repository you use. [code-server](https://github.com/coder/code-server) runs a VS Code-based editor on a machine you manage and exposes it through a browser. The files, terminal commands, and development tools live on that machine; the browser is the interface.

That makes it useful for a homelab workstation, a disposable development VM, or a lightweight client connecting to a more capable host. It is an established project, not a new release announcement. The repository is [MIT licensed](https://github.com/coder/code-server/blob/main/LICENSE) and maintains a public release history. This walkthrough follows the published documentation; it is not a report of a hands-on deployment.

## Where the work happens

With a desktop editor, your local machine normally holds the editor and its environment. With code-server, the remote host supplies the workspace and runs the tools. You can return to the same environment from another browser, but the host must be available and reachable. It also needs enough capacity for your actual builds, not just the editor. The project's [requirements](https://coder.com/docs/code-server) give a starting point of 1 GB RAM and two vCPUs, with WebSockets enabled.

This differs from VS Code Remote SSH, where you use the desktop VS Code client and connect it to a remote host. A browser interface is convenient on a machine where you cannot install that client, but browser keyboard shortcuts and extension compatibility can differ. It is also different from a managed cloud workspace: you own the host, updates, access controls, and backups.

## Start on a Linux host

Use a Linux machine with SSH access and an account intended to own the development files. The official [installation guide](https://coder.com/docs/code-server/install) documents packages and containers as well as an install script. Review what the script intends to do first:

```bash
curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
```

If the plan is appropriate for your host, the documented installer is:

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

Running a downloaded script gives it your account's privileges and may invoke the package manager. Review the script and choose a versioned package from the project releases instead if that fits your change process better. Follow the installer's instructions to start the service. The default configuration listens on localhost and uses password authentication; check the generated config at `~/.config/code-server/config.yaml` on the host. Keep its password private.

From your local computer, forward a local port over SSH, replacing the placeholder with your host and account:

```bash
ssh -N -L 8080:127.0.0.1:8080 user@your-server
```

Leave that session open and visit `http://127.0.0.1:8080` on the local computer. Sign in with the password from the host's config. The command assumes the host's code-server listener is on its default port; adjust the forwarding target if your configuration differs. If local port 8080 is occupied, use another local port, such as `8081:127.0.0.1:8080`, and visit that port instead.

The [access guide](https://coder.com/docs/code-server/guide) describes SSH forwarding and other approaches. It also shows disabling password authentication for its SSH example; keeping the default password provides an additional check in this walkthrough. Do not bind the service directly to the internet without authentication and encryption. A user who reaches its terminal can act with the server account's permissions.

## What to check before relying on it

Open a project and run its normal build or test command in the integrated terminal. The result depends on the toolchain installed on the host, not on software installed on the laptop. Back up repositories, uncommitted work, and any configuration you need to reproduce. A remote editor does not provide backups by itself.

Extensions deserve a trial before moving an established workflow. The project's [FAQ](https://coder.com/docs/code-server/FAQ) explains why it cannot use Microsoft's extension marketplace and how to install extensions by other supported means. A favorite extension may be missing or behave differently in a browser. Test the particular extensions and keyboard shortcuts you depend on.

If the page does not load, confirm the service is running and listening on the host, then check the SSH tunnel and its destination port. If the page loads but the editor cannot connect, inspect the service logs and check that any proxy supports WebSockets. For access without an SSH client, the project documents HTTPS reverse-proxy options; those require careful authentication, certificate, and network configuration. Keep the service patched and restrict who can reach it.
