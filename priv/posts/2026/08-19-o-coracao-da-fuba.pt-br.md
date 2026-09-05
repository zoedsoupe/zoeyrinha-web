%{
title: "o coração da fubá",
description: "post 2 da série fuba web: antes de qualquer telinha, a coelhinha precisa existir. mix new, structs, pattern matching, funções.",
tags: ~w(elixir web tutorial),
series: "fuba-web",
series_index: 1,
bsky_thread: "at://did:plc:4rt5dyqvarrbolr7qmfcbcsm/app.bsky.feed.post/3mtu4bl7k5n24",
}
---

Pois bem, terminado o [manifesto](https://zoedsoupe.zeetech.io/posts/amor-como-faz-telinha-bonita), a pergunta seguinte da jhujuba veio rápido: "tá, e por onde eu começo?". E a resposta não é HTML e nem servidor. Antes de aparecer pra alguém, a Fubá precisa existir: ter medidores, reagir a cuidado, ficar chatinha. Hoje a gente escreve ela inteira sem encostar em internet, nem HTML.

## a regra de ouro

Todo programa desta série tem duas partes. A regra principal: a colelinha precisa sempre funcionar, sem saber o que é internet, HTML, banco de dados ou terminal. E a parte que conecta ela ao mundo: servidor, página, banco, rede.

Ah, e um aviso de navegação que vale pra série inteira: o código completo de cada post mora no repositório [zoedsoupe/fuba](https://github.com/zoedsoupe/fuba). Travou? Compara o seu com o meu.

## mix new fuba

```sh
mix new fuba --sup
cd fuba
```

Vamos ignorar por enquanto esse `--sup` no comando e focar no uso de `mix`. Se você fez os [exlings](https://zoedsoupe.zeetech.io/posts/exlings-learn-elixir-by-breaking-it), reconhece `mix` enquanto uma forma de interagir com projetos - uma pastinha com vários arquivos de código Elixir - e aqui ele tá criando os arquivos iniciais que vamos usar pra escrever a Fubá.

## a coelhinha

```elixir
# lib/fuba/coelhinha.ex
defmodule Fuba.Coelhinha do
  defstruct nome: "Fubá", biscoito: 3, cafeina: 3, carinho: 3, energia: 3

  @type t :: %__MODULE__{
          nome: String.t(),
          biscoito: 0..5,
          cafeina: 0..5,
          carinho: 0..5,
          energia: 0..5
        }
end
```

Uma struct é um mapa com nome, campos fixos e valores padrão: `%Coelhinha{}` nasce com os quatro medidores em `3`, uma coelhinha nova, regulada, neutra. Daqui a pouco você vai ver o poder disso: fazer casamento de padrão em `%Coelhinha{}` na entrada de uma função garante que só coelhinha entra nela.

O `@type t` embaixo não muda nada na hora de rodar. É tipo documentação pra outras pessoas - ou você do futuro - lembrar das "regras" da coelinha, que nesse caso são medidores que vão de 0 a 5, nunca mais, nunca menos.

Com isso, já pode brincar no terminal:

```elixir
$ iex -S mix
iex> %Fuba.Coelhinha{}
%Fuba.Coelhinha{nome: "Fubá", biscoito: 3, cafeina: 3, carinho: 3, energia: 3}
```

## cuidando dela (sem encostar nela)

Recap rápido da imutabilidade: ninguém "muda" a coelhinha. As funções recebem uma e devolvem **outra**. `%{c | biscoito: 5}` não edita `c`, cria uma cópia com o campo novo, e a original segue intacta. Parece desperdício, né? Na prática é o que te dá segurança de alterar dados sem corromper nada.

A primeira ação de cuidado:

```elixir
# lib/fuba/cuidado.ex
defmodule Fuba.Cuidado do
  @moduledoc """
  O coração da Fubá: 100% puro, zero IO, HTTP, HTML.
  """

  alias Fuba.Coelhinha

  @spec dar_biscoito(Coelhinha.t()) :: Coelhinha.t()
  def dar_biscoito(%Coelhinha{} = c) do
    %{c | biscoito: limita(c.biscoito + 2)}
  end
end
```

Três coisas aí. O `@moduledoc` é a regra de ouro da seção anterior escrita no topo do arquivo, pra ninguém esquecer. O `%Coelhinha{} = c` na cláusula é o casamento de padrão: qualquer coisa que não seja uma coelhinha nem entra. E o `@spec` é como o `@type` do módulo da Fubá, só que para funções, que a gente definiu na struct - "recebe Coelhinha, devolve Coelhinha". De novo: documentação. Você vai ver um em cima de cada função daqui pra frente!

Falta o `limita/1`, que mora no fim do módulo:

```elixir
def limita(n) do
  n |> max(0) |> min(5)
end
```

É ele que segura a regra dos medidores: nunca passa de 5, nunca desce de 0. O pipe joga o número no `max/2` e depois no `min/2`, nessa ordem.

Agora é com você. Escreve as outras três ações antes de passar pro próximo passo: `dar_cafe/1` (cafeína +2), `fazer_cafune/1` (carinho +2) e `dar_espaco/1` - essa última mexe em **dois** medidores: energia +2, carinho −1. Espaço recarrega, mas afasta um tiquinho. Tenta aí, eu espero.

...

> Escreveu mesmo né? Tô de olho ksks

...

Foi? Então confere:

```elixir
def dar_cafe(%Coelhinha{} = c), do: %{c | cafeina: limita(c.cafeina + 2)}
def fazer_cafune(%Coelhinha{} = c), do: %{c | carinho: limita(c.carinho + 2)}

def dar_espaco(%Coelhinha{} = c) do
  %{c | energia: limita(c.energia + 2), carinho: limita(c.carinho - 1)}
end
```

## calculando o humor

O humor da Fubá é **calculado** a partir medidores, nunca armazenado. Podia ser um campo na struct, e aí moraria uma armadilha, minha nossa: dois lugares guardando a mesma verdade, e um deles mentindo cedo ou tarde. Calculado na hora, ele nunca mente.

```elixir
@type humor :: :feliz | :chatinha | :desregulada | :go_queen

@spec humor(Coelhinha.t()) :: humor()
def humor(%Coelhinha{} = c) do
  medidores = [c.biscoito, c.cafeina, c.carinho, c.energia]

  cond do
    Enum.count(medidores, &(&1 == 0)) >= 2 -> :desregulada
    Enum.all?(medidores, &(&1 >= 4)) -> :go_queen
    Enum.any?(medidores, &(&1 == 0)) -> :chatinha
    true -> :feliz
  end
end
```

O `cond` faz vários testes de verificação e para na primeira linha que der "verdade" - então **a ordem importa**: `:desregulada` (dois ou mais medidores zerados) precisa vir antes de `:chatinha` (algum zerado), senão a chatinha sempre vai ser "verdade" primeiro e a desregulada nunca acontece. O `true` no fim faz o papel de `else` ("se não..."): chegou até ali, é `:feliz`. E o `@type humor` ali em cima é só a lista dos humores possíveis, escrita como tipo - o `@spec` usa ela no lugar de soletrar átomo por átomo.

Do forma que a gente fez, signfica que dada uma coelinha desregulada, a função `humor/1` sempre vai devolver o resultado `:desregulada`, não depende de nenhum contexto externo, apenas dos medidores da própria Fubá.

## a regra emocional

Falta a peça que dá personalidade a ela:

```elixir
@type acao :: :biscoito | :cafe | :cafune | :espaco

@spec aplicar(Coelhinha.t(), acao()) :: Coelhinha.t()
def aplicar(%Coelhinha{} = c, acao) do
  if humor(c) == :desregulada and acao != :espaco do
    c
  else
    case acao do
      :biscoito -> dar_biscoito(c)
      :cafe -> dar_cafe(c)
      :cafune -> fazer_cafune(c)
      :espaco -> dar_espaco(c)
    end
  end
end
```

Desregulada, ela não aceita biscoito, café nem cafuné: a função devolve ela **inalterada**. Só espaço atravessa.. Um dia a "tela bonitinha" vai chamar `aplicar/2`, mas quem decide é sempre esse módulo. Telinha nenhuma passa por cima da coelhinha!

## carinhas

Último módulo de hoje, e o mais sério de todos:

```elixir
# lib/fuba/humor.ex
defmodule Fuba.Humor do
  alias Fuba.Cuidado

  # sim, carinha é regra de negócio :P
  @spec carinha(Cuidado.humor() | atom()) :: String.t()
  def carinha(:feliz), do: "( ᵔ ᴥ ᵔ )"
  def carinha(:chatinha), do: "( ￣^￣)"
  def carinha(:desregulada), do: "( ; ᴥ ; )"
  def carinha(:go_queen), do: "\\(ᵔᴥᵔ)/"
  def carinha(_desconhecido), do: "( o.o )"
end
```

Casamento de padrão em múltiplas cláusulas de novo: uma cláusula por humor, e a última casa qualquer coisa - humor desconhecido ganha carinha neutra em vez de erro. O `@spec` reusa o tipo `humor` que a gente definiu no `Cuidado`, com um `| atom()` em cima por causa dessa cláusula final generosa. E óbvio que as carinhas são as minhas; as suas você inventa.

## provando que funciona

O `mix new` já deixou o ExUnit arrumado, então é só escrever `test/fuba/cuidado_test.exs`:

```elixir
defmodule Fuba.CuidadoTest do
  use ExUnit.Case

  alias Fuba.{Coelhinha, Cuidado}

  describe "aplicar/2" do
    test "desregulada ignora cafuné" do
      fuba = %Coelhinha{biscoito: 0, cafeina: 0}
      assert Cuidado.aplicar(fuba, :cafune) == fuba
    end
  end
end
```

O `describe` agrupa testes da mesma função - organização, quando criarmos mais testes vai fazer bem mais sentido. Um teste eu te dou. Os outros são seus, onde:

- `humor/1` pros quatro casos
  - devolver `:desregulada` com 2 medidores em 0
  - devolver `:go_queen` quando todos os medidos >= 4
  - devolver `:chatinha` quando pelo menos 1 medidor em 0
  - devolver `:feliz` nos outros casos
- desregulada **aceitando** `:espaco` (energia em 1 vai a 3)
- `limita/1` não passando de 5 nem descendo de 0.

Escreve eles antes de me dar razão - depois confere os seus com os do [repositório](https://github.com/zoedsoupe/fuba/tree/main/test).

## fechou?

Dois critérios, como combinado:

1. `mix test` verde no terminal - com os testes que **você** escreveu, não só o meu.
2. No `iex -S mix`, os quatro humores respondem:

```elixir
iex> alias Fuba.{Coelhinha, Cuidado}
iex> Cuidado.humor(%Coelhinha{})
:feliz
iex> Cuidado.humor(%Coelhinha{biscoito: 0})
:chatinha
iex> Cuidado.humor(%Coelhinha{biscoito: 0, cafeina: 0})
:desregulada
iex> Cuidado.humor(%Coelhinha{biscoito: 5, cafeina: 5, carinho: 5, energia: 5})
:go_queen
```

Verde nos dois? Fechou.

A Fubá existe. Você conversa com ela no terminal, dá biscoito, vê o humor mudar. Só que ninguém além de você vê qualquer coisa - ela mora trancada num terminal. No próximo post a gente dá voz a ela: HTTP, e o primeiro servidor que você escreve na vida.

É isso o post 💜
