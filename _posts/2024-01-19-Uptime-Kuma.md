---
title: Uptime Kuma Website monitoring tool
date: 2024-1-18 02:00:00  -500
categories: [docker]
tags: [docs,windows,linux,docker,self-hosting] 
image:
  path: /assets/images/headers/uptime.webp
---

## A fancy self-hosted monitoring tool 

Uptime Kuma is a self-hosted monitoring tool that allows you to keep track of the uptime and downtime of various internet services and websites. It's essentially a personal status page and monitoring server. Here are some key features and benefits:

 -   Self-Hosted and Open Source: Uptime Kuma is completely open-source and can be self-hosted, which means you have full control over the monitoring process and data. This is particularly beneficial for those who prefer to manage their monitoring systems within their own infrastructure for privacy and customization reasons.

 -   Multiple Monitoring Types: It supports various types of monitoring methods, such as HTTP(s), TCP, HTTP(s) Keyword, Ping, DNS Record, and more. This flexibility allows you to monitor a wide range of services effectively.

-    Alerts and Notifications: Uptime Kuma provides real-time notifications when a monitored service goes down or becomes unreachable. You can receive these alerts through various channels like Telegram, email, webhook, and more, enabling quick response to issues.

 -   Dashboard and Statistics: It offers a user-friendly dashboard that displays the status of all monitored services. You can see uptime percentages, response times, and other critical metrics, which can help in analyzing the performance and reliability of your services.

 -   Customizable and Extendable: Since it's open source, you can customize and extend its functionalities according to your specific monitoring needs.

Uptime Kuma is a versatile and user-friendly tool that helps in proactive monitoring of web services, ensuring you're immediately alerted to any downtime or performance issues, which is crucial for maintaining a good user experience and service reliability.


## ⭐ Features

- Monitoring uptime for HTTP(s) / TCP / HTTP(s) Keyword / HTTP(s) Json Query / Ping / DNS Record / Push / Steam Game Server / Docker Containers
- Fancy, Reactive, Fast UI/UX
- Notifications via Telegram, Discord, Gotify, Slack, Pushover, Email (SMTP), and [90+ notification services, click here for the full list](https://github.com/louislam/uptime-kuma/tree/master/src/components/notifications)
- 20-second intervals
- [Multi Languages](https://github.com/louislam/uptime-kuma/tree/master/src/lang)
- Multiple status pages
- Map status pages to specific domains
- Ping chart
- Certificate info
- Proxy support
- 2FA support

## 🔧 How to Install

### 🐳 Docker

```bash
docker run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:latest
```

Uptime Kuma is now running on http://localhost:3001

 WARNING
-  File Systems like **NFS** (Network File System) are **NOT** supported. - Please map to a local directory or volume.


You can also install a watchtower docker container on the same host to always keep uptime kuma up to date by running

```bash
docker pull containrrr/watchtower:latest
```



## Other Install methods 

[https://github.com/louislam/uptime-kuma](https://github.com/louislam/uptime-kuma)