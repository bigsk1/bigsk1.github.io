---
title: 'Verdaccio: Run a Private npm Registry and Package Cache'
date: 2026-11-20 18:17:00 -0800
categories: [development]
tags: [npm, selfhosting, docker, javascript]
description: 'Try a local npm-compatible registry, understand its cache, and plan for persistent storage and access control.'
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/475a29cc25f2446e817be94f892dfca7/public
  alt: Package crates passing through a private registry gateway
  hide_caption: true
---
[Verdaccio](https://github.com/verdaccio/verdaccio/tree/6.x) gives npm clients a registry you can run yourself. It can host private packages and proxy an upstream registry, caching downloaded packages as they pass through. That makes it useful for testing package publication and sharing internal modules without sending their source to the public registry.

A cache is not a complete offline mirror: it only helps with content already available locally, and a first request may still need the upstream. Treat this walkthrough as a local experiment; a shared service needs persistent storage, access controls, backups, and HTTPS.

## Start a disposable registry

With Docker installed, start the stable version 6 image and bind its port to your own machine:

```bash
docker run --rm --name verdaccio -p 127.0.0.1:4873:4873 verdaccio/verdaccio:6
```

Leave that terminal running and open `http://localhost:4873` in a browser. The [official Docker guide](https://www.verdaccio.org/docs/docker/) documents the image and port; binding to loopback keeps this example off other network interfaces. Stop the container with Ctrl-C. Because this example uses `--rm` and no persistent mount, its container storage disappears when it stops. Do not use it for packages you need to keep.

## Send one install through the proxy

In another terminal, from a disposable test project with a `package.json`, direct one npm command to the local registry:

```bash
NPM_CONFIG_REGISTRY=http://localhost:4873 npm install
```

The environment variable applies to that command rather than changing your global npm configuration. Verdaccio's [version 6 README](https://github.com/verdaccio/verdaccio/tree/6.x) documents this pattern. Try it with a project whose dependencies you are comfortable downloading, then watch the registry terminal for requests. Existing lockfiles can contain resolved URLs, so inspect them if traffic does not go where you expect.

The proxy can reduce repeated upstream downloads and provide limited access to cached content during an upstream outage. It does not guarantee that every version or metadata request is cached, and it is not a substitute for a tested backup or an offline dependency strategy.

## Move from experiment to service

For a registry that survives restarts, persist its storage and configuration. The [Docker documentation](https://www.verdaccio.org/docs/docker/) describes volumes and bind mounts: a mounted configuration directory must already contain `config.yaml`, and bind-mounted directories must be writable by the container's non-root user. Test restore procedures as well as backups; keeping a volume is only the first step.

Before allowing other machines to connect, review the package access and publish rules, authentication, and upstream configuration. The sample configuration is a starting point, not a production security policy. Put the service behind appropriately configured TLS, restrict network access, and protect credentials used by CI. Pin an image version appropriate to your update process, and review releases before upgrading.

For a small team, the useful distinction is control over the package path: private packages can live on infrastructure you manage, while public dependencies can still be fetched through an upstream. That control also brings responsibility for availability, storage capacity, upgrades, and recovery.
