%{
title: "hello, world",
description: "Why this blog exists and what to expect: Elixir, distributed systems, and field notes from building things that are not supposed to fall over.",
tags: ~w(meta elixir),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3msuf6xpq3f2q",
}
---

I have been meaning to write more, so here is the first post. No grand plan, just a
place to put things I would otherwise lose in a Slack thread.

Expect posts about Elixir and the BEAM, distributed systems, functional programming,
and the occasional detour into fintech, payments, and whatever I am debugging that
week. I will keep them short and practical.

The blog itself is plain: markdown files compiled at build time by NimblePublisher,
served by Phoenix. Each post is a file like this one.

```elixir
defmodule Greeting do
  @moduledoc "The smallest thing that could possibly work."

  def hello(name), do: "oi, #{name}"
end

Greeting.hello("world")
#=> "oi, world"
```

That is it. More soon.
