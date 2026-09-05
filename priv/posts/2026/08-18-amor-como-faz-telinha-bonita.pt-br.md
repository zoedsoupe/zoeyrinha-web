%{
title: "amor, como faz telinha bonita?",
description: "post de abertura de uma série de introdução à programação web com elixir + html/css, surge enquanto ensino elixir para minha noiva (jhujubinha)",
tags: ~w(elixir web tutorial),
series: "fuba-web",
series_index: 0,
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mtu4bl4tpz2s",
}
---

Bastou essa pergunta, feita pela [jhujuba](https://jhene.zeetech.io/) numa tarde comum, e minha cabeça abriu uns mil branches de possibilidades de como responder isso. Uma porrada de conceitos e palavras chaves inundou meu pensamento numa fração de segundo: **web**, **SSR**, **HTTP**, **REST**, **API**, **phoenix**, **client/server**...

minha nossa. Como que eu explico de forma simples como servir uma página _HTML+CSS_ via Elixir pra alguém que teve contato com Elixir esses dias, via [exlings](https://zoedsoupe.zeetech.io/posts/exlings-learn-elixir-by-breaking-it), mas que já cria "telinhas bonitas" com uma facilidade absurda e que até ontem não fazia ideia de como a internet funcionava debaixo dos panos???

pois bem. Primeiro pensei: vou selecionar alguns conteúdos, artigos e vídeos sobre os assuntos, direcionando pro mundo Elixir e... ah, tem a barreira da língua também. Os conteúdos em sua maioria são em inglês e o que existe em português - considerando traduções - já pressumem um contexto de conhecimento muito amplo, ou então só introduzem tudo de uma vez só sem explicar os detalhes. Com isso tudo eu pensei:

> "Bem, a jhene sempre diz que tem sorte de aprender com alguém pela qual ela é apaixonada, e eu queria contribuir mais com conteúdo educativo e voltar a escrever com mais frequência... Que tal unir os dois?"

E se, em vez de uma pilha de links, eu escrevesse a resposta inteira? Uma série de posts que começa num arquivo vazio e termina numa aplicação web de verdade, em Elixir, em português, na ordem em que as dúvidas aparecem? Nasce assim essa série!

## a pergunta é um iceberg

"quero fazer uma coisa com elixir, mas eu preciso de uma tela bonitinha" - essa foi a mensagem. Parece pedido pequeno, né? Só que embaixo d'água: pra telinha existir, alguém precisa _servir_ o HTML (o servidor), alguém precisa _pedir_ (o navegador), e os dois conversam num _protocolo_ (o HTTP). Aí o HTML fixo vira HTML gerado a partir de um estado, o estado precisa morar em algum lugar, o clique precisa avisar o servidor, a página pisca, o estado some quando o servidor reinicia... A telinha bonita é só a pontinha do iceberg!

## o que a gente vai construir

Basicamente um tamagotchi. A **Fubá** é uma coelhinha virtual com quatro medidores (biscoito, cafeína, carinho, energia), quatro botões de cuidado e quatro humores calculados na hora. E uma regra emocional, da vida: quando ela tá desregulada, não aceita carinho, só espaço ajuda. Quem nunca?

Por que um bichinho virtual? Porque ele é pequeno o bastante pra caber numa série e real o bastante pra incomodar na hora de fazer as coisinhas: tem regra de negócio, tem estado, tem interface, tem persistência!

## o mapa

Cada post responde **uma** pergunta e constrói **uma** camada:

1. **manifesto** - este post. O quê e por quê.
2. **o coração da Fubá** - "por onde começo?" Struct, pattern matching, função pura. `mix new`, três módulos, um teste.
3. **HTTP na unha** - "o que é um servidor?" Um Plug escrito na mão, e o `curl` como voz da Fubá.
4. **a página morta** - "por que o botão não faz nada?" Arquivos estáticos. A telinha bonita, finalmente - e parada.
5. **HTML é uma função do estado** - "o que é um template?" o que diabos é SSR? EEx, e uma caixinha que guarda a coelhinha.
6. **forms, POST e a página que pisca** - "como o botão avisa o servidor?" O ciclo requisição/reposta inteiro, e a limitação dele.
7. **a página ganha vida** - "como a página atualiza sozinha?" Phoenix LiveView.
8. **ela vive sozinha** - "ela fica com fome quando eu não tô olhando?" GenServer, timer, PubSub.
9. **ela sobrevive ao restart** - "reiniciou o servidor, ela esqueceu tudo?!" Ecto + SQLite.
10. **ela sente o mundo lá fora** - "dá pra ela saber se tá chovendo?" Cliente HTTP, JSON, e a rede falhando sem derrubar ninguém.

## não que vocês apenas leiam, mas também façam

- Cada post abre com a pergunta (provavelmente que a Jhene fez) e o problema, e fecha com a solução. No meio, você tenta. Travar é o esperado, não uma falha.
- Todo post termina com um "fechou?": um critério de "aceito" no terminal ou no navegador. Nada de "parabéns, você aprendeu X". Ou você vê funcionando ou não vale, tipo isso.
- Código mínimo. O post explica, você completa.

## pré-requisitos

- **exlings feitos** (ou quase) - cada post aponta os exercícios que treinam o que ele usa;
- **HTML + CSS** - afinal, telinha bonita você já faz;
- **terminal básico** - que eu insisto ser o único pré-requisito irredutível da profissão inteira;
- **Elixir 1.18+** instalado.

Aliás, a validação deste post é uma linha:

```sh
elixir --version
```

Imprimiu 1.18 ou maior? Fechou!

## fechou?

Este post não constrói nada além de um compromisso, então o critério é: você consegue dizer o que a série vai construir (uma coelhinha virtual na web) e por que nessa ordem (cada camada resolve o problema que a anterior deixou em aberto)? Consegue? Então até o próximo!

Dito isso, antes de tela bonita, a Fubá precisa existir. No próximo post: `mix new fuba` e o coração dela, alheio à existência da internet. é isso o post 💜
