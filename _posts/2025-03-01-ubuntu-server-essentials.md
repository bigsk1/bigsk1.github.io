---
layout: post
title: Ubuntu Server Essentials
date: 2025-03-01 00:28:36 -500
categories: [networking, security]
tags: [comperhesive, guide, ubuntu, linux, setup]
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/cde693d9-8b76-4db8-d2f0-2505ef152100/public
---

---

## Setting Up a Secure Ubuntu 24.04 Server

When deploying a new Ubuntu server with a public-facing IP, proper security configuration is not optional—it's essential. This guide walks you through setting up a fresh Ubuntu 24.04 VPS or VM with hardened security, from initial access to a production-ready state.



## Initial Server Access

After provisioning your Ubuntu 24.04 server, you'll typically receive login credentials via email. Most providers give you root access initially, which we'll use to create a more secure setup.

### First Login

Connect to your server using SSH:

```bash
ssh root@your_server_ip
```

You'll be prompted to change the root password on first login with many providers. Choose a strong password you won't forget.

## Creating a Non-Root User

Running your server as root is a significant security risk. Let's create a regular user with sudo privileges:

```bash
# Create a new user
adduser yourusername

# Add user to sudo group
usermod -aG sudo yourusername
```

You'll be prompted to set a password and provide some optional information.

## Setting Up SSH Keys

SSH keys provide stronger security than password authentication. If you don't already have SSH keys on your local machine, generate them:

```bash
# On your local machine, not the server
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Now, copy your public key to the server:

```bash
# On your local machine
ssh-copy-id yourusername@your_server_ip
```

If `ssh-copy-id` isn't available, you can manually add your public key:

```bash
# On your local machine, copy your public key
cat ~/.ssh/id_ed25519.pub

# On the server, create the .ssh directory and authorized_keys file
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "your_public_key_here" > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Securing SSH Access

Now let's configure SSH for better security:

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config
```

Make the following changes:

1. Disable root login:
   
   PermitRootLogin no
   

2. Disable password authentication:
   
   PasswordAuthentication no
   

3. Change the default SSH port (optional but recommended):
   
   Port 2222  # Choose any unused port between 1024-65535
   

4. Allow only specific users (optional):
   
   AllowUsers yourusername
   

Save the file and restart SSH:

```bash
sudo systemctl restart sshd
```

> **Warning**: Before logging out, open a new terminal and verify you can log in with your SSH key to avoid locking yourself out!

## System Updates

Always keep your system updated:

```bash
# Update package lists
sudo apt update

# Upgrade installed packages
sudo apt upgrade -y

# Install security updates
sudo apt dist-upgrade -y

# Remove unnecessary packages
sudo apt autoremove -y
```

## Configuring Firewall with UFW

Ubuntu comes with Uncomplicated Firewall (UFW), which simplifies firewall management:

```bash
# Install UFW if not already installed
sudo apt install ufw -y

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (use your custom port if you changed it)
sudo ufw allow 2222/tcp  # Replace with your port

# Allow other services as needed
# sudo ufw allow 80/tcp  # HTTP
# sudo ufw allow 443/tcp  # HTTPS

# Enable the firewall
sudo ufw enable

# Check status
sudo ufw status verbose
```



![Digital firewall security concept with glowing shield and lock](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/e482b5fb-d596-48ed-6aea-2bf090254300/public "Server Security with UFW Firewall")

## Automatic Security Updates

Set up automatic security updates to ensure your server stays protected:

```bash
# Install unattended-upgrades
sudo apt install unattended-upgrades -y

# Configure automatic updates
sudo dpkg-reconfigure -plow unattended-upgrades
```

## Setting Up Fail2ban

Fail2ban helps protect against brute force attacks by temporarily banning IPs that show malicious behavior:

```bash
# Install fail2ban
sudo apt install fail2ban -y

# Create a local configuration file
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit the configuration
sudo nano /etc/fail2ban/jail.local
```

Modify the SSH section to match your setup:

```bash
[sshd]
enabled = true
port = 2222  # Match your SSH port
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
```

Start and enable fail2ban:

```bash
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
```

## Setting Up Timezone

Configure your server's timezone:

```bash
# List available timezones
timedatectl list-timezones

# Set your timezone
sudo timedatectl set-timezone Region/City  # e.g., America/New_York
```

## System Monitoring Tools

Install some basic monitoring tools:

```bash
# Install htop for process monitoring
sudo apt install htop -y

# Install iotop for disk I/O monitoring
sudo apt install iotop -y

# Install netstat for network monitoring
sudo apt install net-tools -y
```

## Securing Shared Memory

Add an extra layer of security by mounting `/run/shm` with noexec:

```bash
# Edit fstab
sudo nano /etc/fstab
```

Add this line:

```bash
tmpfs /run/shm tmpfs defaults,noexec,nosuid,nodev 0 0
```

Apply the changes:

```bash
sudo mount -a
```

## Regular Maintenance Schedule

Implement a regular maintenance schedule:

```bash
# Create a weekly update script
sudo nano /usr/local/bin/system-update.sh
```

Add the following content:

```bash
#!/bin/bash
apt update
apt upgrade -y
apt autoremove -y
apt autoclean
```

Make it executable:

```bash
sudo chmod +x /usr/local/bin/system-update.sh
```

Add it to crontab to run weekly:

```bash
sudo crontab -e
```

Add this line to run at 3 AM every Sunday:

```bash
0 3 * * 0 /usr/local/bin/system-update.sh > /var/log/system-update.log 2>&1
```

## Conclusion

You've now set up a secure Ubuntu 24.04 server ready for production use. This configuration provides:

- Non-root user with sudo privileges
- SSH key authentication
- Restricted SSH access
- Updated system packages
- Configured firewall
- Automatic security updates
- Protection against brute force attacks
- Basic monitoring tools

Remember that security is an ongoing process. Regularly review your server logs, keep software updated, and stay informed about new security vulnerabilities and best practices.

For production environments, consider additional security measures like intrusion detection systems, log monitoring solutions, and regular security audits depending on your specific needs.

This foundation gives you a secure starting point for hosting websites, running applications, or any other server tasks with confidence that your system is hardened against common threats.