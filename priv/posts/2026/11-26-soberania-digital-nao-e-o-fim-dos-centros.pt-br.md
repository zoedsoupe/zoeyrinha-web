%{
  title: "soberania digital não é o fim dos centros",
  description: "Federar de verdade, escolher algoritmos, exigir portabilidade e construir capacidade coletiva no Brasil, sem transformar soberania em autarquia.",
  tags: ~w(open-social atproto activitypub soberania-digital brasil taina),
  series: "soberania-digital",
  series_index: 1
}
---

No [post anterior](/posts/a-saida-precisa-funcionar), contei que migrei minha conta para o pesque e continuei usando o aplicativo oficial do Bluesky. A porta de saída funcionou. Meu DID não mudou, meu repositório atravessou a mudança e outros serviços passaram a reconhecer o novo PDS.

Isso resolve uma dependência importante. Não resolve a pergunta que continua aberta quando fecho o terminal e abro o feed: quem decide o que eu vejo?

De nada adianta poder trocar o galpão onde meus dados dormem se a rua entre mim e outras pessoas continua pertencendo ao mesmo dono. Soberania digital também envolve distribuição, descoberta, recomendação, moderação e a possibilidade de contestar decisões. É aí que a conversa sai da hospedagem e entra na democracia.

E é aí que eu queria abandonar uma oposição preguiçosa: de um lado, centralização; do outro, descentralização. Como se todo centro fosse opressão e toda ausência de centro fosse liberdade.

## centros podem coordenar ou capturar

Eu não defendo uma rede social do governo só para existir uma alternativa nacional. Também não defendo uma internet estatal, nem a substituição de um senhor feudal estrangeiro por um funcionário público com o mesmo poder opaco. Trocar a bandeira de uma infraestrutura não muda automaticamente suas relações de poder.

Mas isso não me leva a defender que tudo seja descentralizado. O Banco Central é importante. Regras comuns são importantes. Instituições capazes de construir, financiar, auditar e fazer cumprir obrigações são importantes. Soberania não exige eliminar toda coordenação; exige saber quem coordena, com qual mandato, sob quais regras e com quais formas de contestação.

A diferença está entre um centro que mantém regras comuns e um centro que transforma dependência em modelo de negócio. Entre uma instituição que pode ser criticada, regulada e responsabilizada e uma plataforma que altera a visibilidade de um debate eleitoral por decisões comerciais inacessíveis a quem vive as consequências.

O [Open Finance](https://aprendervalor.bcb.gov.br/estabilidadefinanceira/cliente-open-finance) é um exemplo político que me interessa justamente por não caber no slogan "descentralize tudo". Existem instituições diferentes oferecendo serviços, um conjunto comum de regras e uma autoridade pública coordenando o arranjo. O usuário não precisa torcer para que duas empresas decidam colaborar por generosidade. A interoperabilidade é uma obrigação institucional.

No texto [O protocolo que falta](https://yaso.substack.com/p/o-protocolo-que-falta-open-finance), Yaso compara esse arranjo ao Open Social e aponta diferenças técnicas relevantes: no Open Finance, as instituições continuam ancorando a identidade e oferecem acesso mediado aos dados; no AT Protocol, uma identidade persistente aponta para repositórios assinados que podem mudar de hospedagem. Não é uma competição para decidir qual arquitetura vence todas as outras. É uma demonstração de que existem várias maneiras de reduzir cativeiro, combinando protocolo, instituições e regulação.

O que eu quero importar do Pix e do Open Finance não é uma arquitetura pronta para redes sociais. É a pergunta: quais capacidades precisam ser infraestrutura comum para que nenhum participante possa vender de volta para nós o direito de sair?

## o algoritmo também é uma fronteira

O vídeo do Átila Iamarino sobre soberania digital organiza muito bem essa preocupação. Ele relata uma IA da Meta sugerindo o número 22 para uma eleição no Brasil enquanto recusava alternativas, além de diferenças de distribuição de um mesmo conteúdo entre TikTok, Instagram e YouTube. São episódios contados por ele, não uma auditoria independente que eu tenha reproduzido. Ainda assim, bastam para formular o problema sem exigir prova de intenção maligna: uma empresa privada não deveria ter poder incontestável sobre a circulação do debate público.

Outro relato do vídeo é pessoal. Ao sair do Twitter, Átila perdeu o acesso direto a aproximadamente 1,5 milhão de seguidores. Esse custo ajuda a explicar por que plataformas continuam habitáveis economicamente mesmo quando ficam piores para quem está dentro. A pessoa não permanece apenas porque gosta do produto. Permanece porque sua rede, seu trabalho e sua reputação foram transformados em garantia da permanência.

Portabilidade de dados ataca uma parte desse custo. Escolha algorítmica ataca outra. Uma navegação mais saudável precisa permitir, no mínimo, seguir pessoas sem que uma otimização invisível interponha sempre seus próprios objetivos. Feed cronológico (as publicações na ordem em que aconteceram, sem um ranking escolhendo prioridades), escolha real entre algoritmos, possibilidade de desligar recomendações e explicações compreensíveis sobre moderação não são frescuras de usuário avançado. São condições para que a relação entre publicar e ser lida não fique inteiramente refém de uma empresa.

Isso vale com força especial durante eleições. Plataformas estrangeiras participam ativamente da formação do espaço público brasileiro, mas suas decisões de alcance, suspensão, publicidade e recomendação não respondem democraticamente à sociedade afetada por elas. Exigir transparência, contestação e limites não é pedir que o Estado escolha o conteúdo permitido. É recusar que decisões com consequências coletivas fiquem protegidas como segredo comercial.

Também não acho que "algoritmo aberto" resolva tudo sozinho. Publicar um ranking não impede que uma plataforma controle os dados, os clientes, os padrões de atenção e os incentivos que determinam o que chega até ele. Liberdade de escolha precisa incluir fornecedores alternativos, clientes diferentes e uma saída que não transforme anos de vida social em prejuízo irreparável.

## federado de verdade

Quando digo que prefiro algo federado de verdade, não estou contando quantos servidores aparecem num diagrama. Uma federação pode ter mil máquinas e continuar politicamente centralizada se houver apenas um cliente utilizável, um diretório inevitável, um relay dominante ou um grupo sem prestação de contas decidindo todas as regras.

Para mim, uma federação de verdade precisa de operadores independentes, padrões compartilhados, clientes substituíveis, migração efetiva e espaço para que novas instituições entrem sem pedir autorização ao maior participante. Precisa também de meios para resolver abuso, spam e moderação sem transformar cada servidor numa lei própria nem entregar tudo a uma autoridade única.

O e-mail é uma referência útil: provedores diferentes podem trocar mensagens sem pertencer à mesma empresa. Mas também é um aviso, porque ter um protocolo aberto não impediu que poucos provedores concentrassem grande parte da experiência.

ActivityPub e AT Protocol fazem recortes diferentes desse problema. O ActivityPub especifica tanto a federação entre servidores quanto uma API entre clientes e servidores, organizada em torno de atores, caixas de entrada e saída. O AT Protocol separa identidade, repositórios pessoais, PDS, relays e AppViews (a camada que transforma registros em perfis, feeds e buscas), fazendo o documento DID indicar a hospedagem atual da conta. Essa diferença importa para a migração e para o modo como os dados circulam, mas não transforma nenhum dos dois em sociedade democraticamente organizada por decreto técnico.

No AT Protocol, por exemplo, o PLC continua sendo um centro importante de governança para `did:plc`. Relays agregam eventos, AppViews produzem as experiências de leitura e clientes medeiam quase tudo o que uma pessoa comum percebe como "a rede". Os commits assinados permitem verificar a procedência dos dados sem confiar cegamente num cache, o que é uma propriedade valiosa. Não impedem, porém, que um intermediário poderoso deixe de distribuir, indexar ou apresentar aquilo.

Reconhecer esses centros não é argumento para abandonar protocolos abertos. É um convite a governá-los como infraestrutura. Precisamos de diversidade de relays e AppViews, clientes que não sejam apenas variações do mesmo funil, diretórios de identidade responsáveis e possibilidade real de recuperação. Em alguns casos, instituições públicas podem financiar ou operar partes dessa base, como serviços de backup, migração e identificadores, sem que o destino principal de todo brasileiro seja uma rede social estatal.

A analogia que o Átila faz com o SUS é útil aqui: infraestrutura pública não precisa significar que todo serviço será público. Ela pode estabelecer um piso, sustentar capacidades comuns e impedir que quem não consegue pagar pelo melhor provedor fique sem nenhuma alternativa. O ponto não é nacionalizar a conversa. É democratizar as condições materiais para participar dela.

## uma porta de saída obrigatória

Eu não acho que a regulação brasileira deva apenas pedir relatórios de transparência e observar plataformas continuarem donas das passagens. Plataformas com poder de mercado que operam no Brasil e organizam relações sociais, comerciais e políticas em escala deveriam ser obrigadas a oferecer interoperabilidade e portabilidade efetivas.

A telefonia ajuda a separar duas coisas: portabilidade é trocar de operadora sem perder seu número; interoperabilidade é conseguir ligar para quem usa outra operadora. Nas redes sociais, precisamos das duas.

"Efetivas" é a palavra que impede a obrigação de virar teatro. Um export anual de JSON não basta. Uma API que só funciona para parceiros escolhidos não basta. Uma migração que conserva textos, mas destrói identidade, mídia, permissões e conexões, não cumpre a promessa inteira. A saída precisa estar disponível a qualquer tempo, ser compreensível, segura e compatível com concorrentes, incluindo alternativas nacionais.

Isso não significa obrigar toda rede pequena a sustentar integrações sob medida com cada gigante. O caminho é exigir padrões abertos e interfaces razoáveis de quem tem poder de mercado, permitindo que outros implementem esses padrões sem depender de uma sala de reuniões com a incumbente. Compras públicas e financiamento de tecnologia também podem privilegiar software aberto, documentação, portabilidade e capacidade local de manutenção.

E a obrigação vale para as alternativas nacionais também. Uma plataforma brasileira que prende identidade e audiência continua praticando cativeiro, só com CNPJ daqui. Soberania não pode virar licença para reproduzir em escala menor o que criticamos nas Big Techs.

## nem autarquia, nem apagamento mágico

Falar de soberania digital no Brasil pede uma escala maior do que a de redes sociais. O [Digital Sovereignty Index](https://www.bricstechforum.org/dsi), por exemplo, compara capacidades em hardware, software, cognição e governança. O recorte é útil porque lembra que um protocolo aberto rodando sobre computadores, redes, nuvens e cadeias produtivas inteiramente dependentes ainda deixa vulnerabilidades em outras camadas.

Um estudo do CGEE sobre soberania digital no Brasil também insiste em capacidade técnica, institucional e humana, coordenação de longo prazo e cooperação internacional. Soberania não é autarquia (a tentativa de produzir tudo dentro de casa e não depender de ninguém). Não se trata de produzir cada chip, programa e cabo dentro das fronteiras, mas de conseguir entender, desenvolver, regular e sustentar as tecnologias de que dependemos, sem que uma relação externa possa interromper arbitrariamente a vida nacional.

A entrevista de James Görgen ao DigiLabour coloca essa questão de maneira concreta: mesmo uma infraestrutura pública como o Pix pode depender da camada física e de processamento de provedores estrangeiros. Se olharmos apenas para a regra visível do sistema, perdemos a infraestrutura que a mantém de pé.

Há limites dentro do próprio Open Social. Repositórios ATProto são públicos por padrão e feitos para circulação verificável. Replicação, cache e histórico entram em tensão com expectativas de apagamento e com obrigações de proteção de dados. Consentimento não resolve essa tensão sozinho, especialmente quando dados já foram distribuídos. Uma política de soberania que prometa controle absoluto sobre cada cópia estará vendendo uma mentira reconfortante.

O trabalho honesto é mais difícil: reduzir coleta desnecessária, definir visibilidades apropriadas, criar mecanismos de revogação quando fizerem sentido, responsabilizar serviços que redistribuem dados e explicar claramente o que a arquitetura não consegue garantir.

## construir capacidade também é pedir ajuda

Depois de implementar um PDS, ficou ainda mais claro para mim que infraestrutura não é uma cena heroica de lançamento. É restaurar backup, observar alguém tentando instalar, corrigir uma atualização, explicar uma decisão e continuar presente quando a novidade passa.

Essa é uma das conexões entre esta série e o [Tainá](https://github.com/taina-labs/taina), meu projeto de nuvem privada comunitária. O Tainá não é uma rede social, não implementa ATProto e ainda não é uma federação. O escopo atual é outro: uma caixa por comunidade, para guardar arquivos e fotos, espelhar o rolo da câmera e manter backups externos criptografados com recuperação equivalente. A `casa` é privada por padrão, a `praça` é compartilhada e quem opera a máquina não ganha automaticamente acesso ao conteúdo privado das outras pessoas.

O projeto ainda está sendo construído e precisa provar justamente a parte que os diagramas costumam esconder. Por isso, este post também é um pedido de ajuda. Quero encontrar de duas a três comunidades dispostas a pilotar o Tainá e pessoas para observar instalações e recuperações feitas por quem não vive dentro de um terminal. Preciso testar restauração, atualização e rollback (voltar para a versão anterior quando uma atualização quebra), backup externo, Android, iOS e hardware como Raspberry Pi. Também preciso de ajuda com Elixir, Flutter, Nix, UX e documentação.

Não é necessário saber programar para contribuir. Descobrir onde uma pessoa desiste, qual instrução parece ameaçadora ou o que acontece quando o zelador da comunidade viaja é conhecimento de infraestrutura tanto quanto escrever um módulo. O repositório do backend está em [taina-labs/taina](https://github.com/taina-labs/taina), e o aplicativo móvel em [taina-labs/tekoa](https://github.com/taina-labs/tekoa).

Não sei se existe uma arquitetura final que resolva poder digital. Desconfio de quem vende essa certeza. Mas sei que uma saída real muda uma negociação, que uma instituição responsável pode sustentar liberdades e que uma comunidade capaz de manter sua infraestrutura depende menos da boa vontade de quem lucra com sua permanência.

Soberania digital, para mim, está nesse trabalho combinado: centros que possamos contestar, protocolos que possamos implementar, regras que possamos exigir e capacidade coletiva para continuar quando qualquer fornecedor decidir ir embora.

E, antes de terminar, um valeu à distância para o Átila Iamarino e o Yaso. Não conheço nenhum dos dois pessoalmente, mas o vídeo e os textos deles me deram vocabulário, provocações e referências importantes para organizar estas reflexões. Obrigada por escreverem e falarem em público sobre problemas que atravessam código, instituições e vida cotidiana.

é isso o post 💜

## referências

- [a saída precisa funcionar](/posts/a-saida-precisa-funcionar), primeira parte desta série, com a migração para o pesque.
- Átila Iamarino: [vídeo sobre soberania digital, regulação e a ideia de um "Pix das redes sociais"](https://www.youtube.com/watch?v=ZUm1UfhoJS4).
- Yaso: [O protocolo que falta: Open Finance, Open Social, Open Health, open everything](https://yaso.substack.com/p/o-protocolo-que-falta-open-finance).
- Banco Central: [O que é Open Finance](https://aprendervalor.bcb.gov.br/estabilidadefinanceira/cliente-open-finance).
- Dan Abramov: [Open Social](https://overreacted.io/open-social/) e [Where It's at://](https://overreacted.io/where-its-at/).
- AT Protocol: [Protocol Overview](https://atproto.com/guides/overview), [The AT Stack](https://atproto.com/guides/the-at-stack), [Repository](https://atproto.com/specs/repository), [Sync](https://atproto.com/specs/sync) e [Accounts](https://atproto.com/specs/account).
- W3C: [ActivityPub Recommendation](https://www.w3.org/TR/activitypub/).
- CGEE: [Digital Sovereignty in Brazil: Assessment, Challenges and Pathways from the Perspective of Science, Technology and Innovation](https://www.cgee.org.br/documents/37878/227235/CGEE_GA_01_Sumario_Executivo_Soberania_Digital_EN_DEFESO.pdf/de58520e-9b3e-8897-9449-c176c1692227?t=1789743912482&version=1.0).
- BRICS Tech Forum, GEPSI UnB e GETIP USP: [Digital Sovereignty Index](https://www.bricstechforum.org/dsi).
- DigiLabour: [O plano governamental brasileiro de soberania digital, entrevista com James Görgen](https://digilabour.com.br/pt/o-plano-governamental-brasileiro-de-soberania-digital-entrevista-com-james-gorgen).
- Tainá: [repositório do backend](https://github.com/taina-labs/taina) e [aplicativo móvel Tekoa](https://github.com/taina-labs/tekoa).
