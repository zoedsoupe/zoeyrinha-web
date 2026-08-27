%{
title: "650 mil downloads: faça parsing, não validação",
description: "peri passou de 650 mil downloads no Hex. Um obrigada, e a ideia na qual a biblioteca inteira se apoia: parse, don't validate.",
tags: ~w(elixir peri oss),
series: "peri",
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3msuf6xur522z",
}
---

peri passou de 650 mil downloads no Hex. É um número abstrato até você pensar
no que ele realmente é: seiscentos e cinquenta mil pipelines de CI, deploys e
`mix deps.get` baixando uma biblioteca de validação que eu escrevi no meu tempo
livre. Então: obrigada. De verdade!

peri diverge dos changesets do Ecto de propósito, e convive com eles
feliz da vida. O Ecto é um mapeador relacional componível pelo qual eu tenho
muito carinho; peri é a peça que eu quis depois de bons tempos em outras
terras, fazendo parsing na fronteira em Haskell e trabalhando com plumatic
schema, e depois malli, em Clojure. O Elixir parecia estar sentindo falta
desse amigo, então eu escrevi um. Se o próprio Ecto um dia crescer algo nessa
direção, também é vitória.

Pois bem, acho que é o momento certo pra escrever sobre a ideia por trás de
peri, porque a ideia não é minha. Ela vem do artigo de 2019 da Alexis King,
[Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/)
(_"faça parsing, não validação"_), que são os melhores onze parágrafos já
escritos sobre integridade de dados. Se você só tiver tempo de ler uma coisa
hoje, leia ele, não este post.

### o que é peri?

Pra quem chegou aqui de paraquedas: peri é uma bibliotecazinha de Elixir pra
descrever o formato que seus dados deveriam ter, e então conferir dados reais
contra esse formato. A linguagem de schemas é dado puro de Elixir: mapas,
tuplas, keyword lists e átomos. Sem sintaxe nova pra aprender. E schemas são
componíveis, então um formato que você definiu uma vez pode ser reutilizado
dentro de formatos maiores. Dá pra fazer parsing de qualquer termo de Elixir,
de um inteiro cru ou um `DateTime` até um mapa profundamente aninhado, e peri
transforma entrada não confiável, como parâmetros HTTP ou um payload de JSON,
em dados nos quais o resto da aplicação pode confiar, ou num erro que você pode
mostrar pra um humano. Não depende de nada e não liga se você usa Ecto, Phoenix
ou nenhum dos dois. O resto deste post é sobre _por que_ essa etapa de conferir
o formato importa!

### a ideia

Bora pra distinção, em Elixir. Isto aqui é validação:

```elixir
def usuario_valido?(params) do
  # checou... e jogou fora tudo o que aprendeu
  is_binary(params["email"]) and is_integer(params["age"])
end
```

Ela checa o dado e depois joga fora tudo o que aprendeu. Retorna `true`, e
`true` não carrega prova nenhuma. Todas as funções depois dela recebem o mesmo
mapa cru e têm duas opções: checar de novo, ou confiar. Checar de novo é lógica
duplicada espalhada pelo código. Confiar através de fronteiras de módulos é
como o `nil` vai parar no seu banco de dados. Já vimos esse filme!

Isto aqui é parsing:

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
falha, minha nossa, você talvez já tenha mandado o e-mail, cobrado o cartão,
escrito no banco. A solução é estratificar o programa em duas fases: parsing na
fronteira, execução depois, em cima de dados já provados. Empurre o peso da
prova pra cima o máximo que der!

### mas Elixir tem tipos agora?

Quando eu escrevi sobre isso [lá em 2024](https://dev.to/zoedsoupe/parse-dont-validate-embracing-data-integrity-in-elixir-5c94)
(esse artigo está, bem, velho), o argumento era mais simples: Haskell garante
provas em tempo de compilação, Elixir não tem sistema de tipos estático, então
a gente carrega as provas em tempo de execução, em structs, tuplas tagueadas e
pattern matching. Isso ficou menos verdade, e que bom! Desde o Elixir 1.18 a
linguagem vem embutindo no próprio compilador um
[sistema de tipos gradual e teórico-conjuntista](https://elixir.hexdocs.pm/main/gradual-set-theoretic-types.html)
(_gradual set-theoretic type system_), e vale ser precisa sobre o que isso
significa, porque ele deixa o argumento do parsing _mais forte_, não mais
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
tipos raciocina que é uma beleza sobre o `%User{}` fluindo pela sua regra de
negócio, mas o JSON que acabou de chegar pela rede é `dynamic()` na raiz, e
alguém precisa fazer esse estreitamento, uma única vez, num único lugar, em
tempo de execução. Esse alguém é um parser.

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
que o compilador pode confiar, tipo isso.

### peri é essa fronteira

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
pattern match na prova, e vá validar alguma coisa. Ops, vá _parsear_ alguma
coisa!

é isso o post 💜
