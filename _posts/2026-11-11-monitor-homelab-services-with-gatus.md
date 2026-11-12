---
title: Monitor Your Homelab Services With Gatus
date: 2026-11-11 16:00:00 -0800
categories: [selfhosting]
tags: [monitoring, homelab, docker, open-source]
description: Use Gatus to check service responses and spot failures in a self-hosted stack.
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/1fc554a5013343279218756392781931/public
  alt: A homelab server rack checks connected service modules, one showing an amber fault
  hide_caption: true
---
A container can be running while the service inside it returns errors. Gatus gives a homelab a different view: it periodically probes endpoints, evaluates conditions, and shows the results on a dashboard. It can also send alerts when checks fail.

[Gatus](https://github.com/TwiN/gatus/blob/master/README.md) is an open-source health dashboard configured in YAML. This is a practical look at an established project, not a new launch. Its maintainer's [v5.38.0 release notes](https://github.com/TwiN/gatus/releases/tag/v5.38.0), published October 28, 2026, list a Resend alert provider and fixes for maintenance windows and WebSocket timeouts. The setup below follows the project documentation; it was not run locally for this article.

## What a health check can tell you

Gatus supports HTTP, TCP, ICMP and DNS checks among other protocols. An HTTP check can test the status, response time, and even a value in a JSON body. That makes a health endpoint more informative than a check that only confirms a port accepts connections. An endpoint is unhealthy if any of its configured conditions fails.

A check still sees only what its probe can reach and what its conditions measure. A green login page does not prove that backups work, or that a user can complete a transaction. Pick a lightweight health endpoint that reflects a dependency you actually care about, and avoid exposing sensitive response data on the dashboard.

## Try a local dashboard

You need Docker and a service reachable from the container. For a first check, create a directory and save this as `config.yaml`:

```yaml
endpoints:
  - name: example-site
    url: "https://example.org/"
    interval: 5m
    conditions:
      - "[STATUS] == 200"
      - "[RESPONSE_TIME] < 3000"
```

The response-time threshold is in milliseconds. Adjust it to a useful baseline for your own service; an arbitrary tight threshold can turn normal variation into noise. Replace the example URL with a service address reachable from inside the container. `localhost` inside that container refers to the container itself, not automatically to the Docker host.

From the same directory, start the container using the [documented bind-mount approach](https://github.com/TwiN/gatus/blob/master/README.md#docker):

```bash
docker run --rm --name gatus -p 127.0.0.1:8080:8080 \
  --mount type=bind,source="$(pwd)"/config.yaml,target=/config/config.yaml \
  ghcr.io/twin/gatus:stable
```

Open `http://localhost:8080` on the Docker host and allow time for a check. The loopback binding keeps this example's dashboard off other network interfaces. Stop the foreground container with Ctrl+C. The `stable` tag can move; for a repeatable deployment, choose and maintain an appropriate pinned image version.

If the check fails, inspect the container logs and verify DNS, routing, the target URL, and its expected status from the container's network. A healthy response from your laptop alone does not establish that the container can reach the same address.

## Make the checks useful

For a JSON health endpoint, Gatus supports conditions such as `"[BODY].status == UP"` alongside an HTTP status check. Use that only when your service actually returns the expected JSON field. The project also documents certificate-expiration conditions, TCP and DNS checks, and [alert integrations](https://github.com/TwiN/gatus/blob/master/README.md#alerting). Configure a notification route and test it before relying on it; a dashboard no one watches is easy to miss.

Gatus reloads updated configuration, but the maintainer warns that mounting a single file can prevent change detection. Mount the configuration directory when live reload matters, and check logs after edits. The default storage is in memory, so plan persistent storage if retaining history across restarts matters; consult the project's [storage documentation](https://github.com/TwiN/gatus/blob/master/README.md#storage) before choosing a backend.

Finally, put monitoring somewhere that can observe the failure you care about. A monitor on the same host as every service may disappear with that host. An independent external check and a tested alert route provide a useful second vantage point.
