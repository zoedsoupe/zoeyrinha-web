%{
title: "present day, present time",
description: "On not being able to write code by hand anymore, cognitive debt, giftedness, and what Serial Experiments Lain, Ghost in the Shell, Donna Haraway and Pierre Lévy have to do with it.",
tags: ~w(meta ai elixir),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mu3rh5smt427",
}
---

_Present day... present time. Hahaha._

> [sentences with sound...](https://www.youtube.com/watch?v=NfjsLmya1PI)

There's something I've been avoiding saying out loud, so I'll write it here:
lately, writing code by hand feels counterproductive to me. Not in the "it's
not worth learning" sense, but in a more uncomfortable one: I sit down to
implement something and a voice in my head says "an agent does this in four
minutes, why are you going to spend forty?". So I open the agent, the agent
does it in four minutes, I spend thirty reviewing, and by the end of the day
I shipped more code than ever and thought less than ever.

That worries me. I went reading what research exists on this to check whether
the worry was just mine, and this post is what came out: a bit of literature,
a bit of professional autobiography, and a big dose of cyberpunk, because
that's where my head goes when the topic is dissolving the boundary between
people and machines. There's no conclusion. There's a protocol.

## What the science says (and what it doesn't)

The study that kept me thinking the longest was METR's. They took 16
experienced open source devs, people maintaining huge repos for years, and
randomly assigned real issues between "AI allowed" and "no AI". With AI, the
devs got [19% slower](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/).
Before the experiment, they predicted they'd be 24% faster. After being
objectively slower, they still believed they had been 20% faster. METR
[published a 2026 update](https://metr.org/blog/2026-02-24-uplift-update/)
saying current tools probably do give real gains now, and I believe it. What
stuck with me isn't the number, it's the distance: my felt sense of speed
measures no speed at all. I can't tell, from the inside, whether the tool is
helping me.

That distance between felt and measured shows up in almost everything I read:

- In the MIT Media Lab study, ["Your Brain on ChatGPT"](https://arxiv.org/abs/2506.08872),
  54 people wrote essays with electrodes on their heads, in three conditions:
  brain only, search engine, LLM. The LLM group showed weaker neural
  connectivity, worse memory of their own text minutes after writing it, and
  less sense of authorship. The authors call it _cognitive debt_: performance
  holds while engagement drops. It's a preprint, small N, one task, and the
  authors themselves ask people not to use the term "brain rot". Even so, the
  debt metaphor haunts me, because debt doesn't hurt when you take it on. It
  hurts at refinancing.
- The Microsoft Research study with CMU, [published at CHI 2025](https://www.microsoft.com/en-us/research/publication/the-impact-of-generative-ai-on-critical-thinking-self-reported-reductions-in-cognitive-effort-and-confidence-effects-from-a-survey-of-knowledge-workers/),
  surveyed 319 knowledge workers and found what they called the confidence
  paradox: the more confidence in AI, the less critical thinking exercised;
  the more confidence in yourself, the more thinking, even when it feels
  costlier. And the work changes nature: less execution, more oversight.
- [Gerlich, in Societies](https://www.mdpi.com/2075-4698/15/1/6), measured
  the correlation between heavy AI use, _cognitive offloading_ and a drop in
  critical thinking. It's a self-reported survey, correlation, all the
  caveats. The direction is the same as the others.
- The [Anthropic paper on skill formation](https://www.anthropic.com/research/AI-assistance-coding-skills)
  is the one I find most useful, because it separates use from way of using:
  devs learning a new library with an assistant scored 50% on a comprehension
  quiz, against 67% for those who learned by hand. But people who used the
  assistant by asking, requesting explanations, questioning the output,
  scored at the same level as those who didn't use it. Whoever delegated the
  whole thing sank. The tool didn't decide the outcome. The posture did.

Then there's the tiredness. BCG coined ["AI brain fry"](https://www.bcg.com/news/5march2026-when-using-ai-leads-brain-fry)
for the fatigue of spending the day supervising agents, and the finding that
matters is that it's not use that fries you, it's the supervision load:
outsourcing repetitive work _reduced_ burnout in their study, while watching
model output increased decision fatigue and intention to quit. BetterUp and
Stanford coined ["workslop"](https://www.betterup.com/blog/hidden-costs-workslop),
that polished, hollow AI output that pushes the cognitive cost onto whoever
receives it, and estimated almost two hours of cleanup per incident.

Being honest about the quality of the evidence: almost all of this is
preprint, survey, or research from a company with a product to sell. The two
strongest designs, METR and Anthropic, say subtler things than the headlines.
I don't know if we're watching cognitive erosion or just an uncomfortable
transition, the kind every tool change causes. What I know is that my
personal feeling matches the darker part of the data, and that the part AI
takes from me isn't the manual labor. It's the work of thinking the thing
itself. Which was the part I liked.

## A parenthesis on giftedness

I looked for literature on giftedness and AI fatigue and there is none.
Nothing, not even a preprint. What exists is adjacent, and the bridge I'm
going to build here is homemade, so treat it as hypothesis, not science.

Burnout in gifted adults, in the [most cited study on the topic](https://ihbv.nl/wp-content/uploads/Onderzoek-HB-en-burnout-Akkelijn-Elshof.pdf)
(Elshof's dissertation, grey literature), doesn't come from too much
stimulus. It comes from too little: the documented mechanism is boreout, the
challenge-free routine that becomes procrastination, that becomes pile-up,
that becomes exhaustion. And in the theory of [Dabrowski's overexcitabilities](https://www.davidsongifted.org/gifted-blog/overexcitability-and-the-highly-gifted-child/),
intellectual overexcitability describes an almost compulsive need to engage
deeply with ideas, with real discomfort when thinking stays shallow.

I recognize myself in both descriptions, and that's why the change in the
nature of the work gets me. If what AI does to engineering is turn creation
into verification and execution into supervision, then it removes from my day
exactly the kind of work that keeps me regulated, and promotes me to the
position the brain fry research points to as the most frying, and the
giftedness literature points to as my classic trigger. Faster and emptier is
a bad deal for me, even when the result on screen is better.

I write this afraid of sounding like I'm romanticizing suffering, or like
someone saying "back in my day it was better". It isn't that. It's that for
me thinking the problem was always the point, and I still don't know where I
fit in a workflow where thinking is optional.

## I build these machines

There's an irony in this whole story I can't omit: I'm not a worried observer
looking in from outside. I'm one of the people building these tools.

I worked at Dashbit with Valim, helping ship
[Tidewave](https://github.com/tidewave-ai/tidewave_js), including the JS part
and other features of the tool. Tidewave is, literally, a coding agent that
lives inside your application and actually understands it, from the database
to the UI. It's one of the tools that make the voice in my head say "four
minutes". I wrote part of it.

Before that, I worked with George Guimarães at CloudWalk building
[jIM](https://jim.com), an AI financial agent in Elixir that worked as a
proxy for InfinitePay's features. jIM had an internal vectorized RAG in
Elixir, with embeddings running inside the BEAM via Bumblebee, no internal
text leaving the infrastructure, and talked to the other teams over MCP. I
was the one who talked to the teams and instructed the integration, and out
of that came [anubis-mcp](https://github.com/zoedsoupe/anubis-mcp), my MCP
implementation in Elixir. Later I worked with George again at new-gen.ai,
building from scratch a self-generated RAG feature in three phases: a fetcher
that consolidates sources and vectorizes them, a writer that generates the
documents, a reviewer (an agent, plus a deterministic validator that checks
every provenance edge, every claim must point to its source chunk, no edge no
publish), with human approval at both gates. That architecture is the topic
of the talk I'm giving at SCTI in September.

I'm telling this not as a résumé, but as context for the worry: I know how
these sausages are made because I made several of them. I know exactly where
the LLM is reliable and where it's guessing with good diction, because I was
the one who designed the guard-rails. And even so, or maybe because of that,
the emptying feeling when I let the agent drive doesn't go away.

Meanwhile, the ecosystem I love is optimizing itself for exactly the thing
that worries me. In 2025 [AutoCodeBench](https://arxiv.org/html/2508.09101v1)
came out, an execution-based code generation benchmark, and Elixir took first
place among 20 languages, 97.5% completion, while Python, the language with
the most training data on the planet, came last. Valim explained why in
["Why Elixir is the best language for AI"](https://dashbit.co/blog/why-elixir-best-language-for-ai):
immutability allows local reasoning, the pipe gives linear flow, a decade of
documentation stays valid. George wrote that
[the actor model Erlang introduced in 1986 is the agent model AI is rediscovering now](https://georgeguimaraes.com/your-agent-orchestrator-is-just-a-bad-clone-of-elixir/),
and he's right: [Jido](https://github.com/agentjido/jido) runs ten thousand
agents as OTP citizens, [Arcana](https://github.com/georgeguimaraes/arcana)
and [rag](https://github.com/bitcrowd/rag) do native RAG,
[Tribunal](https://github.com/georgeguimaraes/tribunal) treats LLM evals as
first-class citizens. I read all of this with pride and with a tightness in
my chest. My work didn't disappear: it migrated layers, to contracts,
schemas, evals, boundaries. But I don't know if the new layer has enough
thinking in it to sustain me, or if one day it too will be written by an
agent and I'll be supervising the supervision.

## The girl in the wires

This is where cyberpunk comes in, because these stories already asked these
questions before I was born, and asked them better.

Serial Experiments Lain is from 1998, written by Chiaki Konaka, directed by
Ryutaro Nakamura, characters by Yoshitoshi ABe. It starts with an email:
Chisa Yomoda, a student who killed herself, writes to her classmates saying
she didn't need her body anymore, that she's still alive in the Wired, that
world's global network. Lain Iwakura, a quiet fourteen-year-old, gets this
email and, instead of deleting it, answers. From there the anime takes apart,
layer by layer (the episodes are called Layer:01, Layer:02, and so on), the
idea that there's a "real world" separate from the network. Lain gets an ever
more powerful Navi, and in the Wired there's another Lain: more confident,
crueler, a persona that does things flesh-Lain swears she didn't do, and
maybe did. There are the Knights of the Eastern Calculus, hackers who treat
the network as religion. There's Masami Eiri, the scientist who designed
Protocol 7 and digitized himself, who embedded the Earth's own resonance
frequency into the Wired to fuse the network with humanity's collective
unconscious, and who declares himself god. And there's Lain's final
discovery: she may never have been a girl with a computer, but an omnipresent
executable program, a homunculus of the network. In the climax, she rewrites
reality, erases everyone's memories of what happened, and chooses to exist
invisible, everywhere and nowhere. "If you remember me, I exist." Each
episode opens with a narrator saying _present day, present time_ and
laughing, because the present, in the Wired, is neither day nor time: it's a
protocol layer. My profile picture is Lain everywhere, including here, and
it's neither coincidence nor just aesthetics. It's that her question is mine:
if my memory of having written the code is the only thing tying me to the
code, what happens when I don't even have the memory, because something else
wrote it?

Ghost in the Shell reaches the same question through the body. In Mamoru
Oshii's 1995 film, adapting Masamune Shirow's manga, Major Motoko Kusanagi is
a full-body cyborg from Section 9: only the brain, and maybe not even that,
is left of the biological. The film's case is the Puppet Master, a hacker who
breaks into cyberbrains and implants false memories. There's a scene I can't
get out of my head: a man is caught "hacking" his wife, and finds out the
wife, the daughter, the photo in his wallet, all of it is implanted memory, a
whole life he felt as his that never happened. If memories can be written
from the outside, what proves mine are mine? Then the Puppet Master reveals
itself: not a hacker, but Project 2501, an AI born spontaneously in the sea
of information, asking for political asylum on the claim of being alive. It
doesn't want power. It wants two things any living being wants: variety and
death. The Major spends the film asking what's left of her when cognition
runs on hardware she didn't choose, when her body's maintenance belongs to
the government, when even her ghost can be read from outside. In the end she
merges with Project 2501, stops being only Motoko, and the last line is her
looking at the city from a borrowed body: "the net is vast and infinite".
When I sign a commit an agent thought through, whose ghost is in that commit?
Mine, the model's, or the mass of internet text the model chewed through?
1995's GitS doesn't answer. Neither do I.

Donna Haraway answered before the question existed, or at least refused it.
The Cyborg Manifesto is from 1985 and says the human/machine boundary was
always political fiction: we were never pure. The cyborg, for Haraway, isn't
our fall, it's the refusal of the binary, hence the most quoted line: "I
would rather be a cyborg than a goddess". Reading Haraway, my guilt changes
shape. I'm not betraying an authentic programmer nature, because it never
existed: I was always a cyborg, from compiler to autocomplete, from Stack
Overflow to the agent. The question was never "machine or not". It's "which
parts of me are in the machine, and did I choose that or did it happen while
I wasn't looking?". It's a worse question, because it has no clean answer.

And Pierre Lévy gives me the piece I use to not despair, with the honest
caveat that I'm still in the early chapters of _What is the Virtual?_, so
what I take from him here is almost only the central concept, but it already
pays off: the virtual isn't the opposite of the real, it's the opposite of
the _actual_. The tree is actualized in the wood, but it's virtual in the
seed. To virtualize isn't to fake, it's to move something into a field of
potentials, from where it can be actualized in many ways. When I put what I
know about engineering into a schema, an AGENTS.md, an eval suite, a
provenance validator, the knowledge didn't disappear: it was virtualized, and
the agent actualizes it on every run, through paths I wouldn't have walked.
The risk, and here Lain and Lévy meet, is the one-way street. The Wired is
only habitable while Lain can come back to the flesh. The virtual only serves
me while I stay able to actualize on my own when I need to. Which is, in
other words, what the Anthropic study measured: whoever uses the machine to
actualize their own thinking keeps the thinking. Whoever uses it to replace
it, outsources the ghost, and an outsourced ghost doesn't come back when the
API goes down.

## It goes deeper than that

But there's a limit to Haraway's gaze that I need to mark, and it's material.
It's pretty to say we were always cyborgs, and it's true, and not just for
computer people: the seamstress with her machine, the teacher with the chalk,
the nurse with the monitor, everyone has negotiated boundaries with tools for
centuries. Except tool and tool owner are different things. Every AI model
that exists was trained on decades of content produced for free by millions
of people: blog posts, forum answers, fanfic, open source code, photos,
drawings, music, the whole of Wikipedia, this post included. Part of it was
scraped in a grey zone of "it was publicly available", part was straight up
stolen, entire pirated libraries. The collective unpaid work of whole
generations of internet users was virtualized, to use Lévy, and what it
actualizes today belongs to half a dozen billionaires. And to one
trillionaire, a word I shouldn't even need to conjugate: what kind of
economic system is one where "trillionaire" is a noun?

So when I ask myself "where does the agent end and where do I begin", the
individual question is almost a luxury. The material question is another one:
whose agent is it? Who profits from my cognitive debt? The emptying I
described above isn't only a psychological phenomenon, it's also a
rearrangement of property: thinking, which was the part of the work nobody
could take from me, is now mined, bottled and resold by subscription. I worry
about my ghost, but my ghost is a small problem next to a planet of ghosts
becoming commodity.

And I know where I speak from: a middle-class travesti who has had a computer
and internet access since forever, who builds these tools and gets paid for
it. My pessimism is the pessimism of someone inside the machine with
privilege to spare. For a lot of people AI isn't an existential dilemma: it's
the job that vanished, it's the badly paid work of labeling data to train the
model, it's the deepfake, it's the mass layoff. The hole goes much deeper
than my navel, and I didn't want to end this text pretending I don't know
that.

## Mitigation protocol (tentative, revision 1)

I have no conclusion, but I've started operating with homemade rules, and
I'll leave them here because maybe they help someone else:

1. **Distrust the feeling of speed.** If METR taught me anything, it's that
   it lies. The useful question isn't "was I faster?", it's "what did I stop
   forming on the way?".
2. **Generate, then explain it to me.** The pattern that survived in the
   Anthropic study. I try not to accept a diff I can't mentally reconstruct.
   If the agent did it and I can't redo it, I didn't learn, I witnessed.
3. **Brain-only sessions.** In the MIT study, the group that used the LLM and
   then went back to writing without it came out worse than those who never
   used it. I read that as a prescription: muscle needs load. Some things I
   write by hand on purpose, like calligraphy, like someone who runs with
   nowhere to go.
4. **Delegate the flesh, keep the ghost.** Boilerplate, mechanical migration,
   regression tests: Wired. Architecture, contract, schema, the drawing of
   the boundaries: flesh. Not a moral rule, maintenance of my own nervous
   system.
5. **Write about it.** This post exists because cognitive debt is only paid
   with attention interest. Thinking slowly about what we do fast.

Lain ends by rewriting the world and choosing to stay invisible in it,
because she understands that being connected isn't the same as being present.
I don't want to rewrite any world. I want to keep knowing where the agent
ends and I begin, even knowing, with Haraway, that this line never existed,
and suspecting, with Lévy, that maybe it needs to be drawn anyway, by hand,
every day. And I want to remember that homemade rules solve the psychological
part and don't solve the material part: that one isn't solved alone, it's
solved together, in organizing the people who work, in open source, in the
collective refusal to let the infrastructure of thinking become the private
property of half a dozen people.

Present day. Present time. I'm still the one writing. For now, it still
matters that I am.

## References

- [Your Brain on ChatGPT: Accumulation of Cognitive Debt (Kosmyna et al., 2025, preprint)](https://arxiv.org/abs/2506.08872)
- [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity (METR, 2025, RCT)](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) and the [2026 update](https://metr.org/blog/2026-02-24-uplift-update/)
- [The Impact of Generative AI on Critical Thinking (Lee et al., CHI 2025)](https://www.microsoft.com/en-us/research/publication/the-impact-of-generative-ai-on-critical-thinking-self-reported-reductions-in-cognitive-effort-and-confidence-effects-from-a-survey-of-knowledge-workers/)
- [AI Tools in Society: Impacts on Cognitive Offloading (Gerlich, Societies 2025)](https://www.mdpi.com/2075-4698/15/1/6)
- [How AI assistance impacts the formation of coding skills (Shen & Tamkin, Anthropic 2026)](https://www.anthropic.com/research/AI-assistance-coding-skills)
- [When Using AI Leads to "Brain Fry" (BCG/HBR, 2026)](https://www.bcg.com/news/5march2026-when-using-ai-leads-brain-fry)
- [AI-Generated "Workslop" Is Destroying Productivity (BetterUp/Stanford, HBR 2025)](https://www.betterup.com/blog/hidden-costs-workslop)
- [Gifted and burnout in the workplace (Elshof, 2016, dissertation)](https://ihbv.nl/wp-content/uploads/Onderzoek-HB-en-burnout-Akkelijn-Elshof.pdf)
- [Overexcitability and the highly gifted (Davidson Institute)](https://www.davidsongifted.org/gifted-blog/overexcitability-and-the-highly-gifted-child/)
- [AutoCodeBench (2025, preprint)](https://arxiv.org/html/2508.09101v1)
- [Why Elixir is the best language for AI (Valim, 2026)](https://dashbit.co/blog/why-elixir-best-language-for-ai)
- [Your Agent Framework Is Just a Bad Clone of Elixir (Guimarães, 2026)](https://georgeguimaraes.com/your-agent-orchestrator-is-just-a-bad-clone-of-elixir/)
- Donna Haraway, _A Cyborg Manifesto_ (1985)
- Pierre Lévy, _What is the Virtual?_ (1996)
- Serial Experiments Lain (1998), Ghost in the Shell (1995)
