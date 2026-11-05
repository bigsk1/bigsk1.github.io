---
title: 'Agent Desktop: Accessibility Trees for AI Computer Use'
date: 2026-11-04 16:00:00 -0800
categories: [development]
tags: [ai, automation, accessibility, developer-tools]
description: 'How agent-desktop uses accessibility trees and snapshot references to operate desktop applications.'
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/0f8a6f4514eb4b1a80722ca080a5a797/public
  alt: A desktop window connected to a branching accessibility tree
  hide_caption: true
---
An agent controlling a desktop needs more than a list of coordinates. Windows move, buttons change, and a click may have a real consequence. [agent-desktop](https://github.com/vercel-labs/agent-desktop), an Apache-2.0 project from Vercel Labs, exposes desktop accessibility trees as JSON so a calling agent can inspect controls, act on a reference, and inspect the result again.

The project supplies the tools, not the model or the decision loop. It is available as a CLI and a C library for macOS, Windows, and Linux. This is a project discovery based on its documentation, not a hands-on test.

## A tree instead of a coordinate guess

Desktop accessibility APIs describe interface elements by properties such as role, name, state, and available actions. Agent Desktop reads those structures through the platform's native accessibility system: AX on macOS, UI Automation on Windows, and AT-SPI on Linux. The result can identify a button as a button instead of requiring the caller to locate its pixels.

That depends on what the application exposes. An inaccessible or incomplete tree can leave the agent without the context it needs. The project also supports screenshots and physical input; an accessibility tree does not make every interface equally observable or every action safe.

## Observe, act, verify

The [snapshot documentation](https://agent-browser.dev/desktop/snapshots-and-refs) describes each snapshot as an observation of one application window, with references for actionable elements. A typical macOS exploration, adapted from the project's quick start, looks like this:

```bash
npm install -g agent-desktop
agent-desktop status
agent-desktop permissions --guide
agent-desktop snapshot --app Finder -i
```

The install includes native binaries; `status` reports platform and permission information. On macOS, the permissions guide covers the Accessibility grant. The snapshot returns JSON, including a snapshot ID and references such as `@s8f3k2p9:e8`. The actual reference must come from the current output, not this example.

An agent can then use a returned reference and check the result:

```bash
agent-desktop click '@s8f3k2p9:e8'
agent-desktop snapshot --app Finder -i
```

Replace the example reference with the intended control from the first snapshot. Quoting also matters in PowerShell, where a bare `@` token has special meaning. The second snapshot is the verification step: a successful command alone does not establish that the intended application state was reached.

## References have a lifetime

A reference includes its snapshot ID. A bare element identifier such as `@e8` is invalid. The tool stores evidence about the element and re-identifies it when an action runs; it does not simply retain a live handle forever. If the interface changes or the target cannot be identified reliably, the command can return an error such as `STALE_REF` or `AMBIGUOUS_TARGET`. Take a fresh snapshot and reassess the target rather than blindly repeating an action.

The snapshot's `complete` field also matters. A value of `false` means the observation ran out of budget. A partial tree is not evidence that a missing control does not exist. Interactive-only mode (`-i`) reduces the output, but can omit static labels that explain repeated buttons; inspect more context when the target is unclear.

## Choose the right boundaries

The project documents headless actions by default, with `--headed` for physical input where supported. Platform capabilities and permissions differ, so check the relevant platform guide before designing a workflow. Accessibility permissions can give software considerable reach into a desktop session: run automation in a suitable test account or isolated environment, limit what it can access, and require human review for consequential actions.

Snapshots, clipboard contents, screenshots, and logs may contain private data. Treat them as sensitive records rather than harmless debugging output. Agent Desktop provides the observation and interaction primitives; the surrounding application remains responsible for authorization, handling untrusted content, and deciding when to stop.

For a developer building an agent around existing desktop software, the useful experiment is small: inspect a non-sensitive app, select one unambiguous control, perform a reversible action, and compare the next snapshot. That exposes both the value of structured controls and the limits of the application's accessibility tree before the workflow takes on real work.
