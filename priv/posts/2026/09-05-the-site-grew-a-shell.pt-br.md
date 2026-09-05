%{
title: "o site virou shell",
description: "changelog do meu cantinho: mdex no lugar do earmark, comentários do bluesky assíncronos, adeus npm e um 404 que falha como terminal de verdade.",
tags: ~w(meta elixir),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3murtwskd6o2v",
}
---

post de faxina! passei umas sessões fuçando esse site (esse aqui que você tá lendo agora) e juntou mudança suficiente pra um changelog. nada de grande reescrita, é mais jardinagem. ou, dada a estética, arrumação de home directory.

## menos dependência, mais graxa

duas trocas primeiro. saiu o earmark, entrou o [mdex](https://github.com/leandrocp/mdex) - o earmark tava com uma CVE aberta e o mdex renderiza via comrak (NIF em Rust), então os posts compilam mais rápido e a CVE foi embora junto. depois deletei o `assets/package.json` inteiro: Alpine, Lucide e o próprio npm, tudo fora. o site é um terminal com paleta [nyxvamp - meu proprio tema](https://github.com/nyxvamp-theme), nunca precisou de framework JS. os ícones viraram links de texto, a pitada de interatividade virou ~80 linhas de vanilla JS e a imagem Docker emagreceu junto.

## comentários da atmosfera, assíncronos

os comentários do Bluesky nos posts agora carregam num LiveView embutido, depois da página renderizar. antes o post inteiro esperava a API do AT Protocol responder pra servir um byte sequer - agora o post (estático, cacheado, instantâneo) chega na hora e os comentários aparecem quando aparecem. e o resto do site não paga nada por isso: o LiveSocket só conecta nas páginas que têm comentário de verdade.

## as piadas de shell

o site se veste de terminal, então agora ele age como um em alguns cantos:

- a página de CV te cumprimenta com `$ whoami` (o currículo embaixo é o stdout);
- a de talks roda `$ wall ./talks.txt` - `wall(1)`, escreve pra TODOS os usuários, que é exatamente o que uma palestra faz;
- o footer roda `$ finger zoey@bsky.app`, a rede social original, com os links como stdout;
- o índice do blog mostra o feed RSS como um comando curl, porque é assim que você consumiria ele de um terminal;
- e o 404 agora falha com honestidade:

```console
$ ls /this-page
ls: cannot access '/this-page': No such file or directory
$ cd ~
```

na parte interativa: blocos de código ganharam botão de copiar (com label localizado, claro), os cursores piscam, e se você digitar o código Konami a página glitcha por três segundos. esse último vem com trava: se o seu sistema pede movimento reduzido, a tempestade simplesmente não acontece. acessibilidade ganhou uma passada geral também - foco visível, contraste, essas coisas que não são opcionais.

## notas de ops

dois ajustes no Fly.io: cold start acabou (a máquina fica quentinha) e a memória da VM diminuiu, porque um site Phoenix quase estático não precisa daquele espaço todo.

é isso o post. o site compila mais rápido, pesa menos, carrega comentário com preguiça e falha mais poeticamente. semana que vem tem post de verdade 💜
