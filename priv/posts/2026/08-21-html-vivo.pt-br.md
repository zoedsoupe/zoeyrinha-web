%{
title: "html vivo finalmente",
description: "post 5 da série fuba web: estático se mexe. o que é um template, eex, uma caixinha que guarda a coelhinha.",
tags: ~w(elixir web tutorial),
series: "fuba-web",
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mtu4blguvn2t",
}
---

No fim do [post passado](https://zoedsoupe.zeetech.io/posts/a-pagina-morta) ficou a pergunta: se a página mostrasse a Fubá de verdade, o que precisaria acontecer entre o pedido chegar e o HTML sair? A jhujuba pensou um pouco e respondeu: "tá... alguém precisa _montar_ o HTML na hora, né? mas... onde a coelhinha fica guardada entre um pedido e outro?".

> Licensa poética aqui, ela não pensou mas tá mó legal escrever como se fosse uma conversa com ela

Pois bem. As duas respostas dela são o post de hoje. E no meio do caminho ela soltou a pergunta oficial: "tá, mas que diacho é _template_?".

## html com buracos

Um template é um HTML com buracos. Simples assim. Em vez de escrever a carinha da Fubá no arquivo, você escreve um "buraco" no lugar dela - e quem entrega a página preenche os buracos com os valores. Olha a transformação do nosso `index.html`:

```html
<% humor = Fuba.Cuidado.humor(@fuba) %>
...
<p class="carinha"><%= Fuba.Humor.carinha(humor) %></p>
<h1><%= @fuba.nome %></h1>
<p class="humor"><%= FubaWeb.Tela.frase(humor) %></p>
...
<span class="barra <%= if @fuba.cafeina <= 1, do: "baixa" %>">
  <%= FubaWeb.Tela.barrinha(@fuba.cafeina) %>
</span>
```

O arquivo sai de `priv/static/index.html` e vira `lib/fuba_web/tela.html.eex`. O CSS continua exatamente o mesmo - o que muda são os "buracos", e eles falam Elixir:

- `<%= ... %>` - "calcula isso e **imprime** o resultado aqui";
- `<% ... %>` - "só executa, sem imprimir" (a primeira linha guarda o humor numa variável pro resto da página usar);
- `@fuba` - a coelhinha que veio de fora, entregue na hora de preencher.

Compara com a página morta: antes a carinha chatinha e a cafeína baixa estavam escritas à mão no arquivo. Agora a carinha vem de `Fuba.Humor.carinha/1`, a barrinha é desenhada a partir do número real, e o vermelho de "baixa" só aparece se o medidor estiver mesmo em 1 ou menos. A página deixou de ser uma foto e virou uma pergunta: "como tá a Fubá agora?".

## onde a coelhinha mora

Só que "como tá a Fubá agora?" esconde um problema novo. No `iex`, a coelhinha morava numa variável: `fuba = Cuidado.dar_biscoito(fuba)`. Mas o servidor atende pedidos soltos - cada `GET` é uma conversa independente, e nenhuma variável sua sobrevive de um pedido pro outro. A coelhinha precisa de um lugar pra morar **entre** os pedidos.

Em Elixir, esse lugar é um **processo**: uma caixinha leve que roda dentro da aplicação, guardando um valor e respondendo bilhetes - "me mostra", "atualiza com essa função". E ó, Elixir já traz uma caixinha pronta pra exatamente isso, o `Agent`. A nossa caixinha:

```elixir
# lib/fuba/guarda.ex
defmodule Fuba.Guarda do
  @moduledoc "A caixinha que guarda a coelhinha."

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %Fuba.Coelhinha{} end, name: __MODULE__)
  end

  def espiar, do: Agent.get(__MODULE__, & &1)
  def atualizar(fun), do: Agent.update(__MODULE__, fun)
end
```

Duas operações só: `espiar/0` devolve a coelhinha de agora, e `atualizar/1` recebe uma função e troca a coelhinha pelo resultado dela - `Cuidado.dar_biscoito/1` encaixa direto, porque ela recebe uma coelhinha e devolve outra. Tipo isso. O `name: __MODULE__` registra a caixinha com o nome do próprio módulo - nesse caso `Fuba.Guarda`, pra qualquer parte do programa achar ela sem precisar de senha.

Repara onde a Guarda mora: em `lib/fuba/`, do lado da coelhinha - ela não sabe o que é HTTP e nem internet. E não se preocupa com a teoria de processos ("caixinhas") agora, né; o `@moduledoc` já avisa que ela vem no post 8, quando a Fubá ganhar relógio.

## a tela

Quem preenche os buracos é um módulo novo:

```elixir
# lib/fuba_web/tela.ex
defmodule FubaWeb.Tela do
  require EEx

  # sim, isso é nativo :P
  EEx.function_from_file(:defp, :render_eex, "lib/fuba_web/tela.html.eex", [:assigns])

  def render(fuba), do: render_eex(%{fuba: fuba})

  def barrinha(n), do: String.duplicate("■", n) <> String.duplicate("□", 5 - n)

  def frase(:feliz), do: "tudo certo por aqui"
  def frase(:chatinha), do: "tá chatinha… cadê o café?"
  def frase(:desregulada), do: "desregulada. só espaço ajuda."
  def frase(:go_queen), do: "GO QUEEN!"
  def frase(_), do: "…"
end
```

A linha no começo é o truque: `EEx.function_from_file/4` lê o template e o transforma numa função Elixir de verdade, `render_eex/1`. Template não é um arquivo interpretado a cada pedido - depois de compilado (rodar `mix compile`), ele **é** código, tão rápido quanto qualquer função sua. O `[:assigns]` no fim diz que a função recebe um mapa, e é daí que sai o `@fuba` lá do template: `@` é atalho pra "o que me passaram", tipo uma variável especial pro template.

O `render/1` recebe uma coelhinha, bota dentro num mapa `%{fuba: fuba}`, chama a função do template. E isso tudo fica na camada web, porque é assunto de apresentação: `barrinha/1` desenha `■■■□□` enchendo de `■` até o número e completando com `□` até cinco, e `frase/1` dá uma legenda pra cada humor. Carinha é responsabilidade da coelhinha (`Fuba.Humor`); frase de efeito é da tela. Cada um com seu papel!

## o roteador

Última peça: quem responde o pedido. O `FubaWeb.Plug` foi demitido e o `Plug.Static` junto - faz sentido, né: a página não é mais um arquivo parado em disco, então não tem mais arquivo estático pra servir. No lugar, um roteador:

```elixir
# lib/fuba_web/router.ex
defmodule FubaWeb.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    corpo = FubaWeb.Tela.render(Fuba.Guarda.espiar())

    conn
    |> put_resp_content_type("text/html; charset=utf-8")
    |> send_resp(200, corpo)
  end

  match _ do
    send_resp(conn, 404, "nada aqui, uai")
  end
end
```

Um **roteador** é o recepcionista do servidor: olha o método e o caminho do pedido e encaminha pra sala certa. O `use Plug.Router` te dá os blocos `get` e `match` - `get "/"` atende só `GET` na raiz, e o `match _` no fim é a cláusula pega-tudo: qualquer outro caminho cai ali e ganha o "nada aqui, uai", que sobreviveu à reforma.

E a rota da raiz é uma linha que conta o post inteiro: **espia a coelhinha na caixinha, renderiza a tela com ela, devolve o HTML**.

Tem nome bonito pra isso, aliás: _server-side rendering_, SSR, ou "renderização do lado do servidor". O HTML nasce no servidor, fresquinho, a cada pedido. O navegador continua só desenhando - mas agora cada desenho é feito na hora.

## subindo a caixinha

Aquele arquivo que toma conta do programa, o `lib/fuba/application.ex`, ganha um morador novo:

```elixir
# lib/fuba/application.ex
children = [
  Fuba.Guarda
  {Bandit, scheme: :http, plug: FubaWeb.Router, port: 4000}
]
```

A Guarda sobe primeiro - ela precisa estar de pé antes de qualquer pedido chegar. E o Bandit agora aponta pro `FubaWeb.Router`.

## vamos ver isso funcionando

Sobe com `iex -S mix` e abre `http://localhost:4000` - nota que agora a raiz `/` funciona, porque o roteador atende `/` de propósito. A página abre feliz: `( ᵔ ᴥ ᵔ )`, "tudo certo por aqui".

Agora, no `iex`:

```elixir
iex> Fuba.Guarda.atualizar(fn c -> %{c | cafeina: 0} end)
:ok
```

Volta no navegador e atualiza a página (`ctrl+r` ou `cmd+r` no Mac).

`( ￣^￣)` - "tá chatinha… cadê o café?", e a barrinha de cafeína vermelha em um quadradinho. A página mudou porque **a coelhinha mudou**. Cada F5 é o servidor espiando a caixinha e montando o HTML daquele instante. Dá dois biscoitos nela (`Fuba.Guarda.atualizar(&Fuba.Cuidado.dar_biscoito/1)`), atualiza de novo, vê a barrinha encher. Delícia, né?

Os botões, claro, continuam mortos - a página agora _mostra_ a coelhinha, mas clicar ainda não _fala_ com ela. Falta o botão avisar o servidor. Esse aviso tem nome (formulário, `POST`) e consequência (a página pisca). Próximo post.

## fechou?

Três critérios:

1. `http://localhost:4000` abre a página feliz - na raiz, sem `/index.html`.
2. Mudar a coelhinha no `iex` com `Fuba.Guarda.atualizar/1` muda a página no próximo F5 - testa zerar a cafeína e depois dar café.
3. Você consegue explicar, em voz alta, o caminho: pedido chega → roteador → espiar a caixinha → render preenche os buracos → HTML sai.

Fechou? A Fubá agora tem rosto _e_ o rosto é dela de verdade. Só falta ele reagir ao clique do botão - e é pra isso que servem formulários. É isso o post 💜
