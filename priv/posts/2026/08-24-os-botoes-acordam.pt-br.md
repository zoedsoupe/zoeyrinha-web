%{
title: "os botões acordam",
description: "post 6 da série fuba web: os botões cuidam de verdade. formulário, POST, um redirect 303 e a página que pisca.",
tags: ~w(elixir web tutorial),
series: "fuba-web",
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mtu2n7vhy72f",
}
---

No fim do [post passado](https://zoedsoupe.zeetech.io/posts/html-vivo) ficou a promessa: a página já _mostra_ a coelhinha de verdade, mas clicar nos botões ainda não _fala_ com ela. A jhujuba clicou no café umas cinco vezes, viu a cafeína continuar em um quadradinho, e sentenciou: "botão de mentira". Minha nossa. Hoje os botões acordam de verdade - e o preço disso é a página piscando, que eu já tinha avisado (avisei!).

A parte boa: o código de hoje é pequeno. Uma mudança no template, uma rota nova, fim. A parte melhor: nada disso é mágica de framework - é HTML de 1995 fazendo o trabalho, e fazendo bem.

## o formulário

Lá no post da [página morta](https://zoedsoupe.zeetech.io/posts/a-pagina-morta) eu disse que um `<button>` sozinho é uma maçaneta pintada na parede: desenho de botão, nada mais. O que liga a maçaneta na porta é o `<form>`, a peça do HTML que diz "quando clicarem aqui, manda isso pro servidor". Olha a reforma dos botões no `tela.html.eex`:

```html
<div class="acoes">
  <form method="post" action="/cuidar">
    <button name="acao" value="biscoito">🍪 biscoito</button>
  </form>
  <form method="post" action="/cuidar">
    <button name="acao" value="cafe">☕ café</button>
  </form>
  <form method="post" action="/cuidar">
    <button name="acao" value="cafune">🫶 cafuné</button>
  </form>
  <form method="post" action="/cuidar">
    <button name="acao" value="espaco">🍃 espaço</button>
  </form>
</div>
```

Cada botão ganhou um formulário próprio (parece repetitivo, já já eu explico), e cada peça aí tem função:

- `action="/cuidar"` - pra **onde** o aviso vai: um caminho novo, que ainda não existe no roteador;
- `method="post"` - **como** ele vai. Lembra do post 3? `GET` é "me mostra", `POST` é "toma isso aqui". Clicar no botão não é pedir pra ver nada, é entregar um cuidado pra coelhinha;
- `name="acao" value="cafe"` - **o que** vai dentro do aviso. Um par nome=valor, tipo um bilhetinho preenchido: "acao: cafe".

Visualmente nada mudou: mesmos quatro botões, mesma carinha. Mas agora o clique monta uma requisição de verdade:

```
POST /cuidar HTTP/1.1
Host: localhost:4000
content-type: application/x-www-form-urlencoded

acao=cafe
```

O navegador junta os `name`/`value` do formulário num texto `acao=cafe` e manda no **corpo** do pedido. Esse formatinho `nome=valor&outro=valor` é o tal do `form-urlencoded`, o jeito mais velho de mandar dados pela web - e o navegador fala ele sozinho, sem uma linha de JavaScript! Um formulário por botão parece exagero, mas é o preço do zero JS: cada formulário carrega um valor só, e o clique escolhe qual sai.

## a rota nova

Quem atende o aviso é o roteador, que até agora só conhecia o `get "/"`. Pois bem, a sala nova:

```elixir
# lib/fuba_web/router.ex
post "/cuidar" do
  {:ok, corpo, conn} = Plug.Conn.read_body(conn)
  %{"acao" => acao} = Plug.Conn.Query.decode(corpo) # sim, decode na mão :P

  Fuba.Guarda.atualizar(&Fuba.Cuidado.aplicar(&1, String.to_existing_atom(acao)))

  conn
  |> put_resp_header("location", "/")
  |> send_resp(303, "")
end
```

Quatro linhas, quatro acontecimentos. Vamos devagar:

**`post "/cuidar"`** - igual ao `get "/"`, mas atende só `POST` nesse caminho. É por isso que o formulário dizia `method="post" action="/cuidar"`: os dois lados precisam combinar verbo e endereço. Aliás, testa `curl localhost:4000/cuidar` (que faz um `GET`) e toma um "nada aqui, uai" na cara - método errado, cai no pega-tudo.

**`read_body/1`** - lê o corpo do pedido, aquele `acao=cafe` que o navegador mandou, e devolve `{:ok, corpo, conn}`: o texto lido e uma `conn` nova. Note que até ler o corpo "devolve outra conexão" - imutável, lembra?

**`Query.decode/1`** - transforma o texto `acao=cafe` no mapa `%{"acao" => "cafe"}`. E o casamento de padrão `%{"acao" => acao}` já desembala o valor na hora: se o corpo vier sem `acao`, nem entra na rota. Estouro na cara, que é como a gente gosta.

**A linha que cuida** - `String.to_existing_atom/1` converte o texto `"cafe"` no átomo `:cafe`, e aí `Guarda.atualizar/1` recebe uma função: `&Fuba.Cuidado.aplicar(&1, :cafe)`. O `&1` é a coelhinha que tá dentro da caixinha agora - a Guarda tira ela de lá, passa no `aplicar/2` do post 2, e guarda a que volta. Repara: quem decide se o cuidado vale continua sendo o `Fuba.Cuidado`. Desregulada? O `aplicar/2` ignora o biscoito do mesmo jeito que ignorava no `iex`. A telinha só aperta o botão; a regra é da coelhinha!

## o átomo desconfiado

Por que `to_existing_atom` e não `to_atom`? Porque átomo em Elixir **nunca sai da memória**: uma vez criado, mora ali pra sempre, pra sempre, pra sempre. Se a rota aceitasse criar átomo de qualquer texto, qualquer pessoa com um `curl` podia mandar `acao=banana1`, `acao=banana2`, `acao=banana3`... e encher a memória do servidor de átomos inúteis até ele morrer. É um ataque clássico, com nome e tudo: _atom exhaustion_.

O `to_existing_atom` é o segurança da porta: só entra texto que vire um átomo **que já existe** no programa. `:biscoito`, `:cafe`, `:cafune`, `:espaco` existem, tão escritos no `Fuba.Cuidado` desde o post 2. Qualquer outra coisa leva erro na cara. Testa:

```sh
curl -i -X POST -d "acao=banana" localhost:4000/cuidar
```

Erro 500 e um `ArgumentError` bonito no terminal. Rude com a banana? Talvez. Mas servidor que confia em texto vindo da internet não dura um dia, pela mor.

## o 303, ou: por que a rota não devolve a página

Última peça, e a mais esquisita: a rota do cuidado **não responde HTML**. Ela responde um status `303` com um cabeçalho `location: /` - que em HTTP quer dizer "deu certo, agora vai olhar ali". O navegador recebe o 303 e, sozinho, faz um `GET /` em seguida. E quem responde o `GET /` é a rota antiga: espia a caixinha (já atualizada!), renderiza, devolve a página fresca.

Mas por que essa volta toda, em vez de renderizar a página direto na resposta do POST? Senta que lá vem história: a culpa é do botão de atualizar do navegador. Se o HTML viesse como resposta do `POST`, dar F5 significaria "repete aquele POST" - e o navegador ia te mostrar aquele aviso assustador de "deseja reenviar o formulário?", além de dar um café duplo na coelhinha sem você pedir. Com o redirect, o F5 repete só o `GET /`, que é inofensivo: "me mostra" de novo. Esse padrão tem nome: **Post/Redirect/Get**. POST cuida, redirect aponta, GET mostra!

E o preço, eu tinha prometido contar: **a página pisca**. Cada clique é um POST, um redirect, um GET e a página inteira desenhada de novo do zero. Por uma fração de segundo, tela branca. Em 1995 ninguém reclamava. Hoje a gente nota - e é exatamente essa coceira que o próximo post coça.

## vamos ver isso funcionando

Sobe com `iex -S mix`, abre `http://localhost:4000`. Clica no ☕ café.

Piscou. E a barrinha de cafeína subiu um quadradinho. A carinha, a frase, tudo recalculado - porque a página que voltou foi montada com a coelhinha _depois_ do café. Delícia.

Também dá pra ver a conversa crua, sem navegador:

```sh
curl -i -X POST -d "acao=cafe" localhost:4000/cuidar
```

```
HTTP/1.1 303 See Other
location: /
```

E aí `curl localhost:4000` mostra o HTML com a cafeína maior - o GET que o navegador faria por você.

Agora a brincadeira boa: zera dois medidores no `iex` (`Fuba.Guarda.atualizar(fn c -> %{c | biscoito: 0, cafeina: 0} end)`), volta no navegador e clica no biscoito. Piscou... e nada mudou kk. Desregulada, ela recusa: a regra emocional do post 2 segurando a porta, agora via HTTP. Clica no 🍃 espaço e aí sim ela melhora. O botão fala com o servidor, mas quem manda é a coelhinha.

## fechou?

Três critérios:

1. Clicar em cada botão muda o medidor certo no próximo desenho da página - café enche cafeína, espaço enche energia e tira um tiquinho de carinho.
2. `curl -i -X POST -d "acao=cafe" localhost:4000/cuidar` responde `303` com `location: /`, e o `curl localhost:4000` seguinte mostra a cafeína nova.
3. Você consegue explicar, em voz alta, por que `to_existing_atom` e por que o 303 em vez de responder o HTML direto.

Fechou? A Fubá agora é um bichinho virtual de verdade: mostra o estado, reage ao clique, impõe as regras dela. Só falta resolver a piscada, essa tela branca entre o clique e a resposta. Existe um jeito do botão falar com o servidor **sem recarregar a página**, onde só o quadradinho que mudou se redesenha. Tem nome, tem framework, e é a coisa mais Elixir do mundo: LiveView. A Fubá migra no próximo post - e é isso o post 💜
