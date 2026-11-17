---
title: "Plannotator: Review AI Agent Plans and Code Before They Ship"
date: 2026-11-16 16:00:00 -0800
categories: [development, ai]
tags: [ai, developer-tools, open-source, code-review]
description: "Use a local browser review surface to annotate coding-agent plans and inspect changes."
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/c46c6db9ad044a90bc593e11065ed6a2/public
  alt: A marked-up technical plan beside a code diff
  hide_caption: true
---
A coding agent can produce a plausible plan quickly. The difficult part is catching the missing constraint before it starts changing files, then connecting feedback to the actual diff afterward. [Plannotator](https://github.com/backnotprop/plannotator) puts those reviews in a local browser interface: select the relevant text or code, attach comments, and send the feedback back to the agent.

The open-source project supports several coding agents, including Claude Code, Codex and OpenCode. It is useful when a long terminal response makes precise feedback awkward, or when a change deserves a review pass before the agent moves on. It does not replace reading the code or running tests.

## Start with a plan on disk

The [installation guide](https://docs.plannotator.ai/open-source/start/installation) covers Linux, macOS, WSL and Windows. The standard installer downloads a release and configures supported agent integrations; it can also install hooks, skills and optional components. Read the script and the guide before running it, particularly on a machine with existing agent configuration. The guide also documents a minimal binary-only option and version pinning.

To try the review surface without depending on an agent hook, create a Markdown file named `plan.md`:

```markdown
# Add request logging

1. Add a request ID to the HTTP middleware.
2. Log the method, path, status, and duration.
3. Add tests for successful requests.
```

Then open it with the documented command:

```bash
plannotator annotate plan.md --gate
```

According to the [quickstart](https://docs.plannotator.ai/open-source/start/quickstart), this starts a temporary local server and opens the document in a browser. Select the test step and attach a comment asking for a failed-request case too. Send Feedback returns the annotations to standard output in this standalone flow; `--gate` also adds an Approve action. This makes it possible to check the review interaction before wiring it into an agent.

## Bring feedback back to the agent

Agent integrations differ. The project's installation guide says the standard installer enables an **experimental** Codex plan-review hook when it detects Codex on macOS, Linux or WSL; native Windows hooks remain disabled. OpenCode needs a separate plugin entry, while Claude Code needs its marketplace plugin. Follow the instructions for the host you actually use and restart it where directed.

Once integrated, review a proposed plan for boundaries that are easy to miss: which files may change, whether a migration needs a rollback, and how the agent should verify its work. Attach each correction to the relevant passage instead of sending a detached list that the agent must map back to the plan. Approval is a decision to proceed with that plan, not evidence that its implementation is correct.

## Review the resulting diff

Inside a version-controlled project, the quickstart lists:

```bash
plannotator review
```

The [repository](https://github.com/backnotprop/plannotator) describes a browser diff viewer for local changes and remote pull or merge requests, with line comments returned to the agent. Use it to compare the implementation against the approved plan: inspect changed files, check error paths and tests, and ask for corrections on specific lines. A clean-looking diff still needs the project's normal test and security checks.

For a large change, the project also describes guided review, where an agent groups the diff into chapters. Treat those summaries as a navigation aid; inspect the underlying diff yourself, especially around permissions, data changes and external calls.

## Know where the data goes

Local review and sharing are different choices. The repository says small shares are carried in the link itself; larger shares are encrypted before upload and expire after seven days. Anyone holding the full link can read the shared content. The documented `PLANNOTATOR_SHARE=disabled` setting turns sharing off. Avoid putting secrets in plans or diffs, and check the project's current privacy and sharing documentation before using shared links for sensitive work.

Plannotator is most useful as a pause point: review the plan while changes are cheap, then review the real diff before accepting it. Its integration and data boundaries depend on the host and options selected, so start with the standalone document flow and add automation only when it fits your workflow.
