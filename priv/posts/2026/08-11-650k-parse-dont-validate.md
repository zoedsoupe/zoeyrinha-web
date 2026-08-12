%{
  title: "650k downloads: parse, don't validate",
  description: "peri passed 650k downloads on Hex. A thank-you, and the idea the whole library is built on: parse, don't validate. In English and in Portuguese.",
  tags: ~w(elixir peri oss)
}
---

*This post is bilingual: English first, [português embaixo](#obrigada).*

peri passed 650,000 downloads on Hex. That number is abstract until you think
about what it actually is: six hundred and fifty thousand CI runs, deploys, and
`mix deps.get` calls pulling a validation library I wrote in my spare time
because Ecto changesets annoyed me one too many times. So: thank you. Genuinely.

It feels like the right moment to write down the idea peri is built on, because
the idea is not mine. It comes from Alexis King's 2019 post
[Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/),
which is the best eleven paragraphs ever written about data integrity, and which
you should read instead of this post if you only have time for one.

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
because it makes the case for parsing *stronger*, not weaker.

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
and go validate something. Sorry, go *parse* something.

---

<a id="obrigada"></a>

## 650 mil downloads: faça parsing, não validação

O peri passou de 650 mil downloads no Hex. É um número abstrato até você pensar
no que ele realmente é: seiscentos e cinquenta mil pipelines de CI, deploys e
`mix deps.get` baixando uma biblioteca de validação que eu escrevi no meu tempo
livre porque o changeset do Ecto me irritou uma vez demais. Então: obrigada. De
verdade!

Acho que é o momento certo pra escrever sobre a ideia por trás do peri, porque
a ideia não é minha. Ela vem do artigo de 2019 da Alexis King,
[Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/)
(_"faça parsing, não validação"_), que são os melhores onze parágrafos já
escritos sobre integridade de dados. Se você só tiver tempo de ler uma coisa
hoje, leia ele, não este post.

### A ideia

A distinção, em Elixir. Isto é validação:

```elixir
def usuario_valido?(params) do
  is_binary(params["email"]) and is_integer(params["age"])
end
```

Ela checa o dado e depois joga fora tudo o que aprendeu. Retorna `true`, e
`true` não carrega prova nenhuma. Todas as funções depois dela recebem o mesmo
mapa cru e têm duas opções: checar de novo, ou confiar. Checar de novo é lógica
duplicada espalhada pelo código. Confiar através de fronteiras de módulos é
como `nil` vai parar no seu banco de dados. Já vimos esse filme!

Isto é parsing:

```elixir
def parse_usuario(params) do
  with {:ok, email} <- parse_email(params["email"]),
       {:ok, age} <- parse_age(params["age"]) do
    {:ok, %User{email: email, age: age}}
  end
end
```

A saída é uma coisa diferente e mais estruturada que a entrada. Um `%User{}`
não é só um dado, é uma evidência: se você está segurando um, alguém já
verificou. Nas palavras da King: um parser consome entrada menos estruturada e
produz saída mais estruturada, e um validador é só um parser que joga o
resultado fora.

Ela também dá nome ao modo de falha, emprestado do LangSec (_language-theoretic
security_): **shotgun parsing** (_parsing de espingarda_, e o nome é ótimo), o
antipadrão onde as checagens ficam espalhadas pelo código de processamento como
chumbo, cada uma disparando só quando a execução chega nela. O programa não
consegue rejeitar entrada inválida logo de cara, então quando uma checagem
falha você talvez já tenha mandado o e-mail, cobrado o cartão, escrito no banco.
A solução é estratificar o programa em duas fases: parsing na fronteira,
execução depois, em cima de dados já provados. Empurre o peso da prova pra cima
o máximo que der!

### Mas Elixir tem tipos agora?

Quando eu escrevi sobre isso [lá em 2024](https://dev.to/zoedsoupe/parse-dont-validate-embracing-data-integrity-in-elixir-5c94)
(esse artigo está, bem, velho), o argumento era mais simples: Haskell garante
provas em tempo de compilação, Elixir não tem sistema de tipos estático, então
a gente carrega as provas em tempo de execução, em structs, tuplas tagueadas e
pattern matching. Isso ficou menos verdade, e que bom! Desde o Elixir 1.18 a
linguagem vem embutindo no próprio compilador um
[sistema de tipos gradual e teórico-conjuntista](https://elixir.hexdocs.pm/main/gradual-set-theoretic-types.html)
(_gradual set-theoretic type system_), e vale ser precisa sobre o que isso
significa, porque ele deixa o argumento do parsing *mais forte*, não mais
fraco.

Teórico-conjuntista quer dizer que tipos combinam como conjuntos: uniões
(`integer() or nil`), interseções (`and`), negações (`not`). O compilador já
entende tipos literais de tupla como `{:ok, binary()}`, mapas fechados e
abertos, e infere tudo isso dos seus patterns e guards sem você escrever uma
única anotação (a [colinha de tipos](https://elixir.hexdocs.pm/main/types-cheat.html)
mostra até onde a notação vai). Gradual quer dizer que código sem anotação não
fica invisível: ele é checado como `dynamic() -> dynamic()`, e aí o motor de
inferência vai refinando o `dynamic()` conforme seu código estreita os
possíveis valores, então uma variável que casou com `%User{}` deixa de ser
`dynamic()` e passa a ser uma usuária.

E aqui vem a parte que importa pra este post: a própria documentação do sistema
de tipos desenha a fronteira exatamente onde a King desenha. Chamadas pra
código sem tipos ou do mesmo projeto são assumidas como `dynamic()`. Os avisos
são _best-effort_ por design. E o `dynamic()` sempre fica na raiz do tipo:
`{:ok, dynamic()}` é reescrito como `dynamic({:ok, term()})`, porque não dá pra
ser gradual sobre metade de uma estrutura. Em outras palavras: o sistema de
tipos raciocina lindamente sobre o `%User{}` fluindo pela sua regra de negócio,
mas o JSON que acabou de chegar pela rede é `dynamic()` na raiz, e alguém
precisa fazer esse estreitamento, uma única vez, num único lugar, em tempo de
execução. Esse alguém é um parser.

O roadmap aponta na mesma direção: structs tipados são o próximo passo,
assinaturas escritas pelo usuário vêm depois, e o artigo do José Valim
[data evolution with set-theoretic types](https://dashbit.co/blog/data-evolution-with-set-theoretic-types)
(_evolução de dados com tipos teórico-conjuntistas_) explora como bibliotecas
poderiam alargar suas definições de dados entre versões sem quebrar ninguém,
usando subtipagem estrutural (um struct é tipado pelo que ele realmente contém,
não pelo nome dele) e revisões. Lê ele e repara quanto dele é sobre a mesma
obsessão: qual o formato do dado em cada ponto por onde ele flui, e quem pode
prometer o quê. Mesmo num futuro de Elixir completamente tipado, o parsing de
fronteira não desaparece. Ele é o momento em que `dynamic()` vira um tipo em
que o compilador pode confiar.

### O peri é essa fronteira

Que é exatamente a razão de existir da biblioteca:

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
```

Repara no que volta em caso de sucesso: não é `:ok`, não é `true`, é o próprio
dado, normalizado (chaves em átomo, defaults preenchidos, tipos garantidos). E
repara no que volta em caso de falha: um struct de erro que você pode dar
pattern match, percorrer e renderizar, com `Peri.Error.humanize/1` pra quando
você só quer um `%{email: ["is required"]}`. Erros como dados, porque erros
são dados. E como parâmetros HTTP chegam todos como strings, tem coerção
também, então `%{"page" => "2"}` vira `%{page: 2}` logo na fronteira do
controller, exatamente onde a King diz que o parsing deve acontecer.

Então, 650 mil. Obrigada a todo mundo que abriu issue, mandou PR, discutiu
comigo sobre semântica de coerção (vocês estavam certos), ou só silenciosamente
adicionou `{:peri, ...}` num `mix.exs` por aí. Faça parsing na fronteira, dê
pattern match na prova, e vá validar alguma coisa. Ops, vá *parsear* alguma
coisa!
