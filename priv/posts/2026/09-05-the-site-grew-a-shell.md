%{
title: "the site grew a shell",
description: "Small changelog from my corner of the internet: mdex instead of earmark, async Bluesky comments, no more npm, and a 404 that fails like a proper terminal.",
tags: ~w(meta elixir),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3murtwskd6o2v",
}
---

Housekeeping post! I spent a few sessions fiddling with this site (the one you are reading right now) and it accumulated enough small changes to deserve a changelog. Nothing here is a grand rewrite, it is more like tending a garden. Or, given the aesthetic, a home directory.

## fewer dependencies, more elbow grease

Two swaps first. Earmark is out, [mdex](https://github.com/leandrocp/mdex) is in - Earmark had a CVE open and mdex renders via comrak (Rust NIF), so posts compile faster and the CVE is gone. Then I deleted the whole `assets/package.json`: Alpine, Lucide and npm itself, all gone. The site is a terminal with a [nyxvamp - own theme](https://github.com/nyxvamp-theme) palette, it never needed a JS framework. The icons became text links, the sprinkle of interactivity is now ~80 lines of vanilla JS, and the Docker image shrank accordingly.

## comments from the atmosphere, async

Bluesky comments on posts now load in an embedded LiveView, after the page renders. Before, the whole post waited on the AT Protocol API before serving a single byte - now the post (static, cached, instant) arrives immediately and the comments stream in when they arrive. The rest of the site pays nothing: the LiveSocket only connects on pages that actually have comments.

## the shell jokes

The site is dressed as a terminal, so now it behaves like one in a few corners:

- the CV page greets you with `$ whoami` (the résumé below is the stdout);
- the talks page runs `$ wall ./talks.txt` - `wall(1)`, write to ALL users, which is what a talk is;
- the footer runs `$ finger zoey@bsky.app`, the original social lookup, with the links as stdout;
- the blog index shows the RSS feed as a curl command, because that is how you would actually consume it from a terminal;
- and the 404 page now fails honestly:

```console
$ ls /this-page
ls: cannot access '/this-page': No such file or directory
$ cd ~
```

On the interactive side: code blocks grew copy buttons (labels localized, of course), cursors blink, and if you type the Konami code the page glitches for three seconds. That one comes with a guard: if your system asks for reduced motion, the storm simply does not happen. Accessibility got a pass across the board - focus states, contrast, the usual suspects that are not optional.

## ops footnotes

Two Fly.io tweaks: cold starts are gone (the machine stays warm) and the VM memory went down, because a static-ish Phoenix site does not need the extra room.

That is it. The site compiles faster, weighs less, loads comments lazily and fails more poetically. Back to real posts next.
