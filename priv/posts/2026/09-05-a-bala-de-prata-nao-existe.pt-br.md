%{
title: "a bala de prata não existe (de novo)",
description: "reflexões da SCTI UENF 2026: subir no palco pra falar de RAG enquanto eu reduzo meu próprio uso de LLM, o hype como projeto comercial, e por que arquitetura de software continua sendo o coração de qualquer sistema em produção.",
tags: ~w(elixir beam sistemas-distribuidos ia scti meta),
  bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3murx6anz272y",
}
---

semana passada foi a SCTI na UENF e, de novo, eu tava lá. deixa eu contextualizar: a comissão organizadora me convida pra palestrar e dar minicurso todo ano desde 2023. TODO ANO. num mundo onde evento tech morre depois de duas edições, ter um cantinho que me quer de volta com essa consistência é um negócio que eu não levo como garantido. então antes de qualquer coisa: obrigada, comissão 💜 vocês constroem um espaço raro.

esse ano foram duas contribuições: uma palestra sobre RAG e arquitetura, e um minicurso onde a sala inteira escreveu clientes pra uma arena de slimes lutando numa grade. os slides e os materiais tão na página de [talks](/talks), não vou repetir conteúdo aqui. o que eu quero é registrar o que ficou girando na minha cabeça depois, e parte disso é desconfortável.

## a tensão que eu carrego no palco

sendo honesta: existe uma contradição em eu subir num palco pra falar de arquitetura pra IA. eu construí duas RAGs em produção, sei como a salsicha é feita porque fiz várias, e justamente por isso eu não uso LLM no meu dia a dia. uso cada vez menos, na vdd, e de propósito. esse blog que você tá lendo é parte disso: um projeto deliberadamente devagar, escrito na mão, porque eu escrevi um [post inteiro](/blog/present-day-present-time) sobre o que a delegação constante faz com o pensamento e não pretendo virar estatística do próprio texto.

e tem a parte material, que é maior que o meu umbigo. o hype da IA não é um fenômeno espontâneo de empolgação técnica, é um projeto comercial de meia dúzia de empresas. o modelo que "resolve tudo" foi treinado em cima de décadas de trabalho coletivo e gratuito (blog, fórum, open source, wikipedia, esse post inclusive), e hoje esse trabalho mastigado é revendido por assinatura pelos donos da infraestrutura. isso não conversa com nada do que eu acredito politicamente. quando eu falo de IA em palco eu tento falar de engenharia, não de evangelho, porque o evangelho não é meu e eu não recebo pra pregar ele.

## a bala de prata da vez

em 1986 o Fred Brooks escreveu "No Silver Bullet": nenhuma tecnologia, sozinha, dá um salto de ordem de magnitude na construção de software. quarenta anos depois a gente continua testando a tese a cada ciclo. foi cloud, foi blockchain, foi microserviço, foi no-code. agora é IA, e dessa vez o marketing é mais agressivo: não é "essa ferramenta ajuda", é "não precisa mais pensar, o modelo pensa".

na prática, acontece o contrário. colocar um LLM no seu sistema é adicionar mais uma dependência distribuída que falha de formas criativas: timeout, rate limit, resposta plausível e errada, provedor fora do ar. todos os problemas clássicos de sistemas distribuídos continuam lá, intactos, e ganharam um vizinho que mente com confiança. o hype não aposentou o Brooks, deu mais trabalho pra ele.

## o que sobrou quando a ficha caiu

o minicurso foi o contraponto involuntário disso tudo, e talvez a parte mais honesta da minha semana. o Slimes não tem LLM nenhum: é um servidor, um protocolo, uma grade e um monte de cliente escrito por gente que tava vendo aquilo pela primeira vez. e o que a sala precisou aprender pra sobreviver foi o repertório mais velho da computação distribuída: retry, idempotência, ack e nack, servidor como autoridade, função pura no núcleo e efeito na borda. nada disso apareceu num keynote de big tech esse ano. tudo disso vai estar funcionando quando o keynote da próxima bala de prata sair.

eu queria terminar esse parágrafo dizendo que isso me deixa otimista, mas a palavra honesta é outra: me deixa aliviada e preocupada ao mesmo tempo. aliviada porque a galera mais nova tem fome de fundamento, dá um problema concreto (seu slime morre se seu código for burro) e a teoria desce que é uma beleza. preocupada porque essa mesma galera vai entrar num mercado que passa o dia dizendo que o pensamento deles é obsoleto e que o trabalho deles é supervisionar saída de modelo. o alívio é sobre as pessoas. a preocupação é sobre a estrutura, e a estrutura não se resolve com palestra.

## e a BEAM nisso tudo?

não vou fingir neutralidade: meu marketing disfarçado de Elixir continua de pé. supervision tree, processo isolado, let it crash. é uma máquina de rodar sistema distribuído que existe desde os anos 80, quando "distribuído" era telefonia e não microserviço em kubernetes. a ironia do ciclo atual é que a resposta pra "como sobrevivo a dependências que falham o tempo todo?" tava pronta décadas antes da pergunta virar moda.

mas a BEAM é atalho, não pré-requisito. o princípio é mais velho que ela e mais largo que qualquer stack: desenhe fronteiras onde as coisas podem falhar, porque elas vão. arquitetura não é burocracia de gente velha, é o que separa sistema de demo. sempre foi. continua sendo, com ou sem LLM dentro.

## sem laço bonito

não tenho conclusão otimista pra oferecer, e acho que conclusão otimista seria desonesta. o hype não vai morrer porque tem gente lucrando com ele, e eu não vou resolver isso num post. o que eu posso fazer é o que tentei fazer em Campos: falar de fronteira, de falha, de núcleo puro, das coisas que continuam valendo independente da manchete da semana. e manter a minha prática coerente com o que eu falo, que é a parte mais difícil.

se o padrão se mantém, nos vemos na SCTI 2027. vou continuar voltando enquanto me quiserem lá, e pelo visto vão ter que me aturar mais um tanto.

abraço na comissão, abraço na galera que codeou slime comigo, e lembra: não existe bala de prata, existe fronteira bem desenhada 💜
