---
title: 'Agent Browser: A Shell Workflow for Browser Automation'
date: 2026-11-09 16:40:00 -0800
categories: [development]
tags: [browser-automation, developer-tools, open-source, ai]
description: 'Use accessibility snapshots and short shell commands to navigate and inspect a browser with agent-browser.'
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/d5de185c3ccf4232a17b3ff2e82a1182/public
  alt: Terminal connected to a structured browser interface
  hide_caption: true
---
A browser automation task often needs a loop: open a page, inspect what is actually there, choose an element, and verify the result. [agent-browser](https://github.com/vercel-labs/agent-browser) exposes that loop as shell commands. Its snapshots describe page elements with short references, so an agent or script can act on a current page without guessing coordinates.

This Apache-2.0 project from Vercel Labs is an established tool, not a new release announcement. It is useful when a command-line agent needs to explore a web interface, reproduce a flow, or inspect a local development page. The examples below follow the project's documentation; they have not been run for this article.

## Install and open a page

With Node.js and npm available, the project documents this installation:

```bash
npm install -g agent-browser
agent-browser install
```

The second command downloads Chrome for Testing. On Linux, the documented `agent-browser install --with-deps` also installs browser system libraries; review what it requires for your environment before running it. See the [project README](https://github.com/vercel-labs/agent-browser) for other installation options and platform support.

Start with a page that does not require credentials:

```bash
agent-browser open example.com
agent-browser snapshot -i
```

The interactive snapshot lists elements and references such as `@e1`. Read the output before choosing one: the reference is assigned from the current page, so its meaning depends on the snapshot. For example, if the snapshot identifies the desired link as `@e1`:

```bash
agent-browser click @e1
agent-browser get url
agent-browser close
```

The URL check shows where the browser ended up; it does not by itself prove the whole page behaved correctly. Inspect the resulting page when the task depends on its contents. After navigation or a DOM change, take another snapshot before using references again. The project also documents selectors and semantic locators for cases where a reference is not the right fit.

## Understand the running browser

The CLI talks to a background daemon that starts with the first command and controls the browser through the Chrome DevTools Protocol. The browser stays open between commands. Named sessions each get their own daemon and browser, which helps separate concurrent tasks. According to the README, an idle headless browser closes after an hour by default; configured session persistence saves state first.

This makes the workflow convenient for an agent working one step at a time, but it also means browser state can outlive an individual shell command. Close a session when finished, and handle any saved state as sensitive: cookies can represent a logged-in account. Avoid attaching automation to a personal browser profile when a disposable test account and isolated session will do.

## Treat page content as untrusted

A page can contain instructions aimed at the agent as well as ordinary data. Decide which sites and actions a task needs before letting an agent interact with them, and require human review for consequential actions such as sending messages, changing settings, or submitting purchases.

The project's [security documentation](https://agent-browser.dev/security) says navigation, action, and output restrictions are opt-in; the default does not restrict them. It documents domain, action, and output controls for deployments that need them. Configure and test the controls for your own environment rather than assuming that installing the CLI creates a sandbox. Browser isolation, credentials, and the permissions of the surrounding agent still matter.

## Where it fits

For a quick interface investigation, snapshots make the sequence visible: inspect, act, then inspect again. Screenshots, recordings, network inspection, and named sessions are available when a text snapshot is insufficient. For a stable regression suite, choose selectors and assertions deliberately and run against controlled test data; a successful click alone is not a test of the application's outcome. The [command reference](https://agent-browser.dev/commands) lists the available operations and options.
