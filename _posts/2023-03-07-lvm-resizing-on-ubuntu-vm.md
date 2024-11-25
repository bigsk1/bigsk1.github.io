---
title: Resizing LVM disk on Ubuntu VM
date: 2023-03-06 12:00:00  -500
categories: [ubuntu]
tags: [ubuntu,docs,resize,parted,proxmox,resize2fs,lvm,linux]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/ubuntu_logo.webp
---

## Resizing LVM storage in a 22.04 Ubuntu VM in Proxmox v7.3

So after searching the webs I was trying to resize a proxmox ubuntu vm using LVM storage but wasn't able to find the exact solution without piecing together a few different sites and fumbling through the steps. I was getting an error disk was in use following this guide 
<a href='https://kb.vander.host/disk-management/how-to-enlarge-an-ext4-disk-on-an-ubuntu-proxmox-vm/'>how-to-enlarge-an-ext4-disk-on-an-ubuntu-proxmox-vm</a>


### The Issue


You can select the VM in proxmox and go to hardware and then select your hard disk then select edit, resize ( can only add additional GB of space and not remove ) once you have your extra GB added you should be gtg right? NOPE. If your like me you don't like to give to much GB space to a VM if you don't know exactly what it will be used for in the long run, using a zfs pool of nvme ssd's is precious resources. You can always add later but not take away very easily. First always make a backup before messing around with any system changes. 

Ok so ssh into the Ubuntu VM. In my case was using Ubuntu 22.04 server and was setup on LVM storage using my zfs pool on proxmox. 

once in the command line change to root user using sudo su
then the below commands.

```shell
fdisk -l
```
noramlly /dev/sda   will show hard drive space, your drive could be different like /dev/sdb1, ect..

Take note it will show all partitions like

/dev/sda1

/dev/sda2

/dev/sda3


then do 

```shell
parted /dev/sda
```
using /dev/sda will end up showing (parted) waiting for the next command. type the word  print and then F

```shell
(parted) print

Warning: Not all of the space available to /dev/sda appears to be used, you can fix the GPT to use all of the space (an extra 1048576000
blocks) or continue with the current setting?

Fix/Ignore? F         

```
it will then show you the different numbers you can select. The partition to resize like 1, 2, 3, or however many partions you have on the disk. You will be able to tell as it is normally the larger size. We are only interested in the main partition we added the extra space to.

We will type resizepart ( then select the correct number to resize from above 1,2,3, ect ) mine in this example was 3.
Then type   100%

```shell
(parted) resizepart 3 100%
```
To exit out of parted type  quit

then use the below commands 

```shell
lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
```

and then 

```shell
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

Bingo now your Ubuntu 22.04 VM using LVM storage on proxmox will be correct size. Use the command to see if it worked.

```shell
df -h
```


Here is another guide on Proxmox forums that had some of the pieces to solve this but the above walk through is what I was able to do to get it to work. <a href='https://forum.proxmox.com/threads/resize-disk-of-ubuntu-19-10-vm-on-proxmox.70352/'>resize-disk-of-ubuntu-19-10-vm-on-proxmox.70352</a>


## Option2 if the first one didn't work

### This worked on Proxmox VM running Ubuntu 24.04 

1. First verify current disk status:
```bash
lsblk
```
```bash
df -h
```

2. Check Physical Volume status:
```bash
sudo pvs
```
```bash
sudo pvdisplay
```

3. Update partition table and resize Physical Volume:
```bash
sudo partprobe /dev/sda
```
```bash
sudo pvresize /dev/sda4
```

4. Verify Physical Volume was resized correctly:
```bash
sudo pvs
```
```bash
sudo pvdisplay
```
(Should show the full disk space and available free space)

5. Extend Logical Volume to use all free space:
```bash
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

6. Resize the filesystem to use the new space:
```bash
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

7. Verify new size:
```bash
df -h
```

**Note**: Replace `sda4` with your actual partition number if different. You can identify the correct partition by checking `lsblk` output - it will be the large partition that's part of the LVM.

These steps worked for Ubuntu 24.04 with an LVM setup, which is the default for Proxmox Ubuntu VMs.




















