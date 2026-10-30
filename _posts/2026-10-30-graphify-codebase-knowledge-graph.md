---
title: 'Graphify: Map a Codebase Before You Change It'
date: '2026-10-30 16:02:28 -0700'
description: 'Build and query a graph of code relationships, then trace its leads back to the source.'
categories: [development]
tags: [developer-tools, open-source, knowledge-graphs, ai]
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/ee93e02efa4048d1b555706bf811d989/public
  alt: A network of connected code modules illuminated on a dark workbench
  hide_caption: true
---
A search finds a name in a repository. Understanding how that name connects to the rest of the system takes more work. [Graphify](https://github.com/Graphify-Labs/graphify/blob/v8/README.md) builds a graph of those relationships and gives a coding assistant a way to query it. It can be useful when you're approaching an unfamiliar codebase or tracing the possible reach of a change.

This is a project discovery based on its documentation, not a hands-on test. Graphify's graph is a navigation aid: check the relevant source before relying on a connection for a change or review.

## What goes into the graph

According to the project's [architecture notes](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md), Graphify uses tree-sitter to extract code structure such as functions, classes, imports and calls. It can also incorporate documents and other media through a separate semantic pass. The resulting graph links concepts and organizes connected nodes into communities, which can help orient you before following individual paths.

The distinction between extraction and inference matters. An `EXTRACTED` relationship is grounded directly in source; an `INFERRED` relationship is a derived connection. Treat either as a pointer to inspect, especially when a dynamic call or a similarly named symbol could make the relationship less obvious. A graph is a snapshot, so refresh it after relevant files change.

For example, if you're changing a request handler, a path query may suggest a route to a database component. Follow the reported files and relationships to understand the call chain; don't assume the shortest graph path captures every runtime path or proves that a change is safe.

## Build a first map

The [README](https://github.com/Graphify-Labs/graphify/blob/v8/README.md) lists Python 3.10 or newer and `uv` or `pipx` as prerequisites. In a repository you are allowed to analyze, install the documented package and register the assistant integration:

```bash
uv tool install graphifyy
graphify install
```

The package name ends in two y's; the command is `graphify`. The installer writes assistant integration files, so review the project's installation documentation and choose a project-scoped installation if that better fits your setup. For Codex, the README documents `graphify install --project --platform codex` and uses `$graphify` as the assistant skill invocation. Other assistants use `/graphify`.

Invoke the skill for the current project from the assistant. The documented output is `graphify-out/graph.html` for browsing, `GRAPH_REPORT.md` for an overview, and `graph.json` for subsequent queries. Check the generated files and source paths before sharing them: even a derived graph can reveal internal names and architecture.

## Ask a narrower question

Once the graph exists, the documented CLI can explain a named concept or find a path between two names:

```bash
graphify explain "RequestHandler"
graphify path "RequestHandler" "DatabasePool"
```

Replace those names with symbols in your own graph. Start with a specific symbol, inspect its connections and source locations, then use ordinary source search and tests to confirm what happens. Graphify also documents `graphify query` for a scoped question and an update mode for changed files. The [architecture notes](https://github.com/Graphify-Labs/graphify/blob/v8/docs/how-it-works.md) describe a content-hash cache that skips unchanged files on subsequent extraction.

## Decide what can leave your machine

The project's documentation says the normal code-structure pass runs locally without an LLM, and a code-only corpus skips the semantic pass. Documents, images and transcripts are different: semantic extraction can use an assistant model or configured backend, depending on the setup. Review the selected input files, assistant settings, provider terms and potential token costs before analyzing mixed material. Local parsing of code is not a blanket guarantee that every assistant interaction or every input stays local.

Graphify is most useful as a map to investigate, not a substitute for reading code. Its output can narrow the next question; the repository and its tests still decide whether the answer holds.
