---
layout: post
title: Netflix Codes
date: 2025-02-20 12:05:00  -500
categories: [docker]
tags: [docker,self-hosting]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/netflix.webp
---


# 🍿 Netflix Secret Codes - A Cinematic Treasure Map

Welcome to the **Ultimate Netflix Secret Codes** app, a sleek, dark-mode web tool that unlocks the hidden gems of Netflix’s vast library. Built with HTML, CSS, and JavaScript (powered by p5.js for some popcorn magic), this app is hosted with Nginx and Docker, making it a modern, deployable delight. Check out the source code at my GitHub repo: [bigsk1/netflix-codes](https://github.com/bigsk1/netflix-codes).

As of **February 22, 2025**, this app is your ticket to exploring over 250 Netflix categories with ease—plus a dazzling popcorn animation to keep the movie-night vibes alive.

## What It Does

This app transforms Netflix’s obscure category codes into an accessible, searchable interface. Whether you’re hunting for "Independent Movies" or "Festive Romance," it’s all here, neatly organized and ready to click. 

### Key Features

- **Secret Codes Galore**: Access hundreds of Netflix categories like "Recently Added" (1592210), "90-Minute Movies" (81466194), and holiday specials—all clickable links to jump straight into Netflix.
- **Collapsible Categories**: Four main sections—Movies, TV Shows, Genres, and Holiday—start collapsed, expandable with a click for a clean, uncluttered look.
- **Searchable Interface**: Type in the search bar to filter categories instantly—no scrolling required.
- **🍿 Pop Right In Section**: A standout grid above the categories with instant links to fan-favorite codes like "Short-Ass Movies" (81603903). No digging needed—just click and stream!
- **Dark/Light Mode Toggle**: Switch between a Netflix-red-accented dark theme or a crisp light mode with a button (complete with sun/moon icons).
- **Popcorn Animation**: A dynamic p5.js background where golden popcorn falls, spins, and bounces—because why not?

## How It’s Built

- **Frontend**: Pure HTML/CSS/JavaScript, with p5.js for the animation. No frameworks—just raw, responsive goodness.
- **Deployment**: Dockerized with Nginx for a lightweight, fast server
- **Source**: Open-sourced at [https://github.com/bigsk1/netflix-codes](https://github.com/bigsk1/netflix-codes)—fork it, tweak it, enjoy it!

## Tweaking the Popcorn

Want to mix it up? Here’s how:
- **Count**: Edit `for (let i = 0; i < 75; i++)` in `setup()`—try `25` for sparse or `100` for a popcorn storm.
- **Angles**: Adjust `random(-PI / 6, PI / 6)` in `constructor()` for wider/narrower drifts (e.g., `PI / 4` for ±45°).
- **Bounce Rate**: Change `random() > 0.8` to `> 0.5` for more bouncers or `> 0.9` for fewer.
- **Gravity**: Tweak `this.speed += 0.05`—higher for faster falls, lower for floatier popcorn.

## Why It’s Awesome

This isn’t just a list of codes—it’s a *experience*. The intuitive design, instant-access cards, and that popcorn animation make it more than a tool—it’s a love letter to movie nights. 

Grab some popcorn (virtual or real), dive into Netflix’s hidden corners, and let me know what you think—or what crazy feature to add next!