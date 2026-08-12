%{
  title: "peri learns to coerce",
  description: "peri 0.10.0: string params become typed data, errors become maps you can actually render, schemas compose, and Phoenix forms no longer need Ecto.",
  tags: ~w(elixir peri oss)
}
---

New peri release out. Four things landed, all stolen shamelessly from malli and
zod, which is what inspiration means if you are honest about it.

The big one: coercion. HTTP params are all strings, and until now peri would
just reject them. No more.

```elixir
defschema :params, %{
  page: {:coerce, :string, {:integer, {:gte, 1}}},
  admin: {:coerce, :string, :boolean}
}

MySchemas.params(%{"page" => "2", "admin" => "true"})
#=> {:ok, %{page: 2, admin: true}}
```

There is `Peri.encode/3` too, which runs the schema backwards, so decode and
encode round-trip. Very codec. Very symmetric. I am pleased.

Also: `Peri.Error.humanize/1` gives you `%{email: ["is required"]}` instead of
a struct tree, missing required keys now come with a "did you mean" (you typed
`emial`, we have all typed `emial`), schemas compose with `merge/select/except`,
and `Peri.Phoenix.to_form/3` feeds a schema straight into LiveView forms without
Ecto anywhere in sight.

That is it. Go validate something.
