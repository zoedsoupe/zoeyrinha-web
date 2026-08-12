# zoeyrinha-web

O código-fonte do meu blog. Arquivos markdown compilados em tempo de build pelo
NimblePublisher, servidos por Phoenix, deploy no Fly.io. Nenhum banco de dados
foi ferido na produção deste site, porque não existe nenhum.

## o que tem aqui

- **Posts**: markdown com frontmatter em mapa de Elixir, em `priv/posts/`.
  Quando o assunto pede, tem versão em pt-BR e em inglês, e eu escrevo as duas
  porque máquina de traduzir ainda não pega o tom.
- **Comentários**: uma thread do Bluesky usando um trench coat. Cada post
  guarda o URI da thread no frontmatter, a página busca as respostas via
  [proto_rune](https://github.com/zoedsoupe/proto_rune) (meu SDK de AT
  Protocol) e cacheia na hora de renderizar. Sem banco, sem fila de moderação,
  sem Tamagotchi. A história inteira está
  [num post](https://zoedsoupe.zeetech.io/blog/comments-from-the-atmosphere).
- **Blog**: Elixir, BEAM, sistemas distribuídos, e o que quer que eu esteja
  debugando naquela semana. Ocasionalmente economia, cyberpunk e dívida
  cognitiva.

## bem-vindes

Este espaço é trans-inclusivo. Se você é uma pessoa trans, não-binárie ou de
qualquer identidade de gênero, você é bem-vinde aqui, no blog e nas issues.
Escrito por uma travesti, mantido por uma travesti, e o código não liga pra
como você se chama desde que ele compile.

## stack

- **Elixir + Phoenix**: a base inteira. LiveView onde faz sentido, HTML de
  servidor no resto.
- **NimblePublisher**: transforma os markdowns em HTML em tempo de compilação.
  O blog é, tecnicamente, um artefato de build.
- **Tailwind CSS**: o visual gótico-funcional.
- **Bandit**: o servidor HTTP.
- **Nix flake**: o ambiente de dev, pra quem gosta de reprodutibilidade de
  verdade.

## rodando local

Com Nix:

```sh
nix develop
mix deps.get && npm i --prefix assets
iex -S mix phx.server
```

Sem Nix, instale Elixir, Erlang e Node na mão e reze pra versão bater com o
`.tool-versions`. Depois abra `http://localhost:4000`.

## estrutura

- `lib/zoeyrinha`: o núcleo, onde os posts viram dados.
- `lib/zoeyrinha_web`: a casca Phoenix, controllers, componentes, a busca de
  comentários.
- `priv/posts`: os textos. A parte que importa, honestamente.
- `assets`: CSS e o mínimo de JS que a dignidade permite.

## licença

MIT. Veja [LICENSE](./LICENSE).

---

[@zoedsoupe](https://github.com/zoedsoupe) ·
[zoey.spessanha@zeetech.io](mailto:zoey.spessanha@zeetech.io)
