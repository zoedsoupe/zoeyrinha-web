%{
title: "the quintal is open",
description: "Introducing quintal: a collective blogging platform on atproto, no algorithm, no metrics, one axolotl mascot. The small internet I always wanted to live in.",
tags: ~w(elixir atproto oss),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mu3rh5uyoh2k",
}
---

A confession before the announcement: I spent years saying I would never build
social software. Every time the idea came up I pictured the whole package -
ranked feeds, follower counts, the engagement machinery knocking at the door -
and recoiled. Then one day I paid attention to what I actually missed about the
internet, and it was none of that package. It was the other part, the one that
existed before it: guestbooks, "who I read" lists, stumbling onto someone's
weird little site at 2am.

So I built exactly that. It is called [quintal](https://quintal.blog.br) -
Portuguese for "backyard", always lowercase - and it is live, in alpha:
[quintal.blog.br](https://quintal.blog.br).

> "isso aqui é o meu lugar na internet, e essas são as pessoas que eu escolhi
> dividir ele comigo."
>
> ("this here is my place on the internet, and these are the people I chose to
> share it with.")

That sentence lives in the project's README, and it is the most honest summary
I can give. quintal is not a social network, even if it looks like one at
first glance. It is a neighborhood: each person has their corner, writes their
pieces, receives guestbook notes and chooses who to read. Public by default,
yours by principle. Home as a verb, not a noun: a place you keep, tidy, share
and welcome visitors into.

## The vocabulary of the place

quintal has its own words, because naming things with affection is part of the
project. The interface is Brazilian Portuguese first, so the words travel
untranslated:

- **canto** ("corner") - your personal home: profile, prosas, recados, links;
- **prosa** - the unit of writing, from a two-line note to a long essay;
- **recado** - an entry in a canto's guestbook;
- **depoimento** - a public testimony about a person, visible only after they
  accept it;
- **cumadi** - a canto you read and recommend, the "who I read" of quintal;
- **passear** ("to wander") - serendipitous discovery, one canto at a time,
  guided by the mascot;
- **visitas** - quiet notifications: who stopped by your canto since your last
  visit.

If you are Brazilian, two of those words just gave you déjà vu. _Recado_ and
_depoimento_ come straight from Orkut - the social network that raised a
generation of us - on purpose: it was the last big place on the internet where
kindness had its own vocabulary. The difference here is that a depoimento is a
love letter with delivery control: the recipient decides whether to open the
envelope in the living room.

And the mascot? Meet **axô**, a pink axolotl:

![axô waving hello](https://quintal.blog.br/images/axo-front-gretting.png)

Axolotls regenerate entire body parts, and here your data does too - but that
is the next section.

## Your data lives on your PDS

The technical decision that holds up all the others: quintal runs on
[atproto](https://atproto.com/guides/overview), the open protocol underneath
Bluesky. And it is an appview, not a host. Meaning: quintal does not keep your
writing. Every prosa, every recado, every setting of your canto is a record in
your own repository, on your own PDS (personal data server). quintal indexes
those records so it can find them fast and renders the interface on top, and
writes back to your repo through OAuth - never asking for your password, with
credentials scoped to the `place.quintal.*` collections only. Your other
records, like your Bluesky ones, it never touches.

The consequences are the best part. Want to leave? Take everything: point
another appview at the same PDS. Came back? Nothing was lost. quintal could
disappear tomorrow (I am one person maintaining an open-source project, not a
company) and your words stay yours, ready for any other interface to read,
because the lexicons are public. Free exit comes from the protocol, not from a
promise of mine.

Hence the axolotl: regrows the limb, regrows the data. The pun axô/achou
("found it") becomes the mechanic - it is axô who takes you wandering through
the neighborhood and introduces you to new cantos.

![axô swimming in the loading screen](https://quintal.blog.br/images/axo-swimming.png)

For the Elixir crowd who reads me for the Elixir posts: quintal is Phoenix +
LiveView with SSR, a firehose consumer indexing into Postgres, Oban for jobs,
Finch for HTTP, a Nix flake for dev, Fly.io in production, AGPL license. It is
also the largest dogfood of [proto_rune](https://github.com/zoedsoupe/proto_rune),
my AT Protocol SDK - firehose, OAuth, XRPC, all of it flowing through. Nothing
tests an SDK like a real product on top of it asking for features.

## The constitution

Some decisions in quintal are not up for negotiation, and I would rather say
them out loud:

1. **Chronological forever.** There is no ranking function and there never
   will be. Not a missing feature - the constitution.
2. **Zero popularity metrics.** No follower counts, no likes, no public
   numbers of anything. If you write well, no number says so - people show up,
   leave a recado and come back. Feedback here has a body and a name.
3. **Human writing.** A signed pledge, a badge - not a detector. A manifesto,
   not policing.
4. **Simple and fast above all.** Performance is a feature. The reading page
   is the product.
5. **PT-BR first.** International by architecture (every string goes through
   gettext since line 1), Brazilian by soul.

And entry is by invitation. quintal is small on purpose, and I like it that
way.

## The house rules

There is a whole [code of conduct page](https://quintal.blog.br/conduta) about
this, written in first person on purpose: quintal is my project, shared with
friends and loved ones, so the rules say "I" and not "the team". The part that
must not be left implied, I am leaving implied zero: this is a collective,
communal space, and transphobia does not fit in it. Not in prosas, not in
recados, not in depoimentos, not "just asking questions". I wrote that part
with my heart in my hand because it is about me and about many people I love:
quintal exists so that trans, travesti and non-binary people have a common
place on the internet where they can simply exist and write.

Moderation, for now, is one person (me): every report is read slowly, by a
human, no bots, no auto-replies. And even when a recado is hidden from a
canto, the writer's record stays intact on their own PDS - words belong to
whoever wrote them, always.

## Alpha, so what?

Honest status: MVP in alpha. Things change, break and change again. There are
plenty of messy corners, plenty of ugly buttons, and an idea list longer than
my free-hours list. The code is open
([github.com/zoedsoupe/quintal](https://github.com/zoedsoupe/quintal)), the
protocol rules are public, and the people already living there help take care
of it.

If you have an atproto handle (a Bluesky one works), you can sign in with it
once your invite arrives - or ping me, because invites are for giving.
Meanwhile, the guestbook is open and axô loves company for a wander.

The algorithm will not show you this post. But look at that: axô found it.
