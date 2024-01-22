---
layout: post
title: Windows Sandbox
date: 2024-1-19 05:00:00  -500
categories: [windows]
tags: [windows,docs]
image:
  path: /assets/images/headers/windows_sandbox.webp
  alt: Windows Sandbox logo
---


## Windows Sandbox enviroment inside of Windows
Windows Sandbox (WSB) is a lightweight virtual machine environment designed to safely run applications in isolation from the main operating system. This feature, available in Windows 10 and Windows 11 Pro, Enterprise, and Education editions, offers several advantages and use cases:
Descriptions and Advantages of Windows Sandbox (WSB):

-    Isolation: WSB provides a temporary, isolated environment. Anything you do inside the sandbox does not affect your main operating system, ensuring safety and cleanliness.

-    Security: It's an ideal solution for safely running untrusted or untested software. If the software turns out to be malicious or unstable, it won't harm your main system.

-    Testing and Development: Developers or testers can use WSB to test applications, scripts, or even new settings without risking their primary system configuration.

-    Ease of Use: Unlike traditional virtual machines, WSB is quick to set up and requires no separate license. It uses a small amount of your system's resources and is disposed of once closed.

-    Clean Environment: Each time WSB is started, it provides a clean, brand-new installation of Windows. This is particularly useful for testing software under default conditions.

-    Snapshot and Clipboard Sharing: While isolated, WSB allows for clipboard sharing and taking snapshots, making it easier to move information in and out of the sandbox.

Practical Use Case:

Scenario: Suppose you're a developer who needs to test a new software update but doesn't want to risk the stability of your primary system or deal with the overhead of a full-fledged VM.

Solution with WSB: You can use Windows Sandbox to create an isolated environment where you can install and run the new software. This approach allows you to monitor how the software behaves, test its features, and even intentionally try to break it to see how it handles errors, all without any risk to your actual operating system. If anything goes wrong, you simply close the sandbox, and everything is reset to a clean state for your next test.
Integration with Blog Code Examples:

In your blog, you can include specific examples of how to use Windows Sandbox for common tasks, like installing new software, testing scripts, or even how to configure the sandbox environment (like network settings or shared folders). Real-world examples will help your readers understand the practical benefits and how to implement them in their workflows.


## Examples I use

Replace the location of your host folder in these examples. You can name these files what ever you like but make sure you put the file extention as a .wsb 
like ( sandbox_shared.wsb ) Make sure to add a folder that already existing on your system. Create the file and then doubleclick it! It's that simple. Once you are done with it and close it, it is destroyed so if you want to keep anything between the sandbox and host system make sure host folder path is mapped.

### Sandbox for a Shared Enviroment

```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>Y:\win_sandbox_shared_folder</HostFolder>
            <ReadOnly>false</ReadOnly>
        </MappedFolder>
    </MappedFolders>
</Configuration>
```

### No Networking with Protections Enabled

```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>Y:\win_sandbox_shared_folder</HostFolder>
            <ReadOnly>true</ReadOnly>
        </MappedFolder>
    </MappedFolders>
	<ProtectedClient>Enable</ProtectedClient>
	<Networking>Disable</Networking>
</Configuration>
```
### No Networking -  Protections Enabled -  No clipboard


```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>Y:\win_sandbox_shared_folder</HostFolder>
            <ReadOnly>true</ReadOnly>
        </MappedFolder>
    </MappedFolders>
	<ProtectedClient>Enable</ProtectedClient>
	<Networking>Disable</Networking>
	<ClipboardRedirection>Disable</ClipboardRedirection>
	<PrinterRedirection>Disable</PrinterRedirection>
	<AudioInput>Disable</AudioInput>
	<vGPU>Disable</vGPU>
</Configuration>
```

### Protected Client -  Read Only with Networking

```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>Y:\win_sandbox_shared_folder</HostFolder>
            <ReadOnly>true</ReadOnly>
        </MappedFolder>
    </MappedFolders>
	<ProtectedClient>Enable</ProtectedClient>
</Configuration>
```

## Explanation of each option

```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>Y:\win_sandbox_shared_folder</HostFolder>
            <!-- HostFolder: Specifies the path to the folder on your host machine to be shared with the sandbox. -->
            <ReadOnly>true</ReadOnly>
            <!-- ReadOnly: When set to true, the sandbox can view but not modify the contents of the shared folder. -->
        </MappedFolder>
    </MappedFolders>
    <!-- MappedFolders: Defines one or more folders shared between the host and the sandbox. -->

    <ProtectedClient>Enable</ProtectedClient>
    <!-- ProtectedClient: If enabled, makes the sandbox operate as a protected client, enhancing security. -->

    <Networking>Disable</Networking>
    <!-- Networking: Disables network access in the sandbox, isolating it from the internet and local network. -->

    <ClipboardRedirection>Disable</ClipboardRedirection>
    <!-- ClipboardRedirection: Disables sharing of clipboard content between the host and the sandbox. -->

    <PrinterRedirection>Disable</PrinterRedirection>
    <!-- PrinterRedirection: Disables the ability of the sandbox to access printers configured on the host. -->

    <AudioInput>Disable</AudioInput>
    <!-- AudioInput: Disables the sandbox's access to the host's microphone and other audio input devices. -->

    <vGPU>Disable</vGPU>
    <!-- vGPU: Disables virtualized GPU support, which affects the ability to run graphics-intensive applications. -->
</Configuration>
```

## Additional Configurable Options


    MemoryInMB: Sets the amount of memory (RAM) in megabytes that the sandbox can use.
        Example: <MemoryInMB>2048</MemoryInMB>
        Note: This tag sets the sandbox to use 2 GB of RAM.

    LogonCommand: Defines a command that will run automatically when the sandbox starts.
        Example: <LogonCommand><Command>start msedge.exe</Command></LogonCommand>
        Note: This command will automatically open Microsoft Edge when the sandbox starts.

    VideoInput: Enables or disables access to the host's webcam.
        Example: <VideoInput>Disable</VideoInput>
        Note: Disables the sandbox's access to the host's webcam.

    EnableClipboardSharing: Allows sharing of clipboard content between the host and the sandbox.
        Example: <EnableClipboardSharing>true</EnableClipboardSharing>
        Note: Enables clipboard sharing, contrary to ClipboardRedirection.

    AudioOutput: Controls whether the sandbox can play sound.
        Example: <AudioOutput>Enable</AudioOutput>
        Note: Enables the sandbox to play sounds using the host's audio devices.


## Example of a Highly Configurable .wsb File

```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>C:\Path\To\Shared\Folder</HostFolder>
            <ReadOnly>false</ReadOnly>
        </MappedFolder>
    </MappedFolders>
    <MemoryInMB>4096</MemoryInMB>
    <LogonCommand><Command>start explorer.exe</Command></LogonCommand>
    <ProtectedClient>Enable</ProtectedClient>
    <Networking>Enable</Networking>
    <ClipboardRedirection>Enable</ClipboardRedirection>
    <PrinterRedirection>Enable</PrinterRedirection>
    <AudioInput>Enable</AudioInput>
    <AudioOutput>Enable</AudioOutput>
    <VideoInput>Enable</VideoInput>
    <vGPU>Enable</vGPU>
</Configuration>
```

This configuration sets up a Windows Sandbox with shared folders, ample memory, useful automatic startup commands, and full access to networking, clipboard, printers, audio, video, and GPU resources. Remember to adjust paths and settings according to your needs.


## Start sandbox - download firefox and install it

First make a script and add to Host Folder, call it firefox_download.bat

```bash
@echo off
PowerShell -Command "Invoke-WebRequest -Uri 'https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US' -OutFile 'FirefoxInstaller.exe'"
start FirefoxInstaller.exe /silent /install
```

then add a LogonCommand to your .wsb to run the batch script

```xml
<LogonCommand>
    <Command>C:\Users\WDAGUtilityAccount\Desktop\SharedFolder\firefox_download.bat</Command>
</LogonCommand>
```

###  Complete .wsb Configuration Example
Add your Host Folder path

```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>C:\Path\To\Shared\Folder</HostFolder>
            <ReadOnly>false</ReadOnly>
        </MappedFolder>
    </MappedFolders>
    <Networking>Enable</Networking>
    <LogonCommand>
        <Command>C:\Users\WDAGUtilityAccount\Desktop\SharedFolder\firefox_download.bat</Command>
    </LogonCommand>
</Configuration>
```


In this setup, when you start the sandbox, it will automatically run the batch script firefox_download.bat from the shared folder, which downloads and installs Firefox. After installation, Firefox should start automatically.

Remember to adjust the paths and script names according to your setup.
