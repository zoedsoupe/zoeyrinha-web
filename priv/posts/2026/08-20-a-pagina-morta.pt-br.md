%{
title: "a página morta",
description: "post 4 da série fuba web: a telinha bonita, finalmente. arquivos estáticos, plug.static e a descoberta de que botão bonito não faz nada sozinho.",
tags: ~w(elixir web tutorial),
series: "fuba-web",
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mtu4blbxel2k",
}
---

A Fubá [já tem voz](https://zoedsoupe.zeetech.io/posts/http-na-unha): o servidor responde, o `curl` conversa com ela. Só que uma frase em texto puro não é telinha bonita, e telinha bonita era o pedido original, né. Então hoje é dia! A jhujuba, que de telinha entende, pode me julgar - e a pergunta que consigo imaginar é: "fiz os botões... por que eles não fazem nada?". Junto do "pô, sem querer dar pitaco, mas deixa X desse jeito aqui..."

## a telinha

Primeiro, a telinha. Cria a pasta `priv/static/` e salva esse HTML+CSS no arquivo `index.html`:

```html
<!-- priv/static/index.html -->
<body>
  <main>
    <p class="carinha">( ￣^￣)</p>
    <h1>Fubá</h1>
    <p class="humor">tá chatinha… cadê o café?</p>

    <div class="medidores">
      <div class="medidor">
        <span>biscoito</span><span class="barra">■■■□□</span>
      </div>
      <div class="medidor">
        <span>cafeína</span><span class="barra baixa">■□□□□</span>
      </div>
      <div class="medidor">
        <span>carinho</span><span class="barra">■■□□□</span>
      </div>
      <div class="medidor">
        <span>energia</span><span class="barra">■■■■■</span>
      </div>
    </div>

    <div class="acoes">
      <button>🍪 biscoito</button>
      <button>☕ café</button>
      <button>🫶 cafuné</button>
      <button>🍃 espaço</button>
    </div>
  </main>
</body>
```

Isso é só o `body` - o arquivo completo tem um `<style>` em cima com as cores e o desenho do cartão, e tá no [repositório](https://github.com/zoedsoupe/fuba/blob/post-4/priv/static/index.html) pra você copiar inteiro. Ou melhor: faz a sua. As cores, a fonte, as carinhas... a Fubá é minha, a página é sua.

Duas coisinhas pra reparar já nesse HTML. A carinha é `( ￣^￣)` - chatinha - e a cafeína tá em um quadradinho só. Não porque a Fubá esteja assim: porque alguém **escreveu isso no HTML**, à mão, fixo. E os quatro botões são só `<button>`: desenho de botão, que não fazem nada. Lembra disso.

## o que é um arquivo estático

Até aqui, a resposta do servidor era uma frase digitada dentro do código Elixir. Uma página web é diferente: é um arquivo de verdade, guardado em no computador que o servidor tá rodando, e que é lido e devolvido do jeito que está, sem mexer em nada. Por isso o nome: **estático**. O mesmo arquivo, igualzinho, pra todo mundo que pedir, hoje e amanhã.

E o navegador? Lá no post passado ele era "um cliente HTTP que sabe desenhar". Pois bem, é aqui que ele desenha: pede a página, recebe texto HTML no corpo da resposta, e transforma aquele texto no cartãozinho roxo com botões. O servidor não desenha nada - ele só entrega o papel.

A pasta `priv/` é o endereço oficial dessas coisas em projeto Elixir: arquivos que não são código mas viajam junto com a aplicação. Página, imagem, fonte - mora tudo em `priv`.

## encadeando plugs

Como o nosso Plug aprende a deolver arquivo? Não aprende - a gente contrata um coleguinha pra ele. O novo `lib/fuba_web/plug.ex`:

```elixir
defmodule FubaWeb.Plug do
  use Plug.Builder

  plug Plug.Static, at: "/", from: :fuba

  plug :nao_achei

  def nao_achei(conn, _opts) do
    send_resp(conn, 404, "nada aqui, uai")
  end
end
```

Mudou tudo, então devagar. O `use Plug.Builder` transforma o módulo numa **esteira de plugs**: cada linha `plug` é uma estação, e a requisição passa por elas de cima pra baixo (que nem o casamento de padrão em funções com múltiplas cláusulas). A `conn` entra na primeira estação, que pode responder na hora (e a esteira para ali) ou passar adiante pra próxima. Sabe o `init/1` e o `call/2` que a gente escreveu na mão no post passado? O `Plug.Builder` escreve eles pra gente, com essa esteira dentro.

A primeira parada é o `Plug.Static`, um plug pronto da biblioteca: ele procura o caminho pedido entre os arquivos estáticos. O `at: "/"` diz "atende pedidos a partir daqui, da `/`", e o `from: :fuba` diz "procura na pasta `priv/static` da aplicação `:fuba`". Pediu `/index.html`? Ele acha o arquivo, lê do disco e responde com `200`. Não achou? Ele não inventa nada não - só deixa a requisição seguir viagem.

E aí entra a segunda parada: `nao_achei`, uma função nossa. Se a requisição chegou até ela, é porque nenhum arquivo existia, então ela responde `404` com um "nada aqui, uai". Repara nos dois jeitos de plugar: `Plug.Static` é um **módulo** plugado (tem `init/1` e `call/2` lá dentro, tipo o nosso Plug do post passado), e `:nao_achei` é uma **função** plugada, pra quando for algo simples.

## vendo a página

Sobe o servidor (`iex -S mix`) e abre o navegador em `http://localhost:4000/index.html`.

A Fubá na tela. Roxa, com carinha de poucos amigos, quatro medidores, quatro botões. A telinha bonita existe!

Agora clica no botão de café. Vai, eu espero.

...

Nada. Clica de novo. Nada.

Minha nossa, que botão ingrato.

## por que o botão não faz nada?

São três respostas, porque são três motivos diferentes:

1. **O botão é só um desenho.** Um `<button>` sozinho não faz nada. Nada no HTML diz "quando clicarem aqui, avisa o servidor". Ele é uma maçaneta pintada na parede.

2. **A página é uma foto, não a coelhinha.** A carinha chatinha, a cafeína baixa - tá tudo escrito à mão no arquivo. A Fubá de verdade, aquela struct viva do post 2, continua existindo só no `iex`. O servidor nem sabe que ela existe: nenhuma linha do `FubaWeb` importa o `Fuba.Cuidado`.

3. **O servidor entrega sempre o mesmo papel.** Cada pedido recebe o arquivo idêntico. Mesmo que a coelhinha mudasse, a página não mudaria junto - ela nasceu pronta e morre igual.

Ou seja: a página está **morta**. Bonita, servida de verdade pela internet, e completamente desligada da coelhinha. E cada um desses três motivos vai virar um post futuro.

## fechou?

Três critérios:

1. `http://localhost:4000/index.html` abre a página no navegador, com os quatro botões.
2. `curl -i localhost:4000/index.html` mostra o `200 OK` e o HTML no corpo.
3. Qualquer caminho que não existe - `curl localhost:4000/banana` - responde `404` com o "nada aqui, uai".

E o bônus pra pensar antes do próximo post: se a página mostrasse a Fubá **de verdade**, com os medidores dela agora, o que precisaria acontecer entre o pedido chegar e o HTML sair?

Fechou? No próximo post a foto vira retrato vivo: o HTML deixa de ser arquivo parado e vira uma função do estado da coelhinha - é o tal do template (HTML dinâmico).

é isso o post 💜
