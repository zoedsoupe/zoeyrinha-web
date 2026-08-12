%{
title: "comments from the atmosphere",
description: "I wanted comments on this blog without a database or a moderation queue. I shipped them on Bluesky threads through proto_rune, my own AT Protocol SDK, and found three bugs in it first.",
tags: ~w(elixir bluesky oss),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3msvafroz5e2o",
}
---

I wanted comments on this blog. The options were all bad in familiar ways.
Disqus is an ad network that happens to render a comment box. giscus is nice,
but it gates my readers behind a GitHub account. And hosting my own comments
means a database, a spam filter, and a moderation queue, which is a Tamagotchi:
you don't own it so much as you feed it, forever, and if you forget for a week
something dies or something hatches.

Then I remembered I maintain [proto_rune](https://github.com/zoedsoupe/proto_rune),
an Elixir SDK for the AT Protocol, and the answer got obvious. A Bluesky thread
already is a comment section. Accounts, spam, blocks, deletes: the network's
problem, not mine. I post about the article, people reply there, the blog
renders the replies. No database, no volume on Fly, no moderation UI I would
never build.

So that is what this site does now, and the rest of this post is about what
happened when I sat down to actually use my own library as a user instead of
its author. Spoiler: it took three bug reports' worth of work, all filed
against myself, all fixed the same week.

## proto_rune, briefly

proto_rune is my AT Protocol SDK for Elixir. Three layers: a transport layer
that speaks XRPC (the protocol's HTTP flavor), a DSL that turns the official
lexicons into plain Elixir functions, and a friendly API on top for the things
you actually do, like posting, liking, and fetching threads. Sessions refresh
themselves, there is a bot framework with polling, and a firehose client for
the real-time stream. It is on [Hex](https://hex.pm/packages/proto_rune).

The feature I needed for comments is one unauthenticated call:
`app.bsky.feed.getPostThread`, pointed at the public AppView. Give it the URI
of a post, get back the whole reply tree. The blog keeps the thread URI in the
post's frontmatter, a `mix blog.announce` task publishes the announcement and
writes the URI back into the markdown file, and the page fetches and caches
the replies at render time. Elegant, if I say so myself, and about two hundred
lines including the cache.

And then I ran it.

## eating your own cooking

Writing a library is writing a menu. You describe dishes, you taste the sauce
once, you imagine the dining room. Using your own library to build something
real is sitting down in the restaurant and ordering. The first thing I
learned, as a customer of my own kitchen, is that the stove didn't light.

**Bug one: nobody could make a single request.** Every call crashed inside
`:ssl.connect` before a byte left the BEAM. The HTTP adapter passed the
connection timeout down the stack unconditionally, and when the caller had no
opinion about timeouts, that opinion arrived as `nil`, and Erlang's SSL module
has no clause for "no opinion". The test suite was green, of course. The
adapter is the outermost shell, the part tests swap out. This is the exact
class of bug that only exists at the boundary, which is poetic, and you
should hold that thought.

**Bug two: one signpost for the whole city.** The SDK read its base URL from
the application environment, one global key for every request. Except
anonymous reads belong on `public.api.bsky.app` and logins belong on your PDS,
and a global signpost can only point one way. The moment I configured it for
reading threads, login broke. The fix was to delete the signpost: every call
carries its own directions now, and the session itself remembers which server
it belongs to. Global mutable configuration strikes again, and I wrote the
thing.

**Bug three, my favorite: tectonic plates.** The high-level `Bsky.post` and
the low-level `Repo.create_record` schema had drifted apart like continents.
Each looked fine on its own map. But one passed collection names as full
strings where the other expected atoms, the record schema wanted a
`NaiveDateTime` while the wire format is an ISO string, and the rich text
builder emitted camelCase keys where the schema expected snake_case. Where the
plates met, the function clause errors were the earthquakes. And the subtlest
rumble: my own validation library, [peri](https://github.com/zoedsoupe/peri),
silently drops any key the schema doesn't declare, which meant `"$type"` fields
were evaporating from records on their way to the wire. A bouncer so thorough
he was turning away the guests' invitations.

Two posts ago I wrote fifty paragraphs about parsing at the boundary. My own
boundary was misparsing. I choose to find this funny.

## the fix, without the gore

I won't walk through the patches in detail, because the fixes were smaller
than the diagnosis, as they usually are. A nil check. A per-call option
instead of app config. Aligning the schemas with what the wire actually looks
like, which, yes, is just parse-don't-validate applied to my own code, thank
you, I have heard the feedback from the back row. The regression tests now
drive posting end to end through a fake HTTP adapter and assert on the literal
JSON body that would leave the process, so the drift can't quietly regrow.

All of it shipped: [0.3.0](https://github.com/zoedsoupe/proto_rune/releases)
with the transport and config fixes, and the schema alignment right after. The
bugs I didn't fix became
[honest](https://github.com/zoedsoupe/proto_rune/issues/51)
[issues](https://github.com/zoedsoupe/proto_rune/issues/52) instead of
surprises. `Bsky.follow` and `Bsky.block` are still wrong in a way that needs
a design pass rather than a patch, and now the tracker says so.

## the point

Everyone says dogfood your own work, and the advice is usually about quality
in some abstract sense. What I didn't expect is _where_ the bugs were hiding.
Not in the clever parts. The clever parts had tests. The bugs lived exactly
where a new user would meet them in their first five minutes: the first
request, the first login, the first post. The welcome mat was on fire and the
living room was spotless.

And the comment section at the bottom of this page is the proof it all works
now. It is a Bluesky thread wearing a trench coat. If you reply there, you
reply here. Be kind; I can hide replies from the comfort of my own account,
which is exactly the amount of moderation I was willing to operate.
