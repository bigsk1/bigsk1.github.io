---
layout: "post"
title: "Container Proxy: Different Proxy Routes for Firefox Containers"
date: "2026-10-27 22:21:15 -0700"
description: "Assign and verify per-container proxy routes in Firefox, with clear limits on what the extension protects."
categories: ["privacy"]
tags: ["firefox", "proxy", "privacy", "open-source"]
toc: true
published: true
image:
  path: "https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/cd6a13cd7b4241569ad0a9698dfa4301/public"
  alt: "Browser container paths connected to separate proxy nodes"
  hide_caption: true
---
Firefox containers separate browsing identities, but they don't automatically give each identity a different network exit. Container Proxy is one of my projects: a Firefox extension that assigns a proxy to an individual container, while leaving other contexts on Firefox's existing route. A work container could use one HTTP proxy while a research container uses a different SOCKS5 server. Neither choice requires changing the browser-wide proxy every time you switch tabs.

The [project repository](https://github.com/bigsk1/container-proxy) documents version 1.1.1 and its routing limits. 

## Set up a route

You'll need desktop Firefox 140 or later, a container, and a reachable proxy endpoint. The extension manages proxy assignments; it does not provide the proxy server or subscription. Install it from the existing [Mozilla Add-ons listing](https://addons.mozilla.org/en-US/firefox/addon/container-proxy-v1-0-3/), which currently lists version 1.1.1.

1. Create a Firefox container using the new-tab button or container settings.
2. Open Container Proxy and choose **Assign proxy** for that container.
3. Select the protocol and enter the hostname or IP address, port, and optional label and credentials. Save the assignment.
4. Use **New tab** to open that container and browse to a trusted destination that shows your exit IP.

If the popup asks you to **Grant website access**, grant it for routing to work. Reload existing tabs after changing an assignment; connections already established aren't disconnected by the change. A local Gluetun HTTP proxy, for example, needs an address and port Firefox can actually reach, such as `127.0.0.1:8888` if that port is published on the same machine. Use the authentication configured on that proxy.

**Validate** checks the format of the settings. Likewise, **Proxy enabled** says the assignment is enabled, not that the server is reachable or that traffic emerged at the expected address. Test the route in a new tab and investigate the endpoint or credentials if it fails. The extension doesn't call an external IP-check service automatically. See the [installation and usage notes](https://github.com/bigsk1/container-proxy#install-and-use).

## Choose the right protocol

The proxy choice affects both transport and DNS. The [protocol notes](https://github.com/bigsk1/container-proxy#protocols-and-protection) describe four options:

| Proxy | Connection to the proxy | DNS for proxied destinations |
| --- | --- | --- |
| HTTP | The proxy protocol provides no transport encryption | Handled by the HTTP proxy |
| HTTPS | TLS protects the connection to the proxy | Handled by the HTTP proxy |
| SOCKS5 | SOCKS itself does not encrypt transport | Remote DNS is enabled for supported requests |
| SOCKS4 | Legacy protocol without transport encryption or password authentication | Local DNS |

An HTTPS website still uses its own TLS when tunneled through a proxy. SOCKS5 remote DNS is useful, but it is not a VPN or encryption by itself. The proxy operator can observe destination metadata and any traffic that lacks end-to-end encryption. Choose an operator accordingly.

## Understand what happens when a route changes

A container's assignment can be edited or paused in the popup or settings page. Paused and unassigned containers, default tabs, and private windows use Firefox's existing routing, which may itself include a browser-wide proxy. That distinction matters if your baseline route is not direct.

For enabled assignments, the extension returns a proxy list ending in `null` to prevent fallback to a browser-defined proxy. It blocks intercepted container requests when saved assignments are invalid or settings cannot be read. These protections apply within the extension's supported request handling; they do not make the whole machine fail closed. The [README's protection notes](https://github.com/bigsk1/container-proxy#protocols-and-protection) explain those boundaries.

Container Proxy does not cover other applications, WebRTC UDP, every Firefox system request, or traffic outside Firefox's proxy API. Disabling the extension, removing its website access, or another extension taking over routing removes its protection. Review Firefox's WebRTC and proxy configuration if IP exposure matters to your use case. A separate VPN or firewall policy may be appropriate when you need controls beyond browser requests.

## Settings, credentials, and backups

The extension stores hostnames, labels, and credentials in Firefox's local extension storage. It does not encrypt that storage or use Firefox Sync; anyone who can read the profile files may be able to read the settings. The [privacy policy](https://github.com/bigsk1/container-proxy/blob/main/PRIVACY.md) says the extension has no telemetry, developer-operated backend, remote code, or browsing-history log. That does not prevent your chosen proxy from seeing the traffic described above.

**Settings & backups** can export and import routes. Exports omit usernames and passwords by default. If you explicitly include them, the JSON contains plaintext secrets and needs private storage. On restore, create matching container names first: imports match unique names rather than profile-specific container IDs, validate assignments, and ask for confirmation before replacing matching routes. Unrelated assignments remain in place.

The source is available under the [MIT license](https://github.com/bigsk1/container-proxy/blob/main/LICENSE). For people who already use Firefox containers, the useful part is the narrow control: pick a route per identity, verify the actual exit, and keep the limits of browser-level routing in view.
