---
layout: post
title: Pi-hole Meets Unbound
date: 2025-03-01 04:56:30 -500
categories: [technology, general]
tags: [pihole, unbound, proxmox]
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/3c1284a5-0370-439c-5f68-72d01c2b8800/public
---

In today's digital landscape, privacy and security are paramount concerns. While many solutions exist, combining Pi-hole and Unbound in a Proxmox virtual environment creates a powerful shield against unwanted content and surveillance. This setup not only blocks ads but also provides recursive DNS resolution, keeping your browsing habits private. Let's dive into how you can build this privacy-enhancing stack on your home network.

## Why Pi-hole and Unbound?

![Inline image 1 related to Pi-hole Meets Unbound](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/b281eadb-4594-4348-5ff5-dade21de8100/public)



Pi-hole serves as a network-wide ad blocker that intercepts DNS requests for known advertising domains and returns empty responses. Unbound complements this by functioning as a validating, recursive DNS resolver that queries root servers directly instead of relying on your ISP's DNS servers.

Together, they offer several benefits:

- Network-wide ad blocking without installing browser extensions
- Enhanced privacy by eliminating third-party DNS providers
- Reduced tracking across websites
- Lower bandwidth usage by blocking unnecessary content
- DNS Security Extensions (DNSSEC) validation
- Improved browsing speed

## Setting Up Proxmox for Our Project

Proxmox Virtual Environment provides an ideal platform for hosting both Pi-hole and Unbound. Its lightweight hypervisor allows you to run multiple virtual machines efficiently on modest hardware.

To begin, you'll need a Proxmox installation on compatible hardware. A small server or even a repurposed desktop with virtualization support will suffice. The beauty of this approach is that you can run these privacy tools alongside other home server applications while keeping them isolated.

### Creating the Virtual Machine

For optimal performance, I recommend the following specifications for your VM:

- 1 CPU core (2 cores for better performance)
- 2GB RAM
- 16GB storage
- Debian 11 or Ubuntu 20.04 LTS as the base OS

In Proxmox, create a new VM with these settings:

1. Select "Create VM" from the top right
2. Assign a VM ID and name (e.g., "Pi-hole-Unbound")
3. Choose your OS template (Debian/Ubuntu)
4. Configure CPU, memory, and storage as recommended
5. Set up networking with a static IP on your local network
6. Start the VM and complete the OS installation

> **Note** Assigning a static IP address to your VM is crucial since this will be your network's DNS server.

## Installing and Configuring Pi-hole

Once your VM is up and running with the base OS installed, it's time to set up Pi-hole.

### Pi-hole Installation

SSH into your VM and run the official Pi-hole installation script:

```bash
curl -sSL https://install.pi-hole.net | bash
```

During installation, you'll be prompted to select:
- Your network interface
- Upstream DNS provider (choose any; we'll switch to Unbound later)
- Block lists to use
- IP protocols (IPv4/IPv6)
- Static IP confirmation
- Web admin interface installation

After installation, set a secure admin password:

```bash
pihole -a -p
```
### Basic Pi-hole Configuration

Access the Pi-hole web interface by navigating to `http://YOUR_VM_IP/admin` in your browser. Here you can:

- View statistics on blocked domains
- Add custom block lists
- Whitelist necessary domains
- Configure other Pi-hole settings

## Installing and Configuring Unbound

Now let's set up Unbound to work alongside Pi-hole, providing recursive DNS resolution.

### Unbound Installation

Install Unbound and required utilities:

```bash
apt update
apt install unbound unbound-anchor dnsutils -y

### Configuring Unbound

Create a new configuration file:

```bash
nano /etc/unbound/unbound.conf.d/pi-hole.conf
```

Add the following configuration:

```bash
server:
# If no logfile is specified, syslog is used
verbosity: 0

interface: 127.0.0.1
port: 5335
do-ip4: yes
do-udp: yes
do-tcp: yes

# May be set to yes if you have IPv6 connectivity
do-ip6: no

# You want to leave this to no unless you have *native* IPv6
prefer-ip6: no

# Use this only when you downloaded the list of primary root servers!
root-hints: "/var/lib/unbound/root.hints"

# Trust glue only if it is within the server's authority
harden-glue: yes

# Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
harden-dnssec-stripped: yes

# Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
use-caps-for-id: no

# Reduce EDNS reassembly buffer size
edns-buffer-size: 1232

# Perform prefetching of close to expired message cache entries
prefetch: yes

# One thread should be sufficient, can be increased on beefy machines
num-threads: 1

# Ensure kernel buffer is large enough to not lose messages in traffic spikes
so-rcvbuf: 1m

# Ensure privacy of local IP ranges
private-address: 192.168.0.0/16
private-address: 169.254.0.0/16
private-address: 172.16.0.0/12
private-address: 10.0.0.0/8
private-address: fd00::/8
private-address: fe80::/10
  ```
### Downloading Root Hints

For Unbound to function as a recursive resolver, it needs a list of root DNS servers:

```bash
wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache
```

Create a cron job to update these hints monthly:

```bash
echo '0 0 1 * * wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache' | crontab -
```
### Starting Unbound

Restart Unbound to apply the configuration:

```bash
service unbound restart
```

Test that Unbound is working correctly:

```bash
dig @127.0.0.1 -p 5335 www.example.com
```

## Connecting Pi-hole to Unbound

Now we need to configure Pi-hole to use our local Unbound instance as its upstream DNS server.

1. Access the Pi-hole web interface
2. Navigate to Settings > DNS
3. Uncheck all upstream DNS servers
4. Add `127.0.0.1#5335` as a custom upstream DNS server
5. Enable DNSSEC
6. Save your settings

## Configuring Your Network

The final step is to configure your router to use Pi-hole as the DNS server for your entire network:

1. Log in to your router's admin interface
2. Find the DHCP/DNS settings
3. Set the primary DNS server to your Pi-hole VM's IP address
4. Save your settings

Alternatively, you can configure individual devices to use Pi-hole as their DNS server.

## Maintenance and Monitoring

### Regular Updates

Keep both Pi-hole and Unbound updated:

```bash
# Update Pi-hole
pihole -up

# Update system and Unbound
apt update && apt upgrade -y
```

### Monitoring Performance

Pi-hole's dashboard provides valuable insights into your network's DNS queries. Regularly check:

- Top domains being queried
- Top clients making requests
- Blocked domains
- Query types

### Troubleshooting

If you encounter issues:

- Check Pi-hole logs: `pihole -t`
- Check Unbound logs: `journalctl -u unbound`
- Verify DNS resolution: `dig @PI_HOLE_IP example.com`
- Test DNSSEC validation: `dig @PI_HOLE_IP dnssec-failed.org`

## Taking It Further

Once your basic setup is working, consider these enhancements:

- Add more comprehensive blocklists to Pi-hole
- Set up regular backups of your VM
- Configure failover DNS for when your system is unavailable
- Implement DoH (DNS over HTTPS) or DoT (DNS over TLS) for added security

## Conclusion

The combination of Pi-hole and Unbound running in a Proxmox VM creates a powerful privacy solution for your home network. This setup blocks unwanted content, prevents tracking, and keeps your DNS queries private from your ISP and third parties.

While the initial configuration requires some technical knowledge, the long-term benefits to your privacy and browsing experience make it well worth the effort. Plus, hosting these services in a Proxmox VM provides the flexibility to adjust resources as needed and run other services alongside your privacy stack.

By taking control of your DNS resolution, you've taken a significant step toward a more private and secure digital life. As online tracking becomes increasingly sophisticated, solutions like this become not just nice-to-have but essential components of a privacy-conscious network.