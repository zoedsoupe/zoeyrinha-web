defmodule ZoeyrinhaWeb.CommentsLive do
  @moduledoc """
  Embedded LiveView rendering a post's Bluesky comment thread.

  Mounted via `live_render` inside the dead-rendered post page: the article
  HTML ships immediately, the websocket mounts this view, and the thread
  loads asynchronously behind a skeleton. Failures offer a retry button
  instead of a broken section until the negative cache expires.
  """
  use ZoeyrinhaWeb, :live_view

  alias Zoeyrinha.Blog.Comment
  alias Zoeyrinha.Blog.Comments.Cache

  @impl true
  def mount(_params, %{"at_uri" => at_uri, "locale" => locale}, socket) do
    Gettext.put_locale(ZoeyrinhaWeb.Gettext, locale)

    {:ok, socket |> assign(:at_uri, at_uri) |> load_comments()}
  end

  @impl true
  def handle_event("retry", _params, socket) do
    {:noreply, load_comments(socket)}
  end

  defp load_comments(socket) do
    at_uri = socket.assigns.at_uri

    assign_async(socket, :comments, fn ->
      with {:ok, comments} <- Cache.fetch(at_uri) do
        {:ok, %{comments: comments}}
      end
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="comments-live">
      <.async_result :let={comments} assign={@comments}>
        <:loading>
          <div
            class="animate-pulse space-y-6"
            aria-busy="true"
            aria-label={gettext("loading comments")}
          >
            <div :for={_ <- 1..3} class="flex items-start gap-3">
              <div class="h-6 w-6 rounded-full bg-selection shrink-0" />
              <div class="flex-1 space-y-2">
                <div class="h-3 w-1/3 rounded bg-selection" />
                <div class="h-3 w-full rounded bg-selection" />
              </div>
            </div>
          </div>
        </:loading>
        <:failed>
          <div class="text-gray-light">
            {gettext("Comments are unavailable right now.")}
            <button
              type="button"
              phx-click="retry"
              class="font-mono text-sm text-pink hover:text-pink-soft cursor-pointer"
            >
              {gettext("retry")}
            </button>
          </div>
        </:failed>

        <p :if={comments == []} class="text-gray-light font-mono text-sm">
          {gettext("No comments yet.")}
        </p>

        <ol :if={comments != []} class="space-y-6">
          <.comment :for={comment <- comments} comment={comment} />
        </ol>
      </.async_result>
    </div>
    """
  end

  attr :comment, Comment, required: true

  defp comment(assigns) do
    ~H"""
    <li>
      <article>
        <header class="flex items-center gap-2 text-sm">
          <img
            :if={@comment.author_avatar}
            src={@comment.author_avatar}
            alt=""
            loading="lazy"
            decoding="async"
            class="h-6 w-6 rounded-full"
          />
          <span class="text-foreground">{@comment.author_display_name || @comment.author_handle}</span>
          <a
            :if={@comment.author_did}
            href={"https://bsky.app/profile/#{@comment.author_did}"}
            target="_blank"
            rel="noopener"
            class="font-mono text-gray-light"
          >
            @{@comment.author_handle}
          </a>
          <time :if={@comment.created_at} class="font-mono text-gray-light ml-auto">
            {Calendar.strftime(@comment.created_at, "%Y-%m-%d %H:%M")}
          </time>
        </header>

        <p class="whitespace-pre-wrap mt-2 text-foreground/90">
          <.segment :for={segment <- @comment.segments} segment={segment} />
        </p>

        <footer class="flex gap-4 mt-2 font-mono text-xs text-gray-light">
          <span>{@comment.like_count} likes</span>
          <span>{@comment.reply_count} replies</span>
          <a :if={@comment.url} href={@comment.url} target="_blank" rel="noopener" class="text-pink">
            view on Bluesky
          </a>
        </footer>
      </article>

      <ol :if={@comment.replies != []} class="mt-4 ml-4 pl-4 border-l border-selection space-y-6">
        <.comment :for={reply <- @comment.replies} comment={reply} />
      </ol>
    </li>
    """
  end

  attr :segment, :any, required: true

  defp segment(%{segment: {:text, _text}} = assigns) do
    ~H"{elem(@segment, 1)}"
  end

  defp segment(%{segment: {:link, _text, _url}} = assigns) do
    ~H"""
    <a href={elem(@segment, 2)} target="_blank" rel="noopener" class="text-pink">{elem(@segment, 1)}</a>
    """
  end

  defp segment(%{segment: {:mention, _text, _did}} = assigns) do
    ~H"""
    <a
      href={"https://bsky.app/profile/#{elem(@segment, 2)}"}
      target="_blank"
      rel="noopener"
      class="text-pink"
    >{elem(@segment, 1)}</a>
    """
  end
end
