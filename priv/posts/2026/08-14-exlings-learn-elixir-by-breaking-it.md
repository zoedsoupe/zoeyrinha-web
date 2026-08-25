%{
title: "exlings: learn elixir by breaking it",
description: "exlings is rustlings for Elixir: a series of small broken programs you fix one at a time. Looking for people to try it.",
tags: ~w(elixir exlings oss learning),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mt2hshwybv22",
}
---

I maintain a small project called
[exlings](https://github.com/zoedsoupe/exlings), and this post exists because
I would like you to try it and tell me where it hurts.

The idea is stolen, as all good ideas are. [rustlings](https://github.com/rust-lang/rustlings)
and [ziglings](https://github.com/ratfactor/ziglings) proved the format: you
learn a language by fixing small broken programs, one at a time, in order,
with the compiler as your teacher. Not by reading about the language. Reading
gives you recognition; the exercises give you recall. Only one of those
survives a job interview.

exlings is that, for Elixir.

## how it works

You clone the repo, run `mix deps.get`, then:

```sh
mix exlings
```

You get the first pending exercise. It is a small `.ex` file with something
wrong with it: a missing piece of syntax, a pattern that doesn't match, a
function clause with a hole in it. You open the file, you fix it, you run
`mix exlings` again. Green, next exercise. That is the entire loop, and the
entire loop is the point.

If you don't want to re-run the command manually, `mix exlings.watch` re-runs
the current exercise every time you save. If you get stuck, `mix exlings.hint`
gives you a hint, and the hints are progressive: the first one nudges your
thinking, the last one nearly writes the answer, and each failed attempt
reveals the next one automatically. Stuck is a state, not a failure.
`mix exlings.list` shows progress, `mix exlings.reset` wipes it for when you
want to suffer from the beginning again.

There is no IDE plugin, no web UI, no account, no streak counter. It is a Mix
project and some tasks. The barrier to entry is having Elixir installed.

## what it teaches

The exercises walk through the language roughly in the order you'd trip over
it in your first months: values and the basic data structures, then pattern
matching (including the pin operator, which is where everyone has their first
_oh, THAT's what Elixir is_ moment), functions and guards, the pipe, `Enum`,
recursion done properly with accumulators and tail calls, comprehensions, and
the parts of strings and binaries that surprise people, like charlists, so
the `~c"hello"` jump scare gets defused in an exercise instead of in
production. The track keeps growing toward processes and OTP, which is the
reason we're all here.

## who it's for

Beginners. People coming from another language who keep writing Elixir that
looks like their old language with worse syntax highlighting. People who read
the getting-started guide twice and still freeze in front of an empty file.
It assumes no prior Elixir, no Erlang, no OTP. It does assume you can open a
terminal, which I maintain is the one irreducible prerequisite of the entire
profession.

It is also, quietly, for mentors: if you're teaching someone Elixir, hand them
the repo and let the watcher do the tedious part of feedback while you do the
interesting part.

## try it

```sh
git clone https://github.com/zoedsoupe/exlings
cd exlings
mix deps.get
mix exlings
```

Then tell me: where did you get stuck, which hint was useless, which exercise
is broken in a way I didn't intend (a bold claim for a project whose entire
premise is intentional breakage, but here we are). Issues and PRs are open,
exercises are easy to contribute, and the format makes reviews fast.

The best compliment the project has received so far is someone saying they
forgot they were learning. Go break something. Then fix it. That's the whole
job, it turns out.
