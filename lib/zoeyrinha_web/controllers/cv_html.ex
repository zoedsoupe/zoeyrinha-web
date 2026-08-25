defmodule ZoeyrinhaWeb.CVHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <main class="min-h-screen px-4 sm:px-6 lg:px-8 py-16">
      <div class="max-w-3xl mx-auto">
        <header class="mb-12">
          <p class="font-mono text-pink mb-2">/cv</p>
          <h1 class="text-4xl md:text-5xl font-bold text-pink glitch-text">cv</h1>
        </header>

        <div class="prose">
          {raw(@html)}
        </div>
      </div>
    </main>
    """
  end
end
