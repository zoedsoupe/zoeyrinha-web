%{
title: "a página ganha vida",
description: "post 7 da série fuba web: adeus, piscada. websocket num parágrafo, mix phx.new aparado, livesocket ligado na mão e o diff vazio do coração, de novo.",
tags: ~w(elixir web tutorial),
series: "fuba-web",
series_index: 6,
  bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3murx6aoqvk2k",
}
---

No fim do [post passado](https://zoedsoupe.zeetech.io/posts/os-botoes-acordam) os botões acordaram - mas com um efeito colateral que não passou despercebido: cada clique pisca a página. A jhujuba clicou no café, viu a tela branquear por uma fração de segundo e reclamou: "ué, mudou um quadradinho. por que a página inteira recarrega?". Minha nossa, ela não perdoa.

Mas... ela tem razão. E a pergunta dela é o post de hoje: como a página atualiza **sozinha**, sem recarregar? A resposta tem nome, tem framework e é a coisa mais Elixir do mundo, como eu tinha prometido: LiveView.

## o problema da piscada

Recap de dez segundos: o clique vira um `POST`, o POST vira um `303`, o 303 vira um `GET`, e o GET devolve a página inteira desenhada do zero. Cada conversa HTTP é independente - o servidor responde e esquece que você existe. Pra tela mudar sem esse ciclo todo, a conversa precisa **continuar aberta**.

## websocket num parágrafo

Um parágrafo só, prometido: se HTTP é troca de cartas (escreveu, mandou, esperou, recebeu), o **websocket** é um telefonema que ninguém desliga. Abre uma conexão e ela fica ali, ida _e_ volta, o dia todo: o navegador avisa "clicaram no café" na hora, e o servidor **empurra** a mudança sem ninguém pedir. Só isso. Todo o resto do post é o que a gente faz com um telefonema aberto.

## mix phx.new aparado

Dava pra ligar um websocket na mão no nosso Plug do post 3 - e seria dor sem aprendizado proporcional. Quem já resolveu isso é o **Phoenix**, o framework web do mundo Elixir, e a parte que nos interessa é o LiveView. Projeto novo, gerado do zero:

```sh
mix phx.new fuba_web --no-ecto --no-mailer --no-dashboard --no-gettext --no-assets
```

Olha essas flags com carinho, porque elas são metade da lição do post. Um gerador **assume** um monte de coisa por você - banco de dados, e-mail, painel administrativo, tradução, pipeline de assets (esbuild, tailwind - bibliotecas JS/CSS). Cada `--no-*` é uma assumida recusada:

- `--no-ecto` - sem banco de dados. A Fubá mora em memória e pronto (pelo menos or enquanto...);
- `--no-mailer` - sem e-mail. A coelhinha não manda newsletter;
- `--no-dashboard` - sem painel de métricas;
- `--no-gettext` - sem sistema de tradução;
- `--no-assets` - sem bundler de JS/CSS, muita complexidade pra um projeto tao simples.

Ler o que um framework assume é tão importante quanto ler o que ele gera.

Atenção que o `phx.new` cria um **projeto novo**, com vida própria - a Fubá que a gente construiu até aqui não vem junto por osmose. A migração é manual e cabe num copia-e-cola: os três módulos do coração (`coelhinha.ex`, `cuidado.ex`, `humor.ex`) vão pra `lib/fuba/` do projeto novo, e os testes do post 2 vão pra `test/fuba/`. Rode `mix test` no projeto novo: verde? O coração atravessou a rua inteiro.

Aproveita e repara na estrutura de pastas que o Phoenix organiza, porque ela é a regra de ouro desenhada em diretório:

- `lib/fuba/` - o coração, como sempre: nem HTTP, nem HTML, nem internet;
- `lib/fuba_web/` - a casquinha: roteador, endpoint, layouts, e é aqui que a LiveView vai morar;
- `lib/fuba_web.ex` - o "saguão" da casquinha, com os `use FubaWeb, :live_view` e afins que deixam os módulos web arrumados;
- `config/` - um `.exs` por ambiente (`dev`, `test`, `prod`), em vez de um config só;
- `priv/static/` - os arquivos parados: JS, CSS, imagens. Conhecemos do post 4!

E a Guarda, o Agent do post 5? Fica pra trás, aposentada. Já explico pra onde foi o emprego dela.

## o js na unha (culpa do --no-assets)

Primeira surpresa depois do `mix deps.get`: a página até abre, mas os botões... não fazem nada. De novo?! Calma, respira. Abre o `priv/static/assets/js/app.js` gerado:

```js
// For Phoenix.LiveView support, copy the following scripts
// into your javascript bundle:
// * deps/phoenix_live_view/priv/static/phoenix_live_view.js
```

O `app.js` é **só comentário**. Sem bundler, ninguém empacota o JavaScript do LiveView por você - o framework entrega as peças e um bilhete: "copie os scripts". Pois bem, copiados:

```sh
cp deps/phoenix/priv/static/phoenix.js priv/static/assets/js/
cp deps/phoenix_live_view/priv/static/phoenix_live_view.js priv/static/assets/js/
```

Esses dois arquivos são o lado JavaScript do telefonema, e expõem dois globais: `Phoenix` e `LiveView`. O nosso `app.js` inteiro vira isto:

```js
const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

const liveSocket = new LiveView.LiveSocket("/live", Phoenix.Socket, {
  params: {_csrf_token: csrfToken},
})

liveSocket.connect()
window.liveSocket = liveSocket
```

Quatro acontecimentos: pega o token anti-falsificação que o layout deixa num `<meta>` (o `protect_from_forgery` do roteador - servidor que confia em requisição alheia não dura um dia, lembra do post 6?), cria o `LiveSocket` apontando pro `/live` (o telefonema, declarado no endpoint), conecta, e pendura o bicho no `window` pra gente brincar no console depois. O layout ganha as três tags de script - `phoenix.js`, `phoenix_live_view.js`, `app.js`, nessa ordem - e pronto.

É a única vez na série inteira que a gente escreve JavaScript, e eu diria que tá de bom tamanho kk

## a fubá vira liveview

Agora o prato principal. A migração inteira cabe num arquivo, `lib/fuba_web/live/fuba_live.ex`, dividido em três funções. A primeira é o nascimento:

```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, fuba: %Coelhinha{})}
end
```

`mount/3` roda quando alguém abre a página, e devolve um `socket` - a struct que carrega tudo dessa conexão - com a coelhinha morando nos **assigns**, os "campos" dele. Agora **a coelhinha agora mora no socket**, entao pense no socket como uma "variavel", viva. Cada conexão nasce com uma `%Coelhinha{}` novinha, medidores em 3.

A segunda função é a que cuida:

```elixir
def handle_event("cuidar", %{"acao" => acao}, socket) do
  acao = String.to_existing_atom(acao)
  {:noreply, update(socket, :fuba, &Cuidado.aplicar(&1, acao))}
end
```

Compara com a rota do post 6, do lado:

```elixir
# post 6, no roteador
%{"acao" => acao} = Plug.Conn.Query.decode(corpo)
Fuba.Guarda.atualizar(&Fuba.Cuidado.aplicar(&1, String.to_existing_atom(acao)))
```

É **a mesma linha**. O segurança `to_existing_atom` continua na porta, e quem decide se o cuidado vale continua sendo o `Cuidado.aplicar/2` do post 2 - telinha nenhuma passa por cima da coelhinha! O que mudou é a volta: em vez de mandar um 303 pro navegador recarregar tudo, a gente devolve `{:noreply, socket_atualizado}` e o LiveView se vira com o resto.

E a terceira é o desenho (HTML + CSS):

```elixir
def render(assigns) do
  ~H"""
  <main>
    <p class="carinha">{Humor.carinha(Cuidado.humor(@fuba))}</p>
    <h1>{@fuba.nome}</h1>
    <p class="humor">{frase(Cuidado.humor(@fuba))}</p>
    ...
    <button phx-click="cuidar" phx-value-acao="cafe">☕ café</button>
    ...
  </main>
  """
end
```

O template é o mesmo da página viva do post 5 - mesmos buracos, mesma cara - com três novidades de sintaxe. O `~H` é um sigil que escreve **HEEx**, HTML com Elixir dentro (e verificação de bônus: tag aberta sem fechar vira erro de compilação!). Nos buracos, `{ }` no lugar do `<%= %>`. E os botões perderam o formulário: `phx-click="cuidar"` diz "ao clicar, grita 'cuidar' no telefonema", e `phx-value-acao="cafe"` é o bilhetinho que vai junto - é daí que sai o `%{"acao" => acao}` do `handle_event`. Ah, e o CSS sobreviveu inteiro, só mudou de casa: agora mora no layout raiz, o `root.html.heex`.

## o que acontece num clique

Junta tudo: você clica no café. O JS do LiveView manda o evento "cuidar" com `acao=cafe` pelo websocket. O servidor chama `handle_event`, que aplica o cuidado e devolve o socket novo. O LiveView roda `render` de novo, **compara** o HTML novo com o que a página já tem, e manda de volta pelo telefonema só o que mudou - uns bytes do tipo "o texto daquela barrinha agora é ■■■■□". O navegador troca o quadradinho e mais nada.

Sem piscada. Sem reload. Sem F5 de café duplo: o 303 e o "deseja reenviar o formulário?" morreram de morte morrida, porque não existe mais POST de formulário nenhum. E detalhe delicioso: a **primeira** vez que a página abre, ela chega como um GET normal, renderizada no servidor igualzinho ao post 5 - o telefonema só assume depois que a página já tá no ar. SSR de graça _e_ interatividade. Chique demais.

## o diff vazio, de novo

Lá no post 2 eu disse que a série inteira existe pra provar uma tese: coração limpo, casquinha na borda. O post 5 deu a primeira prova - SSR sem tocar no `Cuidado`. Hoje a segunda:

```sh
git diff post-6 main -- lib/fuba/
```

Resultado: uma coelhinha, um cuidado e um humor intactos - e um `guarda.ex` a menos, porque o socket assumiu o posto de caixinha. Do terminal ao SSR ao websocket, três casquinhas, e o coração nem piscou (só a página piscava kk). E o roteador encolheu pra uma linha que conta tudo:

```elixir
live "/", FubaLive
```

## duas abas, duas fubás

Antes de comemorar, sobe com `mix phx.server` (o Phoenix tem task própria - e `iex -S mix phx.server` continua valendo pra quem quer o terminal junto) e faz o teste que a jhujuba fez: abre `http://localhost:4000` em **duas abas**. Dá café numa. Olha a outra.

Nada. A outra Fubá continua com cafeína em 3 - porque cada aba é uma conexão, cada conexão é um socket, e cada socket tem a **sua** coelhinha. No post 5 a Guarda era uma só e as abas dividiam a mesma Fubá. E tem mais: fecha tudo, volta amanhã, e ela tá exatamente como você deixou - cheia, feliz, sem fome nenhuma. O tempo não passa pra ela.

Isso é bug ou feature? As duas coisas, e proposital: você acabou de _sentir_ por que "uma coelhinha por conexão" não fecha a história. Pra Fubá viver sozinha - sentir fome enquanto você não tá olhando, e ser a mesma em toda aba - a gente precisa de um processo que seja _dela_, com relógio próprio e um jeito de avisar todo mundo. GenServer, timer e PubSub. Próximo post.

## fechou?

Quatro critérios:

1. `mix phx.server` sobe e `http://localhost:4000` mostra a Fubá feliz - e as três tags de script carregam (aba Network do navegador, tudo 200).
2. Clicar no ☕ café enche a cafeína **sem a página piscar** - na aba Network, nenhum documento novo, só os quadros do websocket indo e voltando.
3. Duas abas = duas Fubás com cafeínas diferentes. E você consegue explicar, em voz alta, por quê.
4. Você consegue apontar onde a coelhinha mora agora (assigns do socket), o que aposentou a Guarda, e por que o `Cuidado` não mudou uma linha.

O código completo do post tá na [main](https://github.com/zoedsoupe/fuba) do repositório - os posts anteriores têm cada um a sua branch, então dá pra comparar casquinha por casquinha.

Fechou? A página ganha vida, o botão fala pelo telefonema e o coração segue intacto. Só falta ela viver _sozinha_ - e é isso o post 💜
