%{
title: "o quintal tá aberto",
description: "apresentando o quintal: uma plataforma coletiva de blogs sobre atproto, sem algoritmo, sem métricas e com um axolote de mascote. a internet pequena que eu sempre quis morar.",
tags: ~w(elixir atproto oss),
}
---

Tenho uma confissão pra fazer antes de apresentar o projeto: passei anos dizendo que nunca ia construir rede social. Toda vez que o assunto aparecia, eu pensava no pacote completo: feed que ranqueia, número de seguidores, caixinha de engajamento batendo na porta. Só de pensar, já cansava. Mas um dia prestei atenção no que eu sentia falta da internet, e não era nada desse pacote - era o outro tanto, o que existia antes dele: livro de visitas, lista de "quem eu leio", o site esquisito de alguém encontrado por acaso às duas da manhã.

Pois bem: construí exatamente aquilo. Chama [quintal](https://quintal.blog.br), sempre minúsculo, e tá no ar em alpha: [quintal.blog.br](https://quintal.blog.br).

> "isso aqui é o meu lugar na internet, e essas são as pessoas que eu escolhi
> dividir ele comigo."

Essa frase mora no README do projeto e é o resumo mais honesto que consigo fazer. O quintal não é uma rede social, apesar de parecer uma à primeira vista. É uma vizinhança: cada pessoa tem seu canto, escreve suas prosas, recebe recados e escolhe quem quer ler. Público por padrão, seu por princípio. Lar como verbo, não como substantivo: um lugar que se mantém, se arruma, se compartilha, recebe visitas.

## as palavras do lugar

O quintal tem vocabulário próprio, porque nomear as coisas com carinho faz parte do projeto:

- **canto** - sua home pessoal: perfil, prosas, recados, links;
- **prosa** - a unidade de escrita, vale nota de duas linhas e ensaio longo;
- **recado** - entrada no livro de visitas de um canto;
- **depoimento** - testemunho público sobre uma pessoa, que só aparece depois
  dela aceitar;
- **cumadi** - um canto que você lê e recomenda, o "quem eu leio" do quintal;
- **passear** - descobrir cantos novos por acaso, um de cada vez, com o
  mascote de guia;
- **visitas** - notificações quietas: quem passou pelo seu canto desde sua
  última visita.

Se você é brasileiro, duas dessas palavras devem ter dado déjà vu agora.
_Recado_ e _depoimento_ vieram direto do Orkut, de propósito: aquele era o
último lugar grande da internet onde a gentileza tinha vocabulário próprio. A
diferença é que aqui depoimento é carta de amor com controle de entrega: quem
recebe decide se abre o envelope na sala.

E o mascote? É o **axô**, um axolote rosa:

![o axô dando oi](https://quintal.blog.br/images/axo-front-gretting.png)

Axolotes regeneram partes inteiras do corpo, e aqui seus dados também - mas
isso é assunto do próximo parágrafo (segura).

## seus dados moram no seu pds

A decisão técnica que sustenta todas as outras: o quintal roda sobre o
[atproto](https://atproto.com/guides/overview), o protocolo aberto do Bluesky.
E ele é um appview, não um host. Traduzindo: o quintal não guarda suas prosas.
Cada prosa, cada recado, cada configuração do seu canto é um record no seu
próprio repositório, no seu PDS (personal data server). O quintal indexa esses
records pra encontrar eles rápido, monta a interface em cima, e escreve de
volta no seu repo via OAuth - sem nunca pedir sua senha, e com credencial de
escopo limitado às coleções `place.quintal.*`. Dos seus outros records, tipo
os do Bluesky, ele nunca recebe acesso.

As consequências são as melhores parte. Quer sair? Leva tudo: é apontar outro
appview pro mesmo PDS. Voltou? Nada se perdeu. O quintal pode sumir amanhã
(sou uma pessoa mantendo um projeto de código aberto, não uma empresa) e suas
palavras continuam suas, prontas pra qualquer outra interface ler, porque os
lexicons são públicos. Saída livre vem do protocolo, não de promessa minha!

Daí o axolote: regenera o membro, regenera os dados. E o trocadilho axô/achou
vira mecânica - é ele quem te leva pra passear pela vizinhança e te apresenta
cantos novos.

![o axô nadando no loading](https://quintal.blog.br/images/axo-swimming.png)

Pro pessoal de Elixir que me lê pelos posts de Elixir: o quintal é Phoenix +
LiveView com SSR, um consumidor do firehose indexando tudo no Postgres, Oban
pros jobs, Finch pro HTTP, Nix flake no dev, Fly.io na produção, AGPL no
LICENSE. E é também o maior dogfood do
[proto_rune](https://github.com/zoedsoupe/proto_rune), meu SDK de AT Protocol -
firehose, OAuth, XRPC, tudo passando por ele. Porque nada testa um SDK como um
produto de verdade em cima dele pedindo feature, né.

## a constituição

Algumas decisões do quintal não estão em negociação, e acho honesto dizer
logo:

1. **Cronológico pra sempre.** Não existe função de ranqueamento e nunca vai
   existir. Não é feature faltando, é constituição.
2. **Zero métrica de popularidade.** Sem contador de seguidores, sem like, sem
   número público de nada. Se você escreve bem, ninguém vê um número dizendo -
   as pessoas chegam, deixam recado e voltam. Feedback aqui tem corpo e nome.
3. **Escrita humana.** Um compromisso assinado, um selo - não um detector.
   Manifesto, não policiamento.
4. **Simples e rápido acima de tudo.** Performance é feature. A página de
   leitura é o produto.
5. **PT-BR primeiro.** Internacional por arquitetura (toda string passa por
   gettext desde a linha 1), brasileiro por alma.

E a entrada é por convite. O quintal é pequeno de propósito, e eu gosto dele
assim.

## as regrinhas de convivência

Tem uma [página de conduta](https://quintal.blog.br/conduta) inteira sobre
isso, escrita em primeira pessoa de propósito: o quintal é um projeto meu,
dividido com amigues e afetos, então as regras falam "eu" e não "a equipe". E
a parte que não fica subentendida, deixo subentendida zero: isso aqui é um
espaço coletivo e comunitário, e transfobia não cabe nele. Nem em prosa, nem
em recado, nem em depoimento, nem "só perguntando". Escrevi essa parte com o
coração na mão porque ela é sobre mim e sobre muita gente que eu amo: o
quintal existe também pra que gente trans, travesti e não-binária tenha um
lugar comum na internet onde possa simplesmente existir e escrever.

Na moderação, por enquanto, é uma pessoa só (eu): cada denúncia é lida com
calma, por gente, sem robô e sem resposta automática. E mesmo quando um recado
é ocultado de um canto, o record de quem escreveu segue intacto no próprio PDS

- as palavras pertencem a quem escreveu, sempre.

## alpha, e daí?

Status honesto: MVP em alpha. As coisas mudam, quebram, mudam de novo. Tem
muito canto mal arrumado, muito botão feio e uma lista de ideias maior que a
lista de horas livres (minha nossa). O código é aberto
([github.com/zoedsoupe/quintal](https://github.com/zoedsoupe/quintal)), as
regras do protocolo são públicas, e quem mora lá dentro já ajuda a cuidar.

Se você tem um handle atproto (Bluesky serve), já pode entrar com ele quando
chegar seu convite - ou me chama, porque convite é pra dar. Enquanto isso, o
livro de visitas tá aberto e o axô adora companhia pra passear.

O algoritmo não vai te mostrar esse post. Mas olha só: o axô achou. E é isso
o post 💜
