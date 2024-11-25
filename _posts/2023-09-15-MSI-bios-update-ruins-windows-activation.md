---
title: MSI bios update bricks Windows 11 activation
date: 2023-09-15 12:00:00  -500
categories: [windows]
tags: [docs,msi,windows]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/msi.webp
---
# Windows 11 Activation Issues After MSI BIOS Update

## Introduction
Many users have reported issues with Windows 11 activation after updating their MSI BIOS and well as having your pin removed and having to remove and add your pin number for login again. This post aims to provide a comprehensive guide to discussing this issue. We'll cover the steps recommended by Microsoft, as well as alternative methods discussed in forums and YouTube videos. 

I did run the sfc /scannow option in windows and there were some files that were fixed so updating the bios caused issues within windows 11 OS. This issues seems to have been happening since 2022 and still no official fix. I am running a MSI Z790 ATX-E.

## Table of Contents
- [Windows 11 Activation Issues After MSI BIOS Update](#windows-11-activation-issues-after-msi-bios-update)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Microsoft's Official Solution](#microsofts-official-solution)
    - [Custom Installation via ISO File](#custom-installation-via-iso-file)
  - [Alternative Methods](#alternative-methods)
    - [Disabling TPM Before BIOS Update](#disabling-tpm-before-bios-update)
  - [Community Insights](#community-insights)
  - [Conclusion](#conclusion)

---

## Microsoft's Official Solution
I contacted microsoft and spoke with someone and the only thing they could offer is to reinstall windows and select keeping your folders and files intact. I have a highly customized and personalized version and the thought of weeks of customizations gone is not a fix. 

### Custom Installation via ISO File
1. Download the ISO file of Windows 10 from the [Media Creation Tool](https://www.microsoft.com/en-us/software-download/windows10).
2. Launch the Media Creation Tool and click on "Accept".
3. Choose "Create Installation Media".
4. Select "ISO" and save it on your Desktop.
5. Open the ISO file and navigate to the Source folder.
6. Click on the "Setup file".
7. A new window will open; click on "Next".
8. Choose "Custom installation".
9. Select the drive where you want to install Windows.
10. Click on "Next".

> **Note**: This process might take around half an hour. For a video guide, visit [Microsoft's official video](https://www.microsoft.com/en-us/videoplayer/embed/RE1ZWJz).

---

## Alternative Methods

### Disabling TPM Before BIOS Update
1. Go into the BIOS settings.
2. Disable the Firmware TPM option.
3. Save and reboot to Windows.
4. Perform the BIOS update.
5. Reboot and go back into the BIOS settings.
6. Re-enable the Firmware TPM option.

> **Note**: This method is based on a [YouTube video](https://www.youtube.com/watch?v=bihze7Srrtg) that suggests disabling TPM can help avoid deactivation issues.

---

## Community Insights
According to a [forum discussion](https://answers.microsoft.com/en-us/windows/forum/all/windows-activation-after-bios-update/0f57a891-dd68-4aad-b18e-2009cee13b43), users with a digital license face more challenges in reactivating Windows. Some suggest that entering a key, if available, might resolve the issue, but this is not guaranteed.

---

## Conclusion
Microsoft's official solution of reinstalling windows is crap and the community-provided methods are not 100% provide to work. Hopefully you bought your microsoft account with a key that could be entered again and it works. I ended up just buying another windows 11 pro license and said the hell with it time is money but reinstalling windows and keeping your personal files might be the only option at this point. Unless you know about this issue ahead of time and doing the disable TPM in bios first trick then you might have to reinstall windows.  

## Update 3/2024

So after updating the bios again and having the samething happen, I dug deeper and found a solution. It was very simple, you can use Microsoft Activation Scripts from github, it activates your Windows 10/11. Reading comments on the microsoft help center the microsoft techs actually have used this to solve such issues. You can find it here
[https://github.com/massgravel/Microsoft-Activation-Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)

Install Method - Traditional

    Download the file from GitHub or Bitbucket
    Right-click on the downloaded zip file and extract
    In the extracted folder, find the folder named All-In-One-Version
    Run the file named MAS_AIO.cmd
    SELECT 1
    You will see the activation options. Follow the on-screen instructions.
    That's all.

This solved the issue. 



