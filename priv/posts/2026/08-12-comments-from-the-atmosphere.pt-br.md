%{
title: "comentários da atmosfera",
description: "Eu queria comentários neste blog sem banco de dados e sem fila de moderação. Acabei fazendo com threads do Bluesky através do proto_rune, meu próprio SDK de AT Protocol, e achei três bugs nele no caminho.",
tags: ~w(elixir bluesky oss),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3msvafroz5e2o",
}
---

Eu queria comentários neste blog. As opções eram todas ruins de jeitos
conhecidos. Disqus é uma rede de anúncios que por acaso renderiza uma caixinha
de comentário. giscus é legal, mas tranca minhas leitoras atrás de uma conta
do GitHub. E hospedar meus próprios comentários significa banco de dados,
filtro de spam e fila de moderação, que é um Tamagotchi: você não é dona,
você é quem alimenta, pra sempre, e se esquecer por uma semana ou algo morre
ou algo choca.

Aí eu lembrei que mantenho o [proto_rune](https://github.com/zoedsoupe/proto_rune),
um SDK de AT Protocol pra Elixir, e a resposta ficou óbvia. Uma thread do
Bluesky já _é_ uma seção de comentários. Contas, spam, bloqueio, delete:
problema da rede, não meu. Eu posto sobre o artigo, as pessoas respondem lá,
o blog renderiza as respostas aqui. Sem banco, sem volume no Fly, sem UI de
moderação que eu nunca ia construir.

Então é isso que o site faz agora, e o resto deste post é sobre o que
aconteceu quando eu sentei pra usar a minha própria biblioteca como usuária
em vez de autora. Spoiler: rendeu três bugs, todos reportados contra mim
mesma, todos corrigidos na mesma semana.

## proto_rune, rapidinho

proto_rune é meu SDK de AT Protocol pra Elixir. Três camadas: um transporte
que fala XRPC (o dialeto HTTP do protocolo), uma DSL que transforma os
lexicons oficiais em funções Elixir comuns, e uma API amigável em cima pras
coisas que você realmente faz, tipo postar, curtir e buscar threads. As
sessões se renovam sozinhas, tem um framework de bots com polling e um cliente
de firehose pro stream em tempo real. Está no [Hex](https://hex.pm/packages/proto_rune).

A peça que eu precisava pros comentários é uma chamada só, sem autenticação:
`app.bsky.feed.getPostThread`, apontada pro AppView público. Dá o URI de um
post, recebe a árvore de respostas inteira. O blog guarda o URI da thread no
frontmatter do post, uma task `mix blog.announce` publica o anúncio e escreve
o URI de volta no markdown, e a página busca e cacheia as respostas na hora
de renderizar. Elegante, modestia à parte, e umas duzentas linhas contando
o cache.

E aí eu rodei.

## comendo a própria comida

Escrever uma biblioteca é escrever um cardápio. Você descreve os pratos,
prova o molho uma vez, imagina o salão cheio. Usar a própria biblioteca pra
construir algo de verdade é sentar no restaurante e fazer um pedido. A
primeira coisa que eu aprendi, como cliente da minha própria cozinha, é que o
fogão não acendia.

**Bug um: ninguém conseguia fazer uma única requisição.** Toda chamada
explodia dentro de `:ssl.connect` antes de um byte sair da BEAM. O adaptador
HTTP passava o timeout de conexão pra camada de baixo incondicionalmente, e
quando quem chama não tem opinião sobre timeout, essa opinião chegava como
`nil`, e o módulo SSL do Erlang não tem cláusula pra "sem opinião". A suíte
de testes estava verde, claro. O adaptador é a casca mais externa, a parte
que os testes substituem. É exatamente o tipo de bug que só existe na
fronteira, o que é poético, e guarda esse pensamento.

**Bug dois: uma placa só pra cidade inteira.** O SDK lia a URL base do
ambiente da aplicação, uma chave global pra toda requisição. Só que leitura
anônima mora no `public.api.bsky.app` e login mora no seu PDS, e uma placa
global só aponta pra um lado. No momento em que eu configurei pra ler
threads, o login quebrou. A correção foi derrubar a placa: agora cada
chamada carrega as próprias direções, e a sessão lembra a qual servidor ela
pertence. Configuração global mutável atacando de novo, e fui eu que
escrevi!

**Bug três, meu favorito: placas tectônicas.** O `Bsky.post` da camada alta e
o schema do `Repo.create_record` da camada baixa tinham se afastado como
continentes. Cada um parecia certo no próprio mapa. Mas um passava o nome da
collection como string completa enquanto o outro esperava átomo, o schema do
record queria um `NaiveDateTime` quando o formato do fio é string ISO, e o
construtor de rich text emitia chaves camelCase onde o schema esperava
snake_case. Onde as placas se encontravam, os function clause errors eram os
terremotos. E o tremor mais sutil: a minha própria biblioteca de validação,
a [peri](https://github.com/zoedsoupe/peri), descarta silenciosamente
qualquer chave que o schema não declara, o que significava que os `"$type"`
estavam evaporando dos records no caminho até o fio. Um segurança de porta
tão dedicado que tava barrando até o convite dos convidados.

Dois posts atrás eu escrevi cinquenta parágrafos sobre fazer parsing na
fronteira. A minha fronteira tava fazendo parsing errado. Eu escolho achar
graça!

## a correção, sem a carnificina

Não vou detalhar os patches, porque as correções foram menores que o
diagnóstico, como quase sempre. Um check de nil. Uma opção por chamada em vez
de config de aplicação. Alinhar os schemas com o que o fio realmente carrega,
que, sim, é parse-don't-validate aplicado no meu próprio código, obrigada,
eu ouvi a plateia lá do fundo. Os testes de regressão agora dirigem a
postagem de ponta a ponta através de um adaptador HTTP falso e conferem o
corpo JSON literal que sairia do processo, então a deriva não volta a crescer
de fininho.

Foi tudo pro ar: [0.3.0](https://github.com/zoedsoupe/proto_rune/releases)
com as correções de transporte e config, e o alinhamento dos schemas logo
depois. Os bugs que eu não corrigi viraram
[issues](https://github.com/zoedsoupe/proto_rune/issues/51)
[honestas](https://github.com/zoedsoupe/proto_rune/issues/52) em vez de
surpresas. `Bsky.follow` e `Bsky.block` ainda estão errados de um jeito que
pede uma rodada de design em vez de remendo, e agora o tracker conta isso.

## o ponto

Todo mundo diz pra provar da própria comida, e o conselho costuma ser sobre
qualidade num sentido abstrato. O que eu não esperava era _onde_ os bugs
estavam escondidos. Não nas partes espertas. As partes espertas tinham
teste. Os bugs moravam exatamente onde uma usuária nova ia trombar com eles
nos primeiros cinco minutos: a primeira requisição, o primeiro login, o
primeiro post. O capacho tava em chamas e a sala de estar, impecável.

E a seção de comentários no fim desta página é a prova de que agora funciona.
É uma thread do Bluesky usando um trench coat. Se você responder lá, responde
aqui. Seja gentil; eu consigo esconder respostas do conforto da minha própria
conta, que é exatamente a quantidade de moderação que eu tava disposta a
operar!
