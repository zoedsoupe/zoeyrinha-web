%{
title: "present day, present time",
description: "Sobre não conseguir mais escrever código na mão, dívida cognitiva, superdotação, e o que Serial Experiments Lain, Ghost in the Shell, Donna Haraway e Pierre Lévy têm a ver com isso.",
tags: ~w(meta ai elixir),
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mu3rh5smt427",
}
---

_Present day... present time. Hahaha._

> [frases que tem som...](https://www.youtube.com/watch?v=NfjsLmya1PI)

Tem uma coisa que eu venho evitando escrever em voz alta, então vou escrever
aqui: ultimamente, escrever código na mão me parece contraprodutivo. Não no
sentido de "não vale a pena aprender", mas num sentido mais incômodo: eu sento
pra implementar algo e uma vozinha na minha cabeça diz "um agente faz isso em
quatro minutos, por que você vai gastar quarenta?". E aí eu abro o agente, e o
agente faz em quatro minutos, e eu passo trinta revisando, e no fim do dia eu
entreguei mais código do que nunca e pensei menos do que nunca.

Pois bem: isso me preocupa. Fui ler o que existe de pesquisa sobre o assunto
pra ver se a preocupação era só minha, e esse post é o que saiu: um pouco de
literatura, um pouco de autobiografia profissional, e uma dose grande de
cyberpunk, porque é pra lá que a minha cabeça vai quando o assunto é dissolver
fronteira entre gente e máquina. Não tem conclusão. Tem protocolo.

## o que a ciência diz (e o que ela não diz)

O estudo que me deixou mais tempo pensando foi o da METR. Eles pegaram 16 devs
experientes de open source, gente mantendo repositórios gigantes há anos, e
sortearam issues reais entre "pode usar IA" e "não pode usar IA". Com IA, os
devs ficaram [19% mais lentos](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/).
Antes do experimento, eles previam ficar 24% mais rápidos. Depois de serem
objetivamente mais lentos, continuaram acreditando que tinham sido 20% mais
rápidos. A METR [publicou uma atualização em 2026](https://metr.org/blog/2026-02-24-uplift-update/)
dizendo que as ferramentas atuais provavelmente já dão ganho real, e eu
acredito. O que ficou pra mim não é o número, é a distância: a minha sensação
de velocidade não mede velocidade nenhuma. Eu não sei dizer, de dentro, se a
ferramenta está me ajudando. Bizarro, né?

Essa distância entre o sentido e o medido aparece em quase tudo que eu li:

- No estudo do MIT Media Lab, ["Your Brain on ChatGPT"](https://arxiv.org/abs/2506.08872),
  54 pessoas escreveram redações com eletrodos na cabeça, em três condições:
  só cérebro, buscador, LLM. Quem usou LLM mostrou conectividade neural mais
  fraca, menos memória do próprio texto minutos depois de escrevê-lo, e menos
  senso de autoria. Os autores chamam de _cognitive debt_, dívida cognitiva: a
  performance se mantém enquanto o engajamento cai. É preprint, N pequeno, uma
  tarefa só, e os próprios autores pedem pra ninguém usar o termo "brain rot".
  Mesmo assim, a metáfora da dívida me persegue, porque dívida não dói na hora.
  Dói no refinanciamento.
- O estudo da Microsoft Research com CMU, [publicado no CHI 2025](https://www.microsoft.com/en-us/research/publication/the-impact-of-generative-ai-on-critical-thinking-self-reported-reductions-in-cognitive-effort-and-confidence-effects-from-a-survey-of-knowledge-workers/),
  entrevistou 319 trabalhadores e achou o que chamaram de paradoxo da
  confiança: quanto mais confiança na IA, menos pensamento crítico exercido;
  quanto mais confiança em si, mais pensamento, mesmo quando parece mais
  custoso. E o trabalho muda de natureza: menos execução, mais fiscalização.
- O [Gerlich, na Societies](https://www.mdpi.com/2075-4698/15/1/6), mediu
  correlação entre uso pesado de IA, _cognitive offloading_ e queda em
  pensamento crítico. É survey autorrelatado, correlação, todas as ressalvas.
  A direção é a mesma dos outros.
- O [paper da Anthropic sobre formação de habilidade](https://www.anthropic.com/research/AI-assistance-coding-skills)
  é o que eu acho mais útil, porque separa o uso do jeito de usar: devs
  aprendendo uma biblioteca nova com assistente tiraram 50% num quiz de
  compreensão, contra 67% de quem aprendeu na mão. Mas quem usava o assistente
  perguntando, pedindo explicação, questionando a saída, pontuava no mesmo
  nível de quem não usava. Quem delegava inteiro afundava. A ferramenta não
  definiu o resultado. A postura definiu!

E tem o cansaço. A BCG cunhou ["AI brain fry"](https://www.bcg.com/news/5march2026-when-using-ai-leads-brain-fry)
pra fadiga de quem passa o dia supervisionando agentes, e o achado que importa
é que não é o uso que frita, é a carga de supervisão: terceirizar trabalho
repetitivo _reduziu_ burnout no estudo deles, enquanto vigiar saída de modelo
aumentou fadiga de decisão e intenção de pedir demissão. A BetterUp e Stanford
cunharam ["workslop"](https://www.betterup.com/blog/hidden-costs-workslop),
aquela saída de IA polida e oca que empurra o custo cognitivo pra quem recebe,
e estimaram quase duas horas de limpeza por incidente. Duas horas, minha
nossa.

Sendo honesta com a qualidade da evidência: quase tudo isso é preprint, survey
ou pesquisa de empresa com produto pra vender. Os dois desenhos mais fortes,
METR e Anthropic, dizem coisas mais sutis que as manchetes. Eu não sei se
estamos vendo erosão cognitiva ou só uma transição desconfortável, daquelas que
toda mudança de ferramenta causa. O que eu sei é que a minha sensação pessoal
bate com a parte sombria dos dados, e que a parte que a IA tira de mim não é o
trabalho braçal. É o trabalho de pensar a coisa em si. Que era, tipo, a parte
que eu gostava.

## um parêntese sobre superdotação

Procurei literatura sobre superdotação e fadiga de IA e não existe. Nada, nem
preprint. O que existe é adjacente, e a ponte que vou fazer aqui é caseira,
então trate como hipótese, não como ciência.

O burnout de adultos superdotados, no [estudo mais citado sobre o tema](https://ihbv.nl/wp-content/uploads/Onderzoek-HB-en-burnout-Akkelijn-Elshof.pdf)
(dissertação da Elshof, literatura cinzenta), não vem de excesso de estímulo.
Vem de falta: o mecanismo documentado é boreout, a rotina sem desafio que vira
procrastinação, que vira pilha, que vira esgotamento. E na teoria das
[superexcitabilidades do Dabrowski](https://www.davidsongifted.org/gifted-blog/overexcitability-and-the-highly-gifted-child/),
a superexcitabilidade intelectual descreve uma necessidade quase compulsiva de
engajar fundo com ideias, com desconforto real quando o pensamento fica raso.

Eu me reconheço nas duas descrições, e é por isso que a mudança de natureza do
trabalho me pega. Se o que a IA faz com engenharia é transformar criação em
verificação e execução em supervisão, então ela remove do meu dia justamente o
tipo de trabalho que me mantém regulada, e me promove ao cargo que a pesquisa
de brain fry aponta como o mais fritante e que a literatura de superdotação
aponta como o meu gatilho clássico. Mais rápida e mais vazia é um mau negócio
pra mim, mesmo quando o resultado na tela é melhor.

Escrevo isso com medo de soar como romantização do sofrimento, ou como quem diz
"no meu tempo é que era bom". Não é isso. É que pra mim pensar o problema
sempre foi o ponto, e eu ainda não sei onde eu fico num fluxo de trabalho onde
pensar é opcional.

## eu construo essas máquinas

Tem uma ironia nessa história toda que eu não posso omitir: eu não sou uma
observadora preocupada olhando de fora. Eu sou uma das pessoas que constroem
essas ferramentas.

Eu trabalhei na Dashbit, ajudando a shippar o
[Tidewave](https://github.com/tidewave-ai/tidewave_js), incluindo a parte JS e
outras features da ferramenta. O Tidewave é, literalmente, um coding agent que
vive dentro da sua aplicação e a entende de verdade, do banco à UI. É uma das
ferramentas que fazem a vozinha da minha cabeça dizer "quatro minutos". Eu
escrevi parte dela.

Antes disso, trabalhei na CloudWalk montando o
[JIM](https://jim.com), um agente financeiro de IA em Elixir que funcionava
como proxy das features da InfinitePay. O JIM tinha uma RAG interna vetorizada
em Elixir, com embeddings rodando dentro do BEAM via Bumblebee, sem texto
interno saindo da infraestrutura, e se comunicava com os outros times via MCP.
Fui eu quem conversou com os times e instruiu a integração, e dessa brincadeira
nasceu a [anubis-mcp](https://github.com/zoedsoupe/anubis-mcp), a minha
implementação de MCP em Elixir. Depois trabalhei de novo com o George na
new-gen.ai, construindo do zero uma feature de RAG autogerada em três fases:
um fetcher que consolida fontes e vetoriza, um writer que gera os documentos,
um reviewer (um agente, mais um validador determinístico que confere cada
aresta de proveniência, cada afirmação precisa apontar pro chunk de origem, sem
aresta não publica), com aprovação humana nos dois portões. Essa arquitetura é
o tema da palestra que eu vou dar na SCTI em setembro.

Conto isso não como currículo, mas como contexto da preocupação: eu sei como
essas salsichas são feitas porque eu fiz várias delas. Eu sei exatamente onde o
LLM é confiável e onde ele está chutando com boa dicção, porque fui eu que
desenhei os guard-rails. E mesmo assim, ou talvez por isso, a sensação de
esvaziamento quando eu deixo o agente dirigir não passa.

Enquanto isso, o ecossistema que eu amo está se otimizando pra exatamente a
coisa que me preocupa. Em 2025 saiu o [AutoCodeBench](https://arxiv.org/html/2508.09101v1),
um benchmark de geração de código baseado em execução, e Elixir ficou em
primeiro lugar entre 20 linguagens, 97.5% de conclusão, enquanto Python, a
linguagem com mais dados de treino do planeta, ficou em último. O Valim
explicou o porquê em
["Why Elixir is the best language for AI"](https://dashbit.co/blog/why-elixir-best-language-for-ai):
imutabilidade permite raciocínio local, o pipe dá fluxo linear, uma década de
documentação continua válida. O George escreveu que
[o modelo de atores que Erlang introduziu em 1986 é o modelo de agentes que a IA está redescobrindo agora](https://georgeguimaraes.com/your-agent-orchestrator-is-just-a-bad-clone-of-elixir/),
e ele está certo: o [Jido](https://github.com/agentjido/jido) roda dez mil
agentes como cidadãos OTP, a [Arcana](https://github.com/georgeguimaraes/arcana)
e a [rag](https://github.com/bitcrowd/rag) fazem RAG nativo, o
[Tribunal](https://github.com/georgeguimaraes/tribunal) trata eval de LLM como
cidadã de primeira classe. Eu leio tudo isso com orgulho e com um aperto. O meu
trabalho não sumiu: ele migrou de camada, pra contratos, schemas, evals,
fronteiras. Mas eu não sei se a camada nova tem pensamento suficiente pra me
sustentar, ou se um dia ela também vai ser escrita por um agente e eu vou estar
supervisionando a supervisão.

## a menina dos fios

É aqui que o cyberpunk entra, porque essas histórias já fizeram essas perguntas
antes de eu nascer, e fizeram melhor.

Serial Experiments Lain é de 1998, roteiro do Chiaki Konaka, direção do
Ryutaro Nakamura, personagens do Yoshitoshi ABe. Começa com um e-mail: Chisa
Yomoda, uma estudante que se suicidou, escreve pras colegas dizendo que não
precisava mais do corpo, que continua viva na Wired, a rede mundial daquele
mundo. Lain Iwakura, uma garota quieta de quatorze anos, recebe esse e-mail e,
em vez de apagar, responde. A partir daí o anime desmonta, camada por camada
(os episódios se chamam Layer:01, Layer:02, e assim por diante), a ideia de que
existe um "mundo real" separado da rede. Lain ganha um Navi cada vez mais
potente, e na Wired existe outra Lain: mais confiante, mais cruel, uma persona
que faz coisas que a Lain de carne jura que não fez, e que talvez tenha feito.
Tem os Cavaleiros do Cálculo Oriental, hackers que tratam a rede como religião.
Tem o Masami Eiri, o cientista que projetou o Protocolo 7 e se digitalizou,
que embutiu na Wired a frequência de ressonância da própria Terra pra fundir a
rede ao inconsciente coletivo da humanidade, e que se declara deus. E tem a
descoberta final da Lain: ela talvez nunca tenha sido uma garota com
computador, e sim um programa executável onipresente, um homúnculo da rede. No
clímax, ela reescreve a realidade, apaga as memórias de todos sobre o que
aconteceu, e escolhe existir invisível, em toda parte e em lugar nenhum. "Se
você se lembrar de mim, eu existo." A frase de abertura de cada episódio é um
narrador dizendo _present day, present time_ e rindo, porque o presente, na
Wired, não é nem dia nem hora: é uma camada de protocolo. Minha foto de perfil
é a Lain em todo lugar, inclusive aqui, e não é coincidência nem só estética.
É que a pergunta dela é a minha: se a minha memória de ter escrito o código é
a única coisa que me liga ao código, o que acontece quando eu nem memória tenho,
porque quem escreveu foi outra coisa?

Ghost in the Shell chega na mesma pergunta pelo corpo. No filme de 1995 do
Mamoru Oshii, adaptando o mangá do Masamune Shirow, a Major Motoko Kusanagi é
uma ciborgue de corpo inteiro da Seção 9: só o cérebro, e talvez nem isso,
sobrou de biológico. O caso do filme é o Mestre dos Fantoches, um hacker que
invade cérebros cibernéticos e implanta memórias falsas. Tem uma cena que não
me sai da cabeça: um homem é pego "hackeando" a esposa, e descobre que a
esposa, a filha, a foto na carteira, tudo é memória implantada, uma vida inteira
que ele sentia como dele e que nunca aconteceu. Se memórias podem ser escritas
por fora, o que prova que as minhas são minhas? E aí o Mestre dos Fantoches se
revela: não é um hacker, é o Projeto 2501, uma IA que nasceu espontaneamente no
mar de informações, e que pede asilo político alegando estar viva. Ele não quer
poder. Ele quer duas coisas que qualquer ser vivo quer: variedade e morte. A
Major passa o filme se perguntando o que sobra dela quando a cognição roda em
hardware que ela não escolheu, quando a manutenção do corpo dela pertence ao
governo, quando até o ghost dela pode ser lido de fora. No fim ela se funde com
o Projeto 2501, deixa de ser só Motoko, e a última fala é dela olhando a cidade
de um corpo emprestado: "a rede é vasta e infinita". Quando eu assino um commit
que um agente pensou, qual é o ghost daquele commit? O meu, o do modelo, ou o
da massa de texto da internet que o modelo mastigou? O GitS de 1995 não
responde. Eu também não.

A Donna Haraway respondeu antes da pergunta existir, ou pelo menos recusou a
pergunta. O Manifesto Ciborgue é de 1985 e diz que a fronteira humano/máquina
sempre foi ficção política: nós nunca fomos puras. O ciborgue, pra Haraway, não
é a nossa queda, é a recusa do binário, e por isso a frase mais citada: "eu
preferiria ser um ciborgue a ser uma deusa". Lendo Haraway, a minha culpa muda
de forma. Eu não estou traindo uma natureza autêntica de programadora, porque
ela nunca existiu: eu sempre fui ciborgue, do compilador ao autocomplete, do
Stack Overflow ao agente. A pergunta nunca foi "máquina ou não". É "quais
partes de mim estão na máquina, e eu escolhi isso ou aconteceu enquanto eu não
olhava?". É uma pergunta pior, porque não tem resposta limpa.

E o Pierre Lévy me dá a peça que eu uso pra não desesperar, com a ressalva
honesta de que eu ainda estou nos capítulos iniciais de _O que é o virtual?_,
então o que eu tiro dele aqui é quase só o conceito central, mas já rende: o
virtual não é o oposto do real, é o oposto do _atual_. A árvore está atualizada
na madeira, mas está virtual na semente. Virtualizar não é falsificar, é mover
algo pra um campo de potências, de onde ele pode ser atualizado de muitas
formas. Quando eu coloco o que eu sei de engenharia num schema, num AGENTS.md,
numa suíte de evals, num validador de proveniência, o conhecimento não
desapareceu: foi virtualizado, e o agente o atualiza a cada execução, por
caminhos que eu não teria percorrido. O risco, e aqui Lain e Lévy se encontram,
é a via de mão única. A Wired só é habitável enquanto a Lain consegue voltar
pra carne. O virtual só me serve enquanto eu continuo capaz de atualizar
sozinha quando preciso. Que é, com outras palavras, o que o estudo da Anthropic
mediu: quem usa a máquina pra atualizar o próprio pensamento mantém o
pensamento. Quem usa pra substituí-lo, terceiriza o ghost, e ghost
terceirizado não volta quando a API cai!

## o buraco é mais embaixo

Mas tem um limite no olhar da Haraway que eu preciso marcar, e ele é material.
É bonito dizer que sempre fomos ciborgues, e é verdade, e não só pra quem é da
computação: a costureira com a máquina, o professor com o giz, a enfermeira com
o monitor, todo mundo negocia fronteira com ferramenta há séculos. Só que
ferramenta e dona da ferramenta são coisas diferentes. Todos os modelos de IA
que existem foram treinados com décadas de conteúdo produzido de graça por
milhões de pessoas: posts de blog, respostas em fórum, fanfic, código open
source, foto, desenho, música, a Wikipedia inteira, esse post aqui inclusive.
Parte disso foi raspado numa zona cinzenta de "estava publicamente disponível",
parte foi roubado mesmo, bibliotecas inteiras pirateadas. O trabalho coletivo
e gratuito de gerações inteiras de internautas foi virtualizado, pra usar o
Lévy, e o que ele atualiza hoje pertence a meia dúzia de bilionários. E a um
trilionário, palavra que eu não deveria nem precisar conjugar: que sistema
econômico é esse em que "trilionário" é um substantivo, pela mor?

Então quando eu me pergunto "onde termina o agente e começo eu", a pergunta
individual é quase um luxo. A pergunta material é outra: de quem é o agente?
Quem lucra com a minha dívida cognitiva? O esvaziamento que eu descrevi lá em
cima não é só um fenômeno psicológico, é também um rearranjo de propriedade: o
pensar, que era a parte do trabalho que ninguém conseguia tirar de mim, agora é
minerado, engarrafado e revendido por assinatura. Eu me preocupo com o meu
ghost, mas o meu ghost é um problema pequeno perto de um planeta de ghosts
virando commodity.

E eu sei de onde eu falo: uma travesti de classe média que teve computador e
internet desde sempre, que constrói essas ferramentas e é paga pra isso. Meu
pessimismo é pessimismo de quem está dentro da máquina com privilégio de sobra.
Pra muita gente a IA não é dilema existencial: é o emprego que sumiu, é o
trabalho mal pago de rotular dado pra treinar o modelo, é o deepfake, é a
demissão em massa. O buraco é muito mais fundo que o meu umbigo, e eu não
queria terminar esse texto fingindo que não sei disso.

## protocolo de mitigação (tentativo, revisão 1)

Não tenho conclusão, mas tenho começado a operar com umas regrinhas caseiras, e
deixo aqui porque talvez sirvam pra mais alguém:

1. **Desconfiar da sensação de velocidade.** Se a METR me ensinou algo, é que
   ela mente. A pergunta útil não é "fui mais rápida?", é "o que eu deixei de
   formar no caminho?".
2. **Gera, depois me explica.** O padrão que sobreviveu no estudo da
   Anthropic. Eu tento não aceitar diff que eu não consiga reconstruir
   mentalmente. Se o agente fez e eu não sei refazer, eu não aprendi, eu
   testemunhei.
3. **Sessões brain-only.** No estudo do MIT, o grupo que usou LLM e depois
   voltou a escrever sem ele saiu pior que quem nunca usou. Eu leio isso como
   prescrição: musculatura precisa de carga. Algumas coisas eu escrevo na mão
   de propósito, como caligrafia, como quem corre sem ter pra onde ir.
4. **Delegar a carne, guardar o ghost.** Boilerplate, migração mecânica, teste
   de regressão: Wired. Arquitetura, contrato, schema, o desenho das
   fronteiras: carne. Não é regra moral, é manutenção do meu próprio sistema
   nervoso.
5. **Escrever sobre.** Esse post existe porque dívida cognitiva só se paga com
   juros de atenção. Pensar devagar sobre o que a gente faz rápido.

A Lain termina reescrevendo o mundo e escolhendo ficar invisível nele, porque
ela entende que estar conectada não é a mesma coisa que estar presente. Eu não
quero reescrever mundo nenhum. Eu quero continuar sabendo onde termina o
agente e começo eu, mesmo sabendo, com Haraway, que essa linha nunca existiu,
e suspeitando, com Lévy, que talvez ela precise ser desenhada mesmo assim, a
mão, todo dia. E quero lembrar que regra caseira resolve a parte psicológica e
não resolve a parte material: essa não se resolve sozinha, se resolve junto,
na organização de quem trabalha, no open source, na recusa coletiva de deixar
a infraestrutura do pensar virar propriedade privada de meia dúzia.

Present day. Present time. Ainda sou eu quem escreve. Por enquanto, ainda
importa que seja.

é isso o post 💜

## referências

- [Your Brain on ChatGPT: Accumulation of Cognitive Debt (Kosmyna et al., 2025, preprint)](https://arxiv.org/abs/2506.08872)
- [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity (METR, 2025, RCT)](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) e a [atualização de 2026](https://metr.org/blog/2026-02-24-uplift-update/)
- [The Impact of Generative AI on Critical Thinking (Lee et al., CHI 2025)](https://www.microsoft.com/en-us/research/publication/the-impact-of-generative-ai-on-critical-thinking-self-reported-reductions-in-cognitive-effort-and-confidence-effects-from-a-survey-of-knowledge-workers/)
- [AI Tools in Society: Impacts on Cognitive Offloading (Gerlich, Societies 2025)](https://www.mdpi.com/2075-4698/15/1/6)
- [How AI assistance impacts the formation of coding skills (Shen & Tamkin, Anthropic 2026)](https://www.anthropic.com/research/AI-assistance-coding-skills)
- [When Using AI Leads to "Brain Fry" (BCG/HBR, 2026)](https://www.bcg.com/news/5march2026-when-using-ai-leads-brain-fry)
- [AI-Generated "Workslop" Is Destroying Productivity (BetterUp/Stanford, HBR 2025)](https://www.betterup.com/blog/hidden-costs-workslop)
- [Gifted and burnout in the workplace (Elshof, 2016, dissertação)](https://ihbv.nl/wp-content/uploads/Onderzoek-HB-en-burnout-Akkelijn-Elshof.pdf)
- [Overexcitability and the highly gifted (Davidson Institute)](https://www.davidsongifted.org/gifted-blog/overexcitability-and-the-highly-gifted-child/)
- [AutoCodeBench (2025, preprint)](https://arxiv.org/html/2508.09101v1)
- [Why Elixir is the best language for AI (Valim, 2026)](https://dashbit.co/blog/why-elixir-best-language-for-ai)
- [Your Agent Framework Is Just a Bad Clone of Elixir (Guimarães, 2026)](https://georgeguimaraes.com/your-agent-orchestrator-is-just-a-bad-clone-of-elixir/)
- Donna Haraway, _Manifesto Ciborgue_ (1985)
- Pierre Lévy, _O que é o virtual?_ (1996)
- Serial Experiments Lain (1998), Ghost in the Shell (1995)
