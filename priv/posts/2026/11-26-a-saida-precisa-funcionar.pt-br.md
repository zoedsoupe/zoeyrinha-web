%{
  title: "a saída precisa funcionar",
  description: "Ou, a saga que vivi implementando um PDS ATproto do 0 e migrando minha conta do BlueSky de verdade: portabilidade, identidade, operação e os limites do self-hosting.",
  tags: ~w(elixir atproto pesque open-social soberania-digital),
  series: "soberania-digital",
  series_index: 0
}
---

Eu migrei a `zoedsoupe.zeetech.io` para um [PDS](https://atproto.com/guides/the-at-stack) (Personal Data Server, o servidor que guarda sua conta e fornece seus dados aos aplicativos) que eu mesma implementei. O servidor é o [pesque](https://github.com/zeeetech/pesque), escrito totalmente em Elixir, rodando no meu homelab (vulgo, uma caixa debaixo da mesa do meu escritorio). Desde então, uso a conta diariamente pelo aplicativo oficial do Bluesky, sem precisar de um cliente especial nem de um ritual para fazer a rede me enxergar.

Essa frase parece pequena. Para mim, foi a parte mais gratificante do projeto: abrir o aplicativo e estar tudo lá. Não uma demonstração com um banco de dados local, não um teste contra um servidor falso, não um arquivo exportado fazendo cosplay de rede social. Minha identidade, meus registros e minhas mídias tinham mudado de casa, e o restante da atmosfera continuou conversando comigo.

Este post não é um tutorial nem uma certificação de que o pesque resolveu todos os problemas. É uma reflexão sobre o que precisei aprender para que uma promessa bonita, "você pode sair", virasse uma sequência de operações que realmente terminam com uma conta ativa em outro lugar.

## sair levando mais do que um arquivo

Quando uma plataforma oferece um botão para baixar meus dados, ela costuma entregar um arquivo. Às vezes um `ZIP` caprichado, às vezes um `JSON` cuja única função prática é ocupar espaço num disco externo. O arquivo pode até conter tudo o que publiquei, mas perdeu o contexto que fazia aquilo ser social: os endereços pelos quais outras pessoas me encontravam, as referências entre registros, os aplicativos que sabiam ler aquilo e os serviços que redistribuíam minhas atualizações.

Dan Abramov chama isso de dados mortos em [Open Social](https://overreacted.io/open-social/). A comparação que me ajuda é a de mudar de apartamento recebendo apenas uma foto dos móveis. A foto documenta o que existia, mas não me deixa sentar no sofá.

No AT Protocol, a unidade portátil não é um `dump` qualquer. Cada conta possui um repositório de registros públicos, organizado como uma Merkle Search Tree (MST), uma estrutura aparentada da [árvore de Merkle](https://wikipedia.org/wiki/Merkle_tree) que mantém os registros ordenados e permite verificar se algo foi alterado. Cada bloco recebe um `CID` (uma espécie de impressão digital calculada a partir do conteúdo: se ele muda, o identificador também muda), e cada `commit` é como uma fotografia assinada do repositório depois de uma mudança. O repositório inteiro pode ser exportado como um arquivo `CAR` (a caixa de mudança que empacota esses blocos). As mídias ficam fora da árvore, como `blobs` (arquivos como fotos e vídeos) referenciados pelos registros.

A árvore importa porque "guardar `JSON`" não basta. Pense nela como um fichário: os registros ficam ordenados, e suas etiquetas digitais denunciam quando uma ficha foi adulterada. A árvore representa as fichas que estão lá agora; a sequência de `commits` registra as fotografias assinadas depois de cada mudança. Duas implementações precisam ordenar chaves, codificar valores, calcular profundidades, comprimir prefixos e produzir identificadores da mesma maneira. Caso contrário, cada uma monta um fichário perfeitamente razoável para si mesma e incompatível com a assinatura que a outra esperava. Soberania, aqui, começa num lugar pouco épico: concordar sobre bytes.

Implementar a `MST` me mostrou a distância entre entender o desenho do protocolo e fazê-lo interoperar. Não bastava uma estrutura de dados que guardasse e recuperasse meus posts. Eu precisava de uma estrutura canônica e determinística: a mesma coleção de registros precisa produzir a mesma árvore e os mesmos identificadores, não importa qual implementação faça a conta. Só assim ela consegue provar para terceiros que aquele conteúdo pertencia àquele histórico assinado. Uma rede aberta depende de muitas pessoas fazendo essas contas chatíssimas chegarem ao mesmo resultado.

## a mudança tem uma ordem

O repositório é só uma das bagagens. Na migração, pesque precisa criar uma conta ainda desativada, importar o CAR, buscar todos os blobs e preparar as credenciais da identidade. Só depois disso faz sentido atualizar o documento DID para apontar ao novo PDS.

Se o PDS é a casa e o handle é o nome na porta, o [DID](https://www.w3.org/TR/did-core/) é a identidade que continua sua depois da mudança. Ele é a referência estável usada nos endereços `at://`, enquanto o handle que as pessoas leem pode mudar. O documento DID é o aviso público que diz onde você mora agora e qual chave assina seus registros. No caso de `did:plc`, essa atualização passa pelo diretório PLC e por operações assinadas com chaves de rotação.

Foi nessa fronteira que detalhes minúsculos ganharam dimensão política. Em um dos bugs, eu enviava `{}` ao pedir ao PDS antigo a assinatura da operação PLC. O endpoint esperava um corpo vazio. Um par de chaves, desses que a gente digita sem cerimônia, era a diferença entre concluir a mudança e ficar olhando para um erro. Minha nossa.

A divisão de trabalho é mais ou menos esta: o PDS guarda, o relay distribui os avisos de que algo mudou, o AppView monta as visões da rede e o cliente apresenta tudo na tela.

Mesmo depois de copiar tudo e atualizar a identidade, a migração ainda não acabou. Relays e AppViews precisam entender que existe uma nova casa, que a conta está ativa nela e que eventos futuros devem ser procurados ali. O pesque emite eventos de identidade, conta e sincronização, ativa a conta nova, desativa a antiga e só então anuncia o novo estado e pede ao relay que venha buscar as atualizações (o tal `crawl`).

A ordem importa. Se o PDS antigo anunciar a desativação tarde demais, um AppView pode continuar achando que a conta inteira está desativada. Se o relay não estiver acompanhando o novo servidor, ele não vai adivinhar que aquele PDS agora participa da rede. "Meus dados estão aqui" e "a rede sabe me encontrar aqui" são afirmações diferentes.

Por isso, o momento decisivo não foi ver uma transação SQLite terminar. Foi voltar ao cliente oficial e constatar que aqueles outros servidores, que eu não opero, tinham aceitado a mudança. A porta de saída só existe de verdade quando o outro lado também a reconhece.

## quatro coisas que a gente chama de soberania

Depois dessa experiência, ficou mais difícil usar "soberania digital" como se fosse uma coisa só. Na minha migração, pelo menos quatro questões apareceram separadamente.

A primeira é **custódia dos dados**. No pesque, o estado mora em um banco SQLite (um banco de dados que cabe num único arquivo) e num diretório de blobs. Eu posso inspecionar, copiar e restaurar esse estado sem pedir permissão a uma plataforma. Isso é concreto, mas não é suficiente: um backup que nunca foi restaurado é mais uma esperança do que uma garantia.

A segunda é **identidade**. Meu DID continuou o mesmo ao mudar de PDS. Essa separação entre quem eu sou e quem hospeda meus registros é o que impede que a hospedagem vire meu nome permanente. Ao mesmo tempo, `did:plc` não elimina dependência: o diretório PLC e as chaves de rotação continuam sendo pontos de governança e custódia. `did:web` troca parte dessa dependência pela necessidade de manter controle sobre um domínio. Não existe identidade sem alguém mantendo alguma coisa.

A terceira é **nome e endereçamento**. [DNS](https://developer.mozilla.org/pt-BR/docs/Learn/Getting_started_with_the_web/How_the_Web_works), handle, HTTPS e certificados precisam continuar resolvendo. Um servidor pode estar saudável por dentro e inacessível para a federação por fora. O pesque inclusive reclama na inicialização quando a URL pública não usa HTTPS ou quando um endereço IP aparece onde a rede espera um nome resolvível. A soberania de possuir um domínio vem acompanhada da tarefa de renovar, configurar e não deixar esse domínio escapar.

A quarta é **descoberta e experiência**. Um PDS não é um relay, não é um AppView, não é busca, feed, sistema de notificações ou cliente. Meu aplicativo oficial continuar funcionando é evidência de interoperabilidade, não de que eu controlo a rede inteira. Entre meu repositório e a tela do celular existem outros operadores, outras políticas e outros incentivos.

Essas camadas podem ser apropriadas ou abandonadas separadamente. Dizer "tenho meus dados" responde apenas à primeira. Dizer "posso mudar de hospedagem sem trocar de DID" responde à segunda. Nenhuma delas, sozinha, responde quem decide o que aparece para mim ou para quem me segue.

## a parte invisível chama manutenção

O pesque guarda chaves de assinatura por DID, chave de rotação PLC, chave OAuth, segredo do servidor, banco e blobs no diretório de dados. O backup usa `VACUUM INTO` para obter uma cópia consistente do SQLite enquanto o serviço está vivo. A restauração tem modo de ensaio. Também existem comandos de operação e um `doctor` para diagnosticar configuração e conectividade.

Esses recursos não são excessos de zelo. São o trabalho que transforma "rode seu próprio servidor" em algo um pouco menos irresponsável. TLS, DNS, atualização, espaço em disco, recuperação de desastre, códigos de confirmação e proteção das chaves não desaparecem porque o protocolo é aberto. Eles mudam de endereço.

No desenho atual, o pesque não envia e-mail sozinho. Quem opera precisa encaminhar códigos de confirmação, recuperação e PLC. Essa decisão reduz a superfície do projeto, mas deixa evidente um limite do self-hosting: a autonomia de uma pessoa pode depender de uma coleção cansativa de responsabilidades que antes estavam escondidas atrás de um botão.

Há ainda uma diferença importante entre portabilidade e privacidade. Os registros do repositório são públicos por protocolo. Relays e AppViews os replicam. Apagar uma conta remove dados e chaves do PDS, mas não desfaz tudo o que já foi observado ou redistribuído. Apagar a conta da minha casa não recolhe as fotocópias que já foram distribuídas. Levar meus dados comigo não significa controlar todas as cópias que já existiram.

Eu continuo achando que valeu a pena. Não porque agora sou uma ilha soberana, expressão que descreve melhor um delírio de VPS do que uma vida digital, mas porque uma dependência deixou de ser obrigatória. Se eu quiser trocar de implementação ou de hospedagem, existe um caminho técnico para isso. Eu percorri esse caminho com minha conta real.

Só que uma liberdade que exige saber operar banco, chaves, DNS, TLS, backups e eventos de federação ainda é uma liberdade distribuída de forma muito desigual. A saída funcionou para mim, uma pessoa que se diverte implementando o próprio servidor. O próximo problema é fazer com que ela não dependa de todo mundo se tornar essa pessoa.

No próximo post, quero sair do `yby` e falar do Brasil: por que soberania não é acabar com todos os centros, o que uma federação precisa ter de verdade e por que escolher algoritmos é tão importante quanto escolher hospedagem.

é isso o post 💜

## referências

- [pesque, código-fonte e documentação](https://github.com/zeeetech/pesque), incluindo o [manual de operação](https://github.com/zeeetech/pesque/blob/main/docs/operations.md).
- AT Protocol: [Repository](https://atproto.com/specs/repository), [Account Migration](https://atproto.com/guides/account-migration), [Accounts and deletions](https://atproto.com/guides/account-lifecycle), [The AT Stack](https://atproto.com/guides/the-at-stack) e [Protocol Overview](https://atproto.com/guides/overview).
- W3C: [Decentralized Identifiers (DIDs)](https://www.w3.org/TR/did-core/).
- MDN: [Como a Web funciona](https://developer.mozilla.org/pt-BR/docs/Learn/Getting_started_with_the_web/How_the_Web_works).
- Dan Abramov: [Open Social](https://overreacted.io/open-social/) e [Where It's at://](https://overreacted.io/where-its-at/).
- Textos anteriores deste blog sobre a mesma trajetória: [comentários que vivem na atmosfera](/posts/comments-from-the-atmosphere) e [o quintal está aberto](/posts/the-quintal-is-open).
