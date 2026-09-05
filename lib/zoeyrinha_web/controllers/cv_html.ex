defmodule ZoeyrinhaWeb.CVHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <main class="min-h-screen px-4 sm:px-6 lg:px-8 py-16">
      <div class="max-w-3xl mx-auto">
        <header class="mb-12 flex items-start justify-between gap-6">
          <div>
            <p class="font-mono text-pink mb-2">/cv</p>
            <h1 class="text-4xl md:text-5xl font-bold text-pink glitch-text">cv</h1>
            <%!-- the page below is the stdout --%>
            <p class="mt-4 inline-flex items-center gap-2 border border-selection rounded px-3 py-1.5 font-mono text-sm text-gray-light">
              <span class="text-pink">$</span> whoami
            </p>
            <div>
              <button
                onclick="window.print()"
                class="cursor-pointer no-print mt-4 font-mono text-sm text-gray-light border border-selection rounded px-2.5 py-1.5 hover:text-pink hover:border-pink transition-colors"
              >
                {gettext("download pdf")}
              </button>
            </div>
          </div>
          <img
            src={~p"/images/cv-profile.png"}
            alt="zoey"
            class="w-24 h-24 sm:w-28 sm:h-28 rounded-full border border-selection shrink-0 object-cover object-top mr-6 sm:mr-10"
          />
        </header>

        <div class="prose">
          {raw(@html)}
        </div>
      </div>
    </main>
    """
  end
end
