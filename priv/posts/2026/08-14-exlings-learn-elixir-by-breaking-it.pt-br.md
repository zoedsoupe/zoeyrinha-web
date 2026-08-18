%{
title: "exlings: aprenda elixir quebrando ele",
description: "exlings é o rustlings do Elixir: uma série de programinhas quebrados que você conserta um por vez. Procurando gente pra testar.",
tags: ~w(elixir exlings oss aprendizado),
  bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mt2hshwybv22",
}
---

Eu mantenho um projetinho chamado
[exlings](https://github.com/zoedsoupe/exlings), e este post existe porque eu
quero que você teste ele e me conte onde dói.

A ideia é roubada, como toda ideia boa. [rustlings](https://github.com/rust-lang/rustlings)
e [ziglings](https://github.com/ratfactor/ziglings) provaram o formato: você
aprende uma linguagem consertando programinhas quebrados, um por vez, em
ordem, com o compilador de professor. Não lendo sobre a linguagem. Ler te dá
reconhecimento; os exercícios te dão memória. Só um desses dois sobrevive a
uma entrevista de emprego.

exlings é isso, pra Elixir.

## como funciona

Você clona o repo, roda `mix deps.get`, e aí:

```sh
mix exlings
```

Você recebe o primeiro exercício pendente. É um arquivo `.ex` pequeno com
alguma coisa errada: um pedaço de sintaxe faltando, um pattern que não casa,
uma cláusula de função com um buraco no meio. Você abre o arquivo, conserta,
roda `mix exlings` de novo. Verde, próximo exercício. Esse é o loop inteiro,
e o loop inteiro é o ponto.

Se não quiser ficar re-rodando o comando na mão, `mix exlings.watch` re-roda
o exercício atual toda vez que você salva. Se travar, `mix exlings.hint` te
dá uma dica, e as dicas são progressivas: a primeira cutuca o seu raciocínio,
a última praticamente escreve a resposta, e cada tentativa falha revela a
próxima automaticamente. Travar é um estado, não uma falha.
`mix exlings.list` mostra o progresso, `mix exlings.reset` apaga tudo pra
quando você quiser sofrer do começo de novo.

Não tem plugin de IDE, não tem interface web, não tem conta, não tem contador
de ofensiva. É um projeto Mix e algumas tasks. A barreira de entrada é ter
Elixir instalado.

## o que ele ensina

Os exercícios passam pela linguagem mais ou menos na ordem em que você
tropeçaria nela nos primeiros meses: valores e as estruturas de dados básicas,
depois pattern matching (incluindo o operador pin, que é onde todo mundo tem
o primeiro momento _ah, É ISSO que é Elixir_), funções e guards, o pipe,
`Enum`, recursão direito, com acumuladores e tail calls, comprehensions, e as
partes de strings e binários que surpreendem a galera, tipo charlists, pra o
susto do `~c"hello"` ser desarmado num exercício em vez de em produção. A
trilha continua crescendo na direção de processos e OTP, que é a razão de
estarmos todos aqui.

## pra quem é

Iniciantes. Gente vindo de outra linguagem que continua escrevendo Elixir com
cara da linguagem antiga e syntax highlighting pior. Gente que leu o guia
oficial duas vezes e ainda trava na frente de um arquivo vazio. Não assume
Elixir prévio, nem Erlang, nem OTP. Assume que você sabe abrir um terminal,
que eu insisto ser o único pré-requisito irredutível da profissão inteira.

E também é, discretamente, pra quem mentora: se você tá ensinando Elixir pra
alguém, entrega o repo e deixa o watcher fazer a parte tediosa do feedback
enquanto você faz a parte interessante.

## testa aí

```sh
git clone https://github.com/zoedsoupe/exlings
cd exlings
mix deps.get
mix exlings
```

E aí me conta: onde você travou, qual dica foi inútil, qual exercício tá
quebrado de um jeito que eu não planejei (afirmação ousada pra um projeto
cuja premissa inteira é quebradeira intencional, mas estamos aí). Issues e
PRs abertos, exercício é fácil de contribuir, e o formato deixa o review
rápido.

O melhor elogio que o projeto recebeu até agora foi alguém dizendo que
esqueceu que tava aprendendo. Vai quebrar alguma coisa. Depois conserta. No
fim das contas, é esse o trabalho inteiro.
