---
title: "Healthchecks: Catch the Cron Jobs That Never Finish"
date: 2026-11-21 16:23:00 -0800
categories: [devops]
tags: [monitoring, cron, selfhosting, backups]
description: "Monitor scheduled jobs with heartbeat checks, grace periods, and failure signals."
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/7a2fba57a8ec4725b68c934196decb56/public
  alt: A silent server rack and an unlit heartbeat indicator
  hide_caption: true
---
A backup job can fail without leaving a useful alert: the machine may be offline, cron may never start it, or the script may hang before it reaches its final log line. Healthchecks watches for the signal that should arrive after the work finishes and alerts when it does not.

[Healthchecks](https://github.com/healthchecks/healthchecks) is an open-source service for monitoring scheduled jobs and background tasks. You can use the hosted service or run your own instance. It is a useful complement to logs: a missing heartbeat tells you to investigate, including when the machine that normally writes the logs is unreachable.

## Monitor a backup, not just a server

Create a check for the job, set its schedule and time zone, and configure a notification channel. Give the check enough grace time to accommodate normal runtime and occasional delays. If a backup starts at 06:08 and usually takes 15–25 minutes, a 30-minute grace period gives it until 06:38 to check in. Choose a larger margin if the job's normal variation requires it. The [cron monitoring guide](https://healthchecks.io/docs/monitoring_cron_jobs/) explains how the schedule and grace period work together.

Add the success ping after the backup command:

```cron
8 6 * * * /home/me/backup.sh && curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/your-uuid-here
```

Replace the example path and URL with your own. The `&&` matters: the ping runs only when the script exits successfully. A nonzero exit, a hang, or a machine that never starts the job can all result in a missed ping. The alert tells you a success signal is missing; it does not identify which failure occurred, or prove that a successful backup is restorable. Test restores separately.

Treat the ping URL as a secret: anyone who has it can send a signal for that check. Keep it out of public repositories and restrict access to configuration files and logs that contain it. Use the URL supplied by your own instance if self-hosting.

## Report failures sooner

Waiting for the grace period is useful when a job disappears, but a script that knows it failed can report the failure immediately. Healthchecks accepts `/fail` or a numeric exit status appended to the ping URL; zero means success and nonzero means failure, according to the [failure signaling guide](https://healthchecks.io/docs/signaling_failures/).

For example, in a shell wrapper without `set -e`:

```sh
#!/bin/sh
/usr/local/bin/backup.sh
status=$?
curl -fsS -m 10 --retry 5 -o /dev/null "${HEALTHCHECKS_URL}/${status}"
exit "$status"
```

Set `HEALTHCHECKS_URL` in the job's protected environment. Capturing the status before calling `curl` preserves the backup's result, and the final `exit` returns it to the scheduler. If the ping itself fails, the check can still alert when its expected success signal is overdue. A network outage can therefore look like a job failure; inspect the job and connectivity before drawing conclusions.

Healthchecks also supports start signals and duration tracking. Those are useful when the difference between “never started” and “started but is still running” affects the response. Avoid sending sensitive output as logs without reviewing who can access the monitoring service.

## Hosted or self-hosted?

The hosted service places the monitor outside the machine running your job. That separation helps when the monitored machine goes down, provided its network can reach the service and your notification route works. A self-hosted monitor on the same machine shares its failure domain: if the host loses power, it cannot send its own alert. Put it on independent infrastructure if host failure is one of the conditions you need to detect.

The [self-hosting documentation](https://healthchecks.io/docs/self_hosted/) describes the application's dependencies and setup. Self-hosting also means maintaining the application, database, backups, email or other notification integrations, and updates. Whichever route you choose, deliberately miss a check-in and confirm that the alert reaches a person who can act. Then verify recovery with a successful ping. A green dashboard is useful only if the path from missing job to notification works.
