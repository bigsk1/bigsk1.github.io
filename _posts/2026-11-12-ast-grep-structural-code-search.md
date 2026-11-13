---
title: "Find Code by Structure With ast-grep"
date: 2026-11-12 16:00:00 -0800
categories: [development]
tags: [developer-tools, open-source, code-search]
description: "Search and review code patterns using syntax trees with ast-grep."
toc: true
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/bigsk1-blog/a520a17a62e64bd6938f43b1bb67e436/public
  alt: A cyan scanner highlights matching branches in a mechanical syntax tree
  hide_caption: true
published: true
---
Finding a call in a codebase sounds easy until formatting changes, arguments span lines, or the same text appears in comments. [ast-grep](https://github.com/ast-grep/ast-grep) searches code using its syntax tree, so a pattern can describe the shape of an expression instead of its exact whitespace. It can also rewrite matches and run reusable lint rules.

This established MIT-licensed project is useful when you need to inventory a recurring code pattern before a migration. Here's a small TypeScript example, followed by the limits to keep in mind before changing anything.

## Install and search

The [quick start](https://ast-grep.github.io/guide/quick-start.html) lists several installation methods. On a machine with Rust and Cargo installed, use:

```bash
cargo install ast-grep --locked
ast-grep --help
```

Use the full `ast-grep` command on Linux: `sg` may already refer to the system's setgroups utility. In a TypeScript repository, search a source directory for a property checked and then called:

```bash
ast-grep -p '$PROP && $PROP()' -l ts src
```

Single quotes keep the shell from expanding `$PROP`. The pattern can find expressions such as `obj.method && obj.method()` even when whitespace or line breaks differ. Reusing the same metavariable requires the captured syntax to match itself; it does not mean that two different names are interchangeable. The output identifies matching locations for review. The commands here follow the documentation; they were not executed as part of this article.

## Match the shape you actually need

A metavariable such as `$ARG` captures one syntax node. For example, `console.log($ARG)` matches a one-argument call but not an empty call or a call with two arguments. To find calls with any number of arguments, use the multi-node form:

```bash
ast-grep -p 'console.log($$$ARGS)' -l ts src
```

The [pattern syntax guide](https://ast-grep.github.io/guide/pattern-syntax.html) explains that `$$$ARGS` can capture zero or more nodes. Unlike a text search for `console.log`, this pattern targets a call expression; the same characters in a comment or string are not a matching call. Start with a narrow directory and inspect the results: a structural match tells you what the code looks like, not whether the call is safe to remove.

## From search to a controlled change

A practical migration begins with a search, not a bulk replacement. Review representative matches and non-matches, including different argument counts and nested expressions. Then consult the project's [rewrite guidance](https://ast-grep.github.io/guide/rewrite-code.html) and test a proposed rule on a disposable branch or fixture. Review the diff and run the application's own tests before accepting changes.

Syntax alone cannot establish runtime behavior, types, or the intent behind a call. A pattern can miss variants you did not describe, and a syntactically valid replacement can still change behavior. Use ordinary text search alongside ast-grep when you also need comments, configuration files, or documentation. For repeated checks, the project supports configured rules and rule tests; that gives a team a way to keep examples of both expected matches and exceptions with the rule.
