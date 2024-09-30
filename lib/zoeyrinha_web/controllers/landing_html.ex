defmodule ZoeyrinhaWeb.LandingHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <main class="container">
      <h1>Zoeyrinha</h1>
      <p>Blog pessoal e portfólio da Zoey</p>
      <p>Em breve, um espaço cheio de código funcional, reflexões econômicas e muito mais!</p>
      <a href="https://bsky.app/profile/zoedsoupe.zeetech.io" target="_blank" class="link">
        Me encontre no BlueSky
      </a>
      <footer>&copy; 2024 ZEETECH. Todos os direitos reservados.</footer>
    </main>
    """
  end
end
