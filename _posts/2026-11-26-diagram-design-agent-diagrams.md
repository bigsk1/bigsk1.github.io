---
title: 'Diagram Design: Give Coding Agents a Better Diagram Workflow'
date: 2026-11-26 16:00:00 -0800
categories: [development]
tags: [ai, diagrams, developer-tools, open-source]
description: 'A practical look at an agent skill for creating and revising architecture diagrams as HTML and SVG.'
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/d0634cbacc9949e588504fcd3f579f6c/public
  alt: An architecture diagram taking shape on a dark drafting surface
  hide_caption: true
---
A diagram can explain a system faster than a page of prose, but getting the boxes, labels, and arrows into a readable layout takes time. [Diagram Design](https://github.com/cathrynlavery/diagram-design) is an open-source skill that gives coding agents a set of design instructions and templates for that job. The agent produces an HTML file containing an SVG diagram that you can open in a browser, revise, or export.

It's a useful discovery for developers who already work with an agent and need an architecture sketch, sequence diagram, or visual for documentation. The output still needs review: a polished arrow can be just as wrong as a plain one.

## What the skill changes

The project supplies a design system and references for 52 diagram types. The [gallery](https://cathrynlavery.github.io/diagram-design/) shows examples ranging from data flows and deployment diagrams to sequence diagrams and dependency graphs. You describe the subject and intended audience; the agent chooses a layout and writes the artifact. The project's repository is MIT licensed.

The distinction from Mermaid is practical. Mermaid starts with a compact textual description and lets a renderer arrange it. Diagram Design asks an agent to author HTML and SVG using its layout guidance. That gives you an editable visual artifact, but also makes the result dependent on the agent's interpretation and layout decisions. Keep the original Mermaid or other source when it is your maintainable source of truth.

## Start with a bounded request

The [project README](https://github.com/cathrynlavery/diagram-design) documents a cross-agent installation through the `skills` CLI. It requires Node.js and an agent that supports Agent Skills:

```bash
npx skills add cathrynlavery/diagram-design
```

Choose the host and installation scope in the installer. Review the repository and the installer's selections before adding a third-party skill. The README also documents native marketplace installation for supported hosts; those packages include command surfaces that the standalone skills install does not. Use the instructions for your specific host rather than assuming every slash command is available everywhere.

Then ask the agent for a small diagram with explicit relationships, for example:

```text
Create a diagram-design architecture diagram for a documentation page.
Show a browser sending HTTPS requests to a reverse proxy, which routes to
an application. The application reads and writes PostgreSQL. Label the
arrows with their direction. Save the result as architecture.html.
```

Open the resulting HTML in a browser. Check the direction of every arrow, labels, boundaries, and whether the layout remains legible at the size where it will be used. Give the agent corrections against the saved file. A diagram based on a prompt is an interpretation, not a discovery of your actual deployment; provide repository context or a verified sketch when accuracy matters.

## Redraw existing diagrams carefully

The project documents imports from draw.io, Mermaid, Excalidraw, and PlantUML. Import is a redraw, not a lossless format conversion: the skill can adjust detail for a document or slide, and the README describes a fidelity ledger showing what was collapsed or dropped. Compare that ledger and the rendered result against the source before replacing a diagram. PlantUML support is limited to sequence and class diagrams according to the README.

The HTML can be exported to SVG or PNG. The documented PNG path uses Playwright and a Chromium installation; SVG is the better starting point when you need to edit vector shapes. Native packages expose export commands, while a standalone skill can be asked in natural language. Export the diagram at its intended display size and check small labels and line crossings rather than relying on a thumbnail.

## Know what leaves the machine

The maintainer's [privacy policy](https://github.com/cathrynlavery/diagram-design/blob/main/PRIVACY.md) says the skill itself has no analytics or server, but your agent provider still processes the material you give that agent under its own terms. The generated templates load Google Fonts when opened, exposing a browser request to Google. Remove the font link or use the documented system-font option for SVG export when that request is unwanted; system fallbacks change the appearance. Optional brand onboarding can fetch a site you specify.

Treat the HTML as an artifact to inspect before sharing, especially if a diagram includes internal hostnames or architecture details. For a repeatable workflow, keep the source diagram or a concise description alongside the generated file and review the visual again whenever the system changes.
