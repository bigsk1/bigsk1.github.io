---
title: "Muru: a Python app server built around releases"
date: 2026-11-24 16:00:00 -0800
categories: [development]
tags: [python, self-hosted, deployment, open-source]
description: "A look at Muru's Python worker model, side-by-side releases, and local development workflow."
toc: true
published: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/7a5f580510ed4cbdad481ccf91a77e9e/public
  alt: Traffic switching between two application server modules
  hide_caption: true
---
A Python web server usually starts workers and gives them requests. [Muru](https://github.com/muruhq/muru) adds another layer: it treats a set of workers as a release, starts a replacement alongside the old one, and moves traffic when the new workers are ready. The same idea appears in its development reloads and its server deployment model.

Muru is a new Apache-2.0 project from Graham Dumpleton, creator of mod_wsgi. It is **alpha software**, with 0.1.0 prereleases and commands and configuration that may change. That makes it interesting to explore, not an automatic replacement for a working production stack. [Simon Willison's overview](https://simonwillison.net/2026/Nov/21/muru/) points to the maintainer's unusually detailed series on the design and its development.

## What runs where

The project describes three components: a Rust edge accepts connections, a controller manages releases, and Python worker processes run the application. The edge routes requests to workers over a private link. Muru supports both WSGI and ASGI, and its repository describes local development, a server daemon, and a container mode. It also lists TLS, static files, traffic splitting, and a management interface among its capabilities. See the [project README](https://github.com/muruhq/muru) for the current feature list.

The useful distinction is between a **worker restart** and a **release transition**. In the maintainer's [development walkthrough](https://grahamdumpleton.me/posts/2026/11/a-first-look-at-muru/), a changed Python file causes a new host and workers to start beside the existing release. If the new application cannot import, the previous release keeps serving. A readiness check can prevent a broken import from taking over; it cannot prove that every application route or database migration works.

The [deployment explanation](https://grahamdumpleton.me/posts/2026/11/muru-releases-not-restarts/) extends that model to the daemon. Keeping versions side by side permits traffic to move between releases and makes rollback possible while the previous release is available. Database changes, external state, and compatibility between versions remain application responsibilities. Treat a canary or rollback as an operational procedure to design and exercise, not a guarantee that every failure is reversible.

## Try a small local app

The maintainer documents Linux and macOS with CPython 3.11 or newer, including free-threaded builds. The example below assumes `uv` and a suitable Python are already installed. `muructl` is the Rust command-line binary; on first use with a Python version it fetches a matching runtime library into the user's cache. That first run needs network access. Follow the [current installation guide](https://grahamdumpleton.me/posts/2026/11/a-first-look-at-muru/) if the alpha's setup changes.

```bash
uv tool install muructl
mkdir muru-demo
cd muru-demo
uv init --bare
uv venv
```

Create `app.py` with a minimal WSGI callable:

```python
def application(environ, start_response):
    body = f"Hello from {environ['PATH_INFO']}\n".encode()
    headers = [("Content-Type", "text/plain"), ("Content-Length", str(len(body)))]
    start_response("200 OK", headers)
    return [body]
```

Start the app and, in another terminal, request a path:

```bash
muructl run app:application
```

```bash
curl http://127.0.0.1:8080/hello
```

The expected response is `Hello from /hello`. The documented development run binds to loopback, watches Python files for changes, and displays tracebacks on error; it is for local work, not public exposure. Stop it with Ctrl+C. If the request fails, check that the server started successfully and that port 8080 is free. An import error in a new reload should appear in the server output while the last ready release continues to serve.

The access log separates time waiting for a worker from time spent in application code, according to the walkthrough. That distinction helps narrow down whether a slow request is waiting for capacity or spending time inside the app; it does not by itself identify the root cause.

## A bridge for older Python apps

WSGI and ASGI solve different interface problems. A synchronous WSGI application cannot itself speak WebSocket through the WSGI interface. Muru's [WSGI-to-ASGI example](https://grahamdumpleton.me/posts/2026/11/muru-wsgi-and-asgi-together/) shows a Flask route handing a WebSocket request to an ASGI application in the same worker process using a Muru-specific object in the WSGI environment. That can be useful for adding an async endpoint without immediately rewriting an entire WSGI app.

The tradeoff is coupling: code using that bridge depends on Muru's extension. A separate ASGI service behind a reverse proxy remains an option when independent deployment or portability matters more. Either approach still needs an explicit plan for authentication, shared state, and multiple workers.

## Where it fits

For a developer running a small Flask or Django app, Muru offers a way to explore the same release concept locally before considering a daemon or container deployment. For an operator with a mature Gunicorn or ASGI server setup, its integrated routing and release controls are the part worth evaluating, not a reason to discard proven tooling. The project is early, and its breadth adds configuration and behavior to learn. Check the current documentation, pin a version for experiments, and test failure and rollback paths against a representative application before trusting it with real traffic.
