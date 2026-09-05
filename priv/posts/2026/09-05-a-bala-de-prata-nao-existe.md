%{
title: "there's no silver bullet (again)",
description: "reflections from SCTI UENF 2026: giving a RAG talk while cutting my own LLM usage, the hype as a commercial project, and why software architecture is still the heart of any production system.",
tags: ~w(elixir beam distributed-systems ai scti meta),
  bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3murx6anz272y",
}
---

last week was SCTI at UENF and, once again, i was there. context first: the organizing committee invites me to talk and run a workshop every year since 2023. EVERY YEAR. in a world where tech events die after two editions, having a corner that keeps wanting me back with this consistency is something i don't take for granted. so before anything else: thank you, committee 💜 you folks built a rare space.

this year there were two contributions: a talk about RAG and architecture, and a workshop where the whole room wrote clients for an arena of slimes fighting on a grid. slides and materials live on the [talks](/talks) page, so i won't repeat content here. what i want is to register what kept spinning in my head afterwards, and part of it is uncomfortable.

## the tension i carry on stage

being honest: there's a contradiction in me stepping on a stage to talk about architecture for AI. i built two production RAGs, i know how the sausage is made because i made several, and precisely because of that i don't use LLMs in my daily life. i use them less and less, actually, and on purpose. this blog you're reading is part of that: a deliberately slow project, written by hand, because i wrote a [whole post](/blog/present-day-present-time) about what constant delegation does to thinking and i don't intend to become a statistic of my own text.

and there's the material part, which is bigger than my navel. the AI hype isn't a spontaneous phenomenon of technical excitement, it's a commercial project by half a dozen companies. the model that "solves everything" was trained on decades of collective, unpaid work (blogs, forums, open source, wikipedia, this post included), and today that chewed-up labor is sold back as a subscription by the infra owners. that doesn't talk to anything i believe politically. when i talk about AI on stage i try to talk engineering, not gospel, because the gospel isn't mine and i'm not paid to preach it.

## this cycle's silver bullet

in 1986 Fred Brooks wrote "No Silver Bullet": no technology, alone, gives an order-of-magnitude leap in building software. forty years later we keep testing the thesis every cycle. it was cloud, it was blockchain, it was microservices, it was no-code. now it's AI, and this time the marketing is more aggressive: not "this tool helps", but "you don't need to think anymore, the model thinks".

in practice, the opposite happens. putting an LLM in your system means adding one more distributed dependency that fails in creative ways: timeout, rate limit, plausible-and-wrong answers, provider down. every classic distributed systems problem is still there, intact, and they gained a neighbor that lies with confidence. the hype didn't retire Brooks, it gave him more work.

## what was left when the penny dropped

the workshop was the involuntary counterpoint to all of this, and maybe the most honest part of my week. Slimes has no LLM at all: it's a server, a protocol, a grid, and a bunch of clients written by people seeing that for the first time. and what the room needed to learn to survive was the oldest repertoire of distributed computing: retry, idempotency, ack and nack, server as authority, pure function at the core and effects at the edges. none of that showed up in a big tech keynote this year. all of it will still be working when the next silver bullet keynote comes out.

i wanted to end this paragraph saying it makes me optimistic, but the honest word is another: it makes me relieved and worried at the same time. relieved because the younger folks are hungry for fundamentals, give them a concrete problem (your slime dies if your code is dumb) and the theory goes down beautifully. worried because those same folks will enter a market that spends all day telling them their thinking is obsolete and their job is supervising model output. the relief is about the people. the worry is about the structure, and structure doesn't get fixed with talks.

## and the BEAM in all this?

i won't fake neutrality: my undercover Elixir marketing is still standing. supervision trees, isolated processes, let it crash. a machine for running distributed systems that's existed since the 80s, when "distributed" meant telephony and not microservices on kubernetes. the irony of the current cycle is that the answer to "how do i survive dependencies that fail all the time?" was ready decades before the question became fashionable.

but the BEAM is a shortcut, not a prerequisite. the principle is older than it and wider than any stack: draw boundaries where things can fail, because they will. architecture isn't old-people bureaucracy, it's what separates a system from a demo. always was. still is, with or without an LLM inside.

## no pretty bow

i don't have an optimistic conclusion to offer, and i think an optimistic conclusion would be dishonest. the hype won't die because people profit from it, and i won't fix that in a post. what i can do is what i tried to do in Campos: talk about boundaries, failure, pure cores, the things that keep holding regardless of the week's headline. and keep my own practice coherent with what i say, which is the hardest part.

if the pattern holds, see you at SCTI 2027. i'll keep coming back as long as they want me there, and by the looks of it they'll have to put up with me a while longer.

hugs to the committee, hugs to the folks who coded slimes with me, and remember: there's no silver bullet, there's well-drawn boundaries 💜
