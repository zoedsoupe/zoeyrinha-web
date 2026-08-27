%{
title: "http na unha",
description: "post 3 da série fuba web: a fubá sai do terminal. o que é um servidor, o que é http, um plug escrito na mão e o curl como voz da coelhinha.",
tags: ~w(elixir web tutorial),
series: "fuba-web",
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mtu4blegph2f",
}
---

A Fubá [já existe](https://zoedsoupe.zeetech.io/posts/o-coracao-da-fuba): tem medidores, humor, regra emocional. Só que ela mora trancada no seu `iex` - ninguém além de você consegue falar com ela. A jhujuba foi direta: "tá, mas e aí, o que é um servidor?".

Boa pergunta. Pois bem: todo mundo repete "servidor" como se fosse uma caixa mágica num datacenter, então vamos devagar - primeiro o que a palavra significa, depois o protocolo da conversa, e só então o código, que cabe em onze linhas.

## o que é um servidor, afinal

Tira o mistério: um servidor é um computador que fica ligado, esperando alguém pedir alguma coisa. Só isso. Seu terminal espera você digitar; um servidor web espera uma **requisição** chegar pela rede (internet). Quando chega, ele processa e devolve uma **resposta**. Pede, responde. Pede, responde. O dia inteiro!

Quem pede é o **cliente**. Pode ser o navegador, pode ser o app do banco no seu celular, pode ser outro servidor. A gente vai usar o `curl`, que é um cliente de linha de comando - perfeito pra ver a conversa sem o navegador escondendo nada embaixo de uma interface bonita.

E o "fica ligado esperando" acontece numa **porta**. Pensa no computador como um prédio: o endereço (`localhost`, o seu próprio) leva até o prédio, e a porta leva até o apartamento certo. O nosso vai morar na `4000`, tradição do mundo Elixir. Quando você acessa `localhost:4000`, tá dizendo "prédio localhost, apartamento 4000", tipo isso - e tem que ter alguém lá dentro ouvindo, senão ninguém atende!

## http, a gramática da conversa

Cliente e servidor precisam combinar **como** essa conversa acontece, e esse combinado é o HTTP: um protocolo, ou seja, um formato de mensagem que os dois lados entendem. Uma requisição HTTP tem:

- um **método** (o verbo do pedido: `GET` é "me mostra", `POST` é "toma isso aqui", e por aí vai);
- um **caminho** (`/`, `/biscoito`, o que você quiser - o "assunto" do pedido);
- **cabeçalhos**, que são metadados (de onde veio, que formato aceita de volta);
- e às vezes um **corpo**, quando o pedido carrega dados.

A resposta devolve um **status** (um número: `200` é "deu certo", `404` é "não achei", `500` é "quebrei"), cabeçalhos também, e um corpo com o conteúdo. Uma conversa inteira, crua, é assim:

```
GET / HTTP/1.1
Host: localhost:4000

HTTP/1.1 200 OK
content-type: text/plain; charset=utf-8

a Fubá tá te ouvindo
```

Sem mágica nenhuma. Texto indo, texto voltando. O navegador faz isso por você o dia todo - a diferença é que hoje você vai escrever o lado que responde!

## a primeira dependência

Escrever o lado que responde _do zero_ significaria escrever centenas de linhas de código, minha nossa, basicamente "escovar bit" - uma série inteira de posts só sobre isso, e não é aqui que mora o aprendizado de hoje. Então a gente adota a primeira dependência (a tal da "biblioteca" que falo o tempo todo) do projeto:

```elixir
# mix.exs
defp deps do
  [
    {:bandit, "~> 1.6"}
  ]
end
```

O **Bandit** é uma biblioteca escrita em Elixir: ele cuida de toda a parte "chata", da gramática HTTP, e chama o seu código quando uma requisição chega mastigada. Rode `mix deps.get` e o `mix` baixa o Bandit e grava no `mix.lock` as versões exatas de tudo - é esse aqrquivo que garante que amanhã (ou na máquina de outra pessoa) vai baixar exatamente o mesmo código.

A nota de responsabilidade: dependência é código de outra pessoa rodando no seu projeto, então cada uma entra com motivo. O motivo dessa é literalmente o título do post - HTTP na unha, mas sem reinventar a roda, né.

## um plug

O Bandit não sabe o que fazer com a requisição - quem sabe é um **Plug**, que é a sua parte. Plug é um contrato mínimo, uma receitinha que você escreve para lidar com a requisição:

```elixir
# lib/fuba_web/plug.ex
defmodule FubaWeb.Plug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain; charset=utf-8")
    |> send_resp(200, "a Fubá tá te ouvindo")
  end
end
```

Olha o que acontece aí. Quando uma requisição chega, o Bandit monta uma struct `%Plug.Conn{}` - a variável que chamamos de `conn`, a requisição virada em dado Elixir: método, caminho, cabeçalhos, tudo dentro - e chama `call/2` com ela. Sua função devolve uma `conn` com a resposta preenchida, e o Bandit transforma isso de volta em texto HTTP. `init/1` roda uma vez só, pra preparar opções; a gente não tem nenhuma, então ela só repassa.

E a `conn` é imutável como tudo em Elixir: `put_resp_content_type/2` não "muda" a conexão, devolve outra com o cabeçalho a mais. Por isso o pipe - a `conn` vai entrando em cada função e saindo mais completa, igual a coelhinha do post passado entrando nas ações de cuidado.

Duas coisas pra reparar. A primeira: o módulo mora em `lib/fuba_web/`, não em `lib/fuba/`. Convenção proposital - tudo que fala com a internet fica em `FubaWeb`, e o `Fuba` do post passado segue sem saber que internet existe. A segunda: o Plug responde sempre a mesma frase e ignora método, caminho, tudo. Tá certo que ele não usa a coelhinha ainda? Tá. Um passo de cada vez, né...

## subindo na "árvore"

Falta alguém ligar isso. Lembra do supervisor vazio que o `--sup` deixou? No arquivo `lib/fuba/application.ex`? Chegou a vez de usar ele:

```elixir
# lib/fuba/application.ex
def start(_type, _args) do
  children = [
    {Bandit, scheme: :http, plug: FubaWeb.Plug, port: 4000}
  ]

  opts = [strategy: :one_for_one, name: Fuba.Supervisor]
  Supervisor.start_link(children, opts)
end
```

Esse arquivo é basicamente uma listinha de bibliotecas ou itens que precisam ser inicializados quando o seu código for executado. Quando a Fubá roda, o Elixir também sobe o Bandit junto, apontando pro nosso Plug na porta 4000. E se o Bandit morrer - deu error, bug, qualquer coisa - a estratégia `:one_for_one` diz "levanta ele de novo". Esse é o porquê do `--sup` do post passado: a gente não escreveu um `if` de tratamento de erro e o servidor já nasce à prova de queda!

## dando voz

Sobe:

```sh
iex -S mix
```

E em outro terminal, fala com ela:

```sh
curl -i localhost:4000
```

```
HTTP/1.1 200 OK
content-type: text/plain; charset=utf-8

a Fubá tá te ouvindo
```

Aí está! O programa que você escreveu ouviu um pedido pela rede e respondeu. Tenta também `curl -i localhost:4000/biscoito` - mesma resposta, porque o Plug ignora o caminho. E abre `http://localhost:4000` no navegador: a mesma conversa! O navegador é só um cliente HTTP que sabe desenhar.

Brincadeiras pra concertar, se quiser: muda a frase e recompila (`recompile()` dentro do `iex`), troca o `200` por `418` e vê o `curl` te contar que você virou uma chaleira, apaga o `put_resp_content_type` e vê o que muda no cabeçalho. Quebrar essas coisas é o jeito mais divertido de aprender.

## fechou?

Três critérios:

1. `iex -S mix` sobe sem erro.
2. `curl localhost:4000` responde `a Fubá tá te ouvindo` - e `curl -i` te mostra o `200 OK` por cima.
3. Você consegue dizer, em voz alta, quem pediu, quem respondeu, em que porta, e qual parte do código sua foi chamada.

Fechou? A Fubá agora tem voz, mesmo que ela só saiba dizer uma frase e ignore qualquer pedido. No próximo post ela ganha rosto: a página HTML e CSS servidos de verdade - a telinha bonita, finalmente, ainda que parada, sem reagir.

É isso o post 💜
