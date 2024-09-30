defmodule ZoeyrinhaWeb.MeHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <main class="container">
      <header>
        <h1>Zoeyrinha</h1>
        <p>Desenvolvedora Sênior e Entusiasta Funcional</p>
      </header>

      <section class="section">
        <h2>Sobre Mim</h2>
        <p>
          Olá, mundo! Sou a Zoey, uma desenvolvedora Elixir apaixonada por transformar café em código funcional e bugs em
          features. Quando não estou debugando a matrix ou refatorando a realidade, você pode me encontrar mergulhada em
          livros sobre teoria das categorias ou praticando a arte de explicar mônadas para gatos.
        </p>
        <p>
          Minha missão? Tornar o mundo um lugar mais funcional, um pattern match de cada vez. Ah, e se você acha que meu
          código é tão elegante quanto meu estilo gótico, você entendeu tudo!
        </p>
      </section>

      <section class="section">
        <h2>Contato</h2>
        <ul class="contact-info">
          <li>📧 <a href="mailto:zoey.spessanha@zeetech.io">zoey.spessanha@zeetech.io</a></li>
          <li>
            💼 <a href="https://linkedin.com/in/zoedsoupe" target="_blank">LinkedIn</a>
            - Prometo não transformar sua
            timeline em um monóide
          </li>
          <li>
            🐙 <a href="https://github.com/zoedsoupe" target="_blank">GitHub</a>
            - Onde meus commits são mais consistentes
            que minha rotina de sono
          </li>
          <li>
            ✍️ <a href="https://dev.to/zoedsoupe" target="_blank">Dev.to</a>
            - Reflexões sobre vida, universo e
            programação funcional
          </li>
        </ul>
      </section>

      <section class="section">
        <h2>Experiência Profissional</h2>
        <div class="experience-item">
          <h3>Cumbuca - Engenheira de Software Sênior</h3>
          <p>São Paulo, Brasil — Outubro 2023 - Presente</p>
          <p>
            Liderando o desenvolvimento de sistemas de processamento de cartão de crédito em Elixir e provando que é
            possível ser imutável em um mundo de constantes mudanças.
          </p>
        </div>
        <div class="experience-item">
          <h3>Nubank - Engenheira de Software</h3>
          <p>São Paulo, Brasil — Fevereiro 2023 - Outubro 2023</p>
          <p>
            Desenvolvi novas features para aplicativos fintech, fazendo contas renderizarem tão rápido quanto eu consigo
            explicar functors.
          </p>
        </div>
        <div class="experience-item">
          <h3>Elixir em Foco - Co-apresentadora de Podcast</h3>
          <p>Março 2021 - Presente</p>
          <p>
            Co-fundadora do primeiro podcast brasileiro dedicado a Elixir, onde transformamos conceitos complexos em piadas
            funcionais.
          </p>
        </div>
      </section>

      <section class="section">
        <h2>Habilidades</h2>
        <p>
          <strong>Técnicas:</strong>
          Elixir, Clojure, TypeScript - Porque a vida é curta demais para linguagens imperativas
        </p>
        <p>
          <strong>Soft Skills:</strong>
          Comunicação efetiva, adaptabilidade, trabalho em equipe, resolução de problemas e
          habilidade de explicar recursão usando recursão
        </p>
      </section>

      <footer>
        <p>&copy; 2024 ZEETECH. Todos os direitos reservados e alguns levemente subvertidos.</p>
      </footer>
    </main>
    """
  end
end
