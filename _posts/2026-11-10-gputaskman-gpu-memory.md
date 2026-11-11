---
title: 'GPU Taskman: Finding What Uses Your GPU Memory'
date: 2026-11-10 16:10:00 -0800
categories: [technology]
tags: [gpu, linux, windows, monitoring, open-source]
description: 'Inspect GPU memory and activity by process, while keeping measurements separate from model estimates.'
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/8be3818dc9524b2fad97d5f47a5194c6/public
  alt: GPU board with memory streams leading to model and display components
  hide_caption: true
---
A local model refuses to load, but the GPU still appears to have memory in use. Is another model running, or is the desktop consuming part of the budget? [GPU Taskman](https://github.com/shanselman/gputaskman) is an experimental, MIT-licensed terminal monitor intended to connect GPU usage with processes and, where evidence permits, the models and runtimes behind them.

The distinction matters: a process counter is a measurement; a model identification or a breakdown of its memory may be an estimate. The project is early software, and its visibility depends on the driver and operating system. This walkthrough follows the maintainer's documentation; the commands and GPU readings were not tested for this article.

## Start with the device and process list

The project documents Windows, Linux, WSL and Apple Silicon macOS support, with different capabilities on each. For an isolated installation with Python 3.11 or later and [uv](https://docs.astral.sh/uv/), its README gives:

```bash
uv tool install gputaskman
gputaskman
```

The supported GPU and driver still matter. For example, native Linux supports NVIDIA, AMD with `amdgpu`, and Intel with `i915`; WSL has different visibility. The [README](https://github.com/shanselman/gputaskman#linux-and-wsl) describes platform-specific requirements and also provides portable builds. Windows portable downloads are currently unsigned, according to the project; check the release and its checksum before running a downloaded executable.

The normal terminal view gives you a device-level starting point and process rows. Look at total used memory first, then compare it with the visible processes. Start or stop one known workload and watch what changes. A browser, display server, inference process and other workloads can all share a device, so a large total alone does not identify the responsible application.

For a one-shot or machine-readable view, the documented options include:

```bash
gputaskman --once
gputaskman --json
```

Treat the output as an observation at that moment. An unavailable value is different from zero; the project uses `null` for unavailable JSON counters. Avoid killing a process just because it appears in the list: identify its owner and purpose first.

## Read the model details carefully

GPU Taskman can use evidence such as mapped files and command lines to identify runtimes and model files. Its README says GGUF-derived model and buffer breakdowns are estimates. A mapped file does not prove the model is resident on the GPU or actively being used, and a CUDA library alone does not establish which model is running or whether it is training.

That makes the tool useful for forming a hypothesis: if an inference server is visible and the model evidence is consistent with the workload you started, compare the process memory with the device total. Confirm an unexpected result with your runtime's own logs and the driver tools. The estimate is a guide to investigate, not a direct dump of GPU memory.

[Tom's Hardware's November 8 report](https://www.tomshardware.com/pc-components/gpus/open-source-gpu-task-manager-reveals-exactly-whats-eating-your-vram-microsoft-vps-new-gpu-taskman-tool-reveals-every-process-using-your-gpu-how-much-memory-each-uses-and-breaks-down-ai-and-llm-workloads) described trying an earlier Windows release with a GPU benchmark. That is a separate observation on a particular machine, not a guarantee that every driver exposes the same fields.

## Why the platform changes the answer

On native NVIDIA Linux, the project documents process memory and utilization through NVML. On WSL, its default host integration matches process memory from Windows host counters; the README marks matches with `*` or `?`, and Linux-process GPU load is unavailable. With host integration disabled, WSL per-process VRAM is unavailable too. A missing counter should not be interpreted as an idle process.

On native AMD Linux, shared buffers and clients can make attribution ambiguous. The project deliberately reports some process values as unavailable instead of assigning shared bytes to a single process. Its documentation also notes that its stricter attribution rules have unit tests but had not yet been validated on AMD hardware. Intel `i915` has its own limitations, including device totals derived from client data rather than a single device-wide counter. Consult the [platform notes](https://github.com/shanselman/gputaskman#linux-and-wsl) for the exact driver and field before comparing numbers across machines.

For a first investigation, keep the workload small: note the baseline, start one known application, and compare the resulting device and process views. If a field is missing or marked uncertain, use it as a reason to inspect the driver and process visibility, not as proof that memory is free.
