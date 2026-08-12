%{
title: "650k downloads: parse, don't validate",
description: "peri passed 650k downloads on Hex. A thank-you, and the idea the whole library is built on: parse, don't validate.",
tags: ~w(elixir peri oss),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3msuf6xur522z",
}
---

peri passed 650,000 downloads on Hex. That number is abstract until you think
about what it actually is: six hundred and fifty thousand CI runs, deploys, and
`mix deps.get` calls pulling a validation library I wrote in my spare time. So:
thank you. Genuinely.

peri diverges from Ecto changesets on purpose, and lives alongside them
happily. Ecto is a composable relational mapper I have a lot of love for; peri
is the piece I wanted after good times elsewhere, parsing at the boundary in
Haskell and working with plumatic schema, and later malli, in Clojure. Elixir
felt like it was missing that friend, so I wrote one. If Ecto itself ever grows
something in this direction, that would be a win too.

It feels like the right moment to write down the idea peri is built on, because
the idea is not mine. It comes from Alexis King's 2019 post
[Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/),
which is the best eleven paragraphs ever written about data integrity, and which
you should read instead of this post if you only have time for one.

## What is peri?

For anyone landing here without context: peri is a small Elixir library for
describing the shape your data should have, and then checking real data against
that shape. The schema language is plain Elixir data: maps, tuples, keyword
lists, and atoms. No special syntax to learn. And schemas compose, so a shape
you defined once can be reused inside bigger ones. You can parse any Elixir
term, from a raw integer or a `DateTime` up to a deeply nested map, and peri
turns untrusted input, like HTTP params or a JSON payload, into data the rest
of your app can trust, or into an error you can show to a human. It depends on
nothing and doesn't care whether you use Ecto, Phoenix, or neither. The rest of
this post is about _why_ that shape-checking step matters.

## The idea

The distinction, in Elixir terms. This is validation:

```elixir
def valid_user?(params) do
  is_binary(params["email"]) and is_integer(params["age"])
end
```

It checks the data and then throws away everything it learned. It returns
`true`, and `true` carries no proof of anything. Every function downstream gets
the same raw map and has two options: check again, or trust. Check again is
duplicated logic scattered across the codebase. Trust across module boundaries
is how `nil` ends up in your database.

This is parsing:

```elixir
def parse_user(params) do
  with {:ok, email} <- parse_email(params["email"]),
       {:ok, age} <- parse_age(params["age"]) do
    {:ok, %User{email: email, age: age}}
  end
end
```

The output is a different, more structured thing than the input. A `%User{}` is
not just data, it is evidence: if you are holding one, somebody already checked.
King's phrasing: a parser consumes less-structured input and produces
more-structured output, and a validator is just a parser that throws its result
away.

She also names the failure mode, borrowing from LangSec: **shotgun parsing**,
the antipattern where validation checks are scattered through the processing
code like buckshot, each one firing only when execution happens to reach it.
The program can't reject bad input up front, so by the time a check fails you
may already have sent the email, charged the card, written the row. The fix is
to stratify the program into two phases: parse at the boundary, then execute on
data that is already proven. Push the burden of proof upward as far as it will
go.

## But Elixir has types now?

When I wrote about this [back in 2024](https://dev.to/zoedsoupe/parse-dont-validate-embracing-data-integrity-in-elixir-5c94)
(that article is, well, old), the argument was simpler: Haskell enforces proofs
at compile time, Elixir has no static type system, so we carry our proofs at
runtime instead, in structs, tagged tuples, and pattern matching. That is less
true now, and delightfully so. Since Elixir 1.18 the language has been growing
a [gradual set-theoretic type system](https://elixir.hexdocs.pm/main/gradual-set-theoretic-types.html)
into the compiler itself, and it is worth being precise about what that means,
because it makes the case for parsing _stronger_, not weaker.

Set-theoretic means types compose like sets: unions (`integer() or nil`),
intersections (`and`), negations (`not`). The compiler already understands
literal tuple types like `{:ok, binary()}`, closed and open maps, and it infers
all of this from your patterns and guards without you writing a single
annotation (the [types cheat sheet](https://elixir.hexdocs.pm/main/types-cheat.html)
shows how far the notation goes). Gradual means untyped code is not invisible:
it is checked as `dynamic() -> dynamic()`, and then the inference engine
refines `dynamic()` as your code narrows it, so a variable matched against
`%User{}` stops being `dynamic()` and starts being a user.

And here is the part that matters for this post: the type system's own
documentation draws the boundary in exactly the place King does. Calls into
untyped or same-project code are assumed `dynamic()`. Warnings are best-effort
by design. And `dynamic()` always sits at the root of a type: `{:ok, dynamic()}`
gets rewritten to `dynamic({:ok, term()})`, because you cannot be gradual about
half a structure. In other words, the type system can reason beautifully about
the `%User{}` flowing through your business logic, but the JSON that just
arrived over the network is `dynamic()` at the root, and somebody has to do the
narrowing, once, in one place, at runtime. That somebody is a parser.

The roadmap points the same direction: typed structs are next, user-facing
signatures come after, and José Valim's
[data evolution with set-theoretic types](https://dashbit.co/blog/data-evolution-with-set-theoretic-types)
explores how libraries could widen their data definitions across versions
without breaking anyone, using structural subtyping (a struct is typed by what
it actually contains, not by its name) and revisions. Read it and notice how
much of it is about the same obsession: what shape is the data, at every point
it can flow, and who is allowed to promise what. Even in a fully typed Elixir
future, the boundary parse does not disappear. It is the moment `dynamic()`
becomes a type the compiler can trust.

## peri is that boundary

Which is the whole point of the library:

```elixir
defmodule MyApp.Schemas do
  import Peri

  defschema :user, %{
    name: {:required, :string},
    email: {:required, :string},
    age: {:integer, {:gte, 18}},
    role: {:enum, [:admin, :user, :guest]}
  }
end

MyApp.Schemas.user(%{name: "Zoey", email: "zoey@zeetech.io", age: 30, role: :admin})
# => {:ok, %{name: "Zoey", email: "zoey@zeetech.io", age: 30, role: :admin}}

MyApp.Schemas.user(%{name: "Zoey", age: 12})
# => {:error, %Peri.Error{}}
```

Note what comes back on success: not `:ok`, not `true`, but the data itself,
normalized (atom keys, defaults filled, types guaranteed). Note what comes back
on failure: an error struct you can pattern match, traverse, and render, with
`Peri.Error.humanize/1` for when you just want `%{email: ["is required"]}`.
Errors as data, because errors are data. And since HTTP params arrive as all
strings, there is coercion too, so `%{"page" => "2"}` parses into `%{page: 2}`
right at the controller boundary, exactly where King says the parse belongs.

So, 650k. Thank you to everyone who filed an issue, sent a PR, argued with me
about coercion semantics (you were right), or just quietly added `{:peri, ...}`
to a `mix.exs` somewhere. Parse at the boundary, pattern match on the proof,
and go validate something. Sorry, go _parse_ something.
