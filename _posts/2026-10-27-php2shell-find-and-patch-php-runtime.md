---
layout: "post"
title: "PHP2Shell: Find and Patch the PHP Runtime Behind Your Web Apps"
date: "2026-10-27 21:33:25 -0700"
description: "How to identify exposed PHP runtimes, apply the October security fixes, and check the remaining session configuration caveat."
categories: ["technology", "security"]
tags: ["php", "security", "selfhosting", "vulnerability"]
toc: true
published: true
image:
  path: "https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/5d3efdaede744a759a44be5a909f4f62/public"
  alt: "A damaged server module beside its replacement"
  hide_caption: true
---
If you run a PHP-backed site, check the interpreter serving requests, not just the application's Composer dependencies. Two PHP runtime vulnerabilities can allow unauthenticated remote code execution. The PHP project released fixes on October 21; on October 26, CISA added both to its [known exploited vulnerabilities catalog](https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json). That is a reason to patch and investigate exposed systems, not just put the update in the next maintenance window.

The bugs, often called PHP2Shell, affect web request handling in PHP itself. PHP names PHP-FPM, Apache with mod_php, php-cgi, FrankenPHP, and LiteSpeed among the configurations at risk. [PHP's advisory](https://www.php.net/archive/2026.php#2026-10-21-5) considers mod_php the highest risk: its demonstrated attack can run before application code. A framework upgrade or Composer audit alone cannot establish that the interpreter is fixed.

## Which versions have fixes?

| Upstream branch | First fixed release |
| --- | --- |
| PHP 8.5 | 8.5.12 |
| PHP 8.4 | 8.4.27 |
| PHP 8.3 | 8.3.36 |
| PHP 8.2 | 8.2.35 |

These upstream release numbers appear in the [PHP security advisories](https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w). A distribution or extended-support vendor may backport a fix without changing the upstream-looking version in the same way. Check its advisory and package revision before declaring a host vulnerable or fixed based on `php -v` alone.

PHP 8.1 and older no longer receive upstream releases. Check your distribution or support vendor for a backport, or move to a supported branch. PHP also published minimal source backports for 7.4, 8.0, and 8.1 for those building from source; those are not a substitute for a maintained upgrade plan.

## What actually breaks

[CVE-2026-109618](https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w) involves out-of-memory handling. An allocation failure can interrupt PHP while request data is only partly initialized; request shutdown can then operate on invalid data. The PHP advisory describes ways a multipart request can exhaust memory despite apparently staying within configured request limits. Application-specific allocations can also reach the vulnerable path.

[CVE-2026-109619](https://github.com/php/php-src/security/advisories/GHSA-6wmf-4rv5-p3rp) involves stale state across requests. A worker can retain a reference to request-owned memory after that memory is freed. If the same worker uses the stale state before normal initialization resets it, a use-after-free can occur. The prerequisites differ by server interface and configuration; don't assume that one missing attack path makes an unpatched deployment safe.

Both issues can lead to code execution with the web worker's privileges. Rapid7 reports public proof-of-concept exploits with narrow environmental requirements. CISA lists both vulnerabilities as known exploited. The available reporting does not establish that every exposed server has been compromised.

## Find the runtime that handles requests

Start with an inventory of every PHP-backed service, including staging sites, admin tools, containers, and older apps that rarely change. Map each public route to its web server, PHP handler, host or container, image or package source, and owner. A reverse proxy can hide the host that actually needs the update.

On a Linux host, these read-only commands provide starting clues:

```bash
php -v
ps -eo pid,args | grep -E '[p]hp-fpm|[a]pache2|[h]ttpd'
```

The first command identifies the CLI binary on your `PATH`; it does **not** prove which binary or configuration serves the site. The process list can reveal FPM or Apache processes, but it is not a complete inventory and may not expose PHP running in containers. Check the actual service configuration, package revision, and vendor advisory on each host. For containerized services, inspect the deployed image and its build source, not just a mutable tag in a repository. A container can keep running old code after its base image has been updated.

[Snyk's analysis](https://snyk.io/blog/php-patches-critical-unauthenticated-rces/) makes the same distinction: a Composer PHP version constraint says what an application accepts, not exactly which runtime is deployed. A dependency scan of application manifests may therefore miss the interpreter that needs attention.

## Patch, replace workers, and verify

1. **Choose the fix for the actual installation.** For a vendor package, install the patched package identified in that vendor's advisory. For a source build or container image, rebuild from a fixed release or patched base, then deploy the resulting artifact. Check PHP extensions and application compatibility as you would for any runtime upgrade.
2. **Replace the running processes.** Restart the applicable PHP-FPM or Apache service, or roll out replacement containers using your normal deployment procedure. Updating files on disk does not by itself prove that every old worker has exited. Account for multiple hosts, replicas, and pools.
3. **Verify each serving instance.** Compare the installed package revision or image digest with the fixed artifact and vendor advisory, and verify the service or container was replaced. Run your application's smoke tests through the normal web path. Confirm the traffic is reaching the updated instances; a CLI version check alone is insufficient.
4. **Investigate exposure.** Rapid7 recommends investigating for prior compromise. Preserve relevant logs and deployment records, review suspicious activity around exposed services, and use your incident response process if evidence warrants it. Patching closes the vulnerable code path; it does not establish what happened before the patch.

If you cannot patch immediately, restrict access where practical and consult PHP's [full mitigation guidance](https://www.php.net/archive/2026.php#2026-10-21-5). PHP is explicit that these measures reduce particular paths and are not a complete fix. Some have operational costs: disabling PHP's memory limit, for example, changes resource-exhaustion behavior and needs an appropriate external availability boundary. A blanket configuration change without testing can take a service down while leaving other paths exposed.

> Treat temporary restrictions as time to deploy the fix, not proof that the installation is safe.
{: .prompt-warning }

## Check the session upload progress caveat

On October 23, PHP published an [informational advisory](https://www.php.net/archive/2026.php#2026-10-23-1) for a separate, unlikely vector tracked as CVE-2026-115560. It requires session upload progress to be enabled and an application to configure `session.serialize_handler` as `php_binary` or `php_serialize`, then switch it to `php` with `ini_set()` before `session_start()`.

PHP suggests setting `session.upload_progress.enabled=0` until the next regular bugfix release to fully protect against that vector. Applications that never change the serialization handler at runtime can keep the feature enabled, according to PHP. For the original stale-state mitigation on an unpatched installation, the setting must apply before request parsing and every worker must restart; the project says not to rely on application `ini_set()` or FPM `.user.ini` for that purpose. Disabling upload progress can affect applications that use it, so check the feature before changing production configuration.

## Sources

- [PHP security announcement, fixed versions, and interim mitigations](https://www.php.net/archive/2026.php#2026-10-21-5)
- [PHP informational advisory on session upload progress](https://www.php.net/archive/2026.php#2026-10-23-1)
- [PHP advisory for CVE-2026-109618: out-of-memory corruption](https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w)
- [PHP advisory for CVE-2026-109619: stale global state](https://github.com/php/php-src/security/advisories/GHSA-6wmf-4rv5-p3rp)
- [CISA known exploited vulnerabilities catalog data](https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json)
- [Rapid7 technical analysis and known-exploited update](https://www.rapid7.com/blog/post/etr-cve-2026-109618-and-cve-2026-109619-critical-unauthenticated-remote-code-execution-in-php/)
- [Snyk's runtime inventory and patching analysis](https://snyk.io/blog/php-patches-critical-unauthenticated-rces/)
