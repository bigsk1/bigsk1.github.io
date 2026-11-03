---
title: 'Handy: Local Dictation Without a Cloud Speech API'
date: 2026-11-02 16:00:00 -0800
categories: [technology]
tags: [open-source, speech-to-text, privacy, linux]
description: 'A practical look at Handy, an open-source desktop dictation app, and the compromises involved in running speech recognition locally.'
toc: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/0499fc9f64f343c4a06f231bd490d06d/public
  alt: Microphone and local computer connected by a glowing waveform
  hide_caption: true
published: true
---
A quick voice note should not require a browser tab and a cloud transcription account. [Handy](https://github.com/cjpais/Handy) is an MIT-licensed desktop app that turns a keyboard shortcut into dictation: speak, stop recording, and it pastes the result into the active text field. Its maintainers say recognition runs on the computer, without sending audio to a cloud service.

That makes Handy interesting for notes, messages, and rough drafts when typing is inconvenient. It is also a useful example of the compromises in local speech recognition: model downloads and compute happen on your machine, and desktop permissions and paste behavior still matter. This is a documentation-based overview; it is not a benchmark or a hands-on test.

## How the dictation path works

According to the [project README](https://github.com/cjpais/Handy), Handy records while a configurable shortcut is held or toggled, filters silence using Silero voice activity detection, runs a selected speech model, and inserts the resulting text into the current application. It supports Windows, macOS, and Linux. The project lists Whisper variants and Parakeet among its model choices; the right choice depends on your language, hardware, and tolerance for errors and delay.

The local processing claim does not mean the initial setup requires no network: the project documents downloading model files, including a manual installation path for restricted networks. It also documents optional post-processing. Check any enabled integrations and their destinations before dictating sensitive material. The target app, clipboard, local transcript history, and backups may have their own retention behavior.

## Get a first transcription

1. Download the appropriate package from the [official releases](https://github.com/cjpais/Handy/releases) or [project site](https://handy.computer/). Check the source and signature instructions in the README if your workflow requires artifact verification.
2. Launch the app, grant the requested microphone and accessibility permissions for your operating system, and choose a model and shortcut. A model may need to download first.
3. Focus a disposable text field, trigger the shortcut, speak a short sentence, and stop recording. Expect the recognized text to appear in that field. Review it before sending or executing anything: names, punctuation, and technical terms can be wrong.
4. Try a few representative phrases and model choices on your own hardware. The documentation describes capabilities; it does not establish accuracy or latency for your microphone, language, or environment.

On Debian or Ubuntu, the project recommends installing a downloaded `.deb` with APT so dependencies can be resolved:

```bash
sudo apt install ./Handy_*.deb
```

Run that from the directory containing the intended package, and inspect the package source before installing it. The wildcard should match only the version you intend to install.

## Linux: shortcuts and paste are the hard part

Linux desktop environments differ in how applications receive keyboard input. The [README's Linux notes](https://github.com/cjpais/Handy#linux-notes) recommend `xdotool` for X11 and `wtype` or `dotool` for Wayland, with a separate `ydotool` workaround for Ubuntu 26.04. Follow the linked distribution-specific instructions rather than assuming one command works everywhere. Adding a user to the `input` group for `dotool` changes device access, so understand that permission before choosing it.

On Wayland, the project says to configure a system-level shortcut in the desktop environment or window manager. Its documented command for a running instance is:

```bash
handy --toggle-transcription
```

If the text does not land where expected, check the focused window and the input tool first. The project also notes that the Linux recording overlay can steal focus; its default is disabled. If an old clipboard item appears instead of the transcript, the README describes paste-delay settings and an experimental reliable-paste option on macOS and Windows. Test changes in the receiving app, and redact dictated text before sharing diagnostic logs.

## Where it fits

Handy is a focused dictation utility, not a guarantee that every app will accept pasted text or that every model will understand specialized vocabulary. Local inference avoids sending audio to a remote speech API in the documented basic workflow, but it shifts model storage and processing to the desktop. For anyone who writes in many different applications, the shortcut-to-text workflow is worth trying with a non-sensitive sample before relying on it for longer work.
