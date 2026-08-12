defmodule Zoeyrinha.Bsky.FakeClient do
  @moduledoc """
  Test fake for Zoeyrinha.Bsky.Client. Stubs live in
  Application env :zoeyrinha, :bsky_fake_stubs, so tests using it must run
  with async: false. A stub value may be a plain value or a zero/one-arity
  function (called with the callback key) for counting or sequencing.
  """
  @behaviour Zoeyrinha.Bsky.Client

  def stub(key, value) do
    stubs = Application.get_env(:zoeyrinha, :bsky_fake_stubs, %{})
    Application.put_env(:zoeyrinha, :bsky_fake_stubs, Map.put(stubs, key, value))
  end

  def reset, do: Application.delete_env(:zoeyrinha, :bsky_fake_stubs)

  @impl true
  def login(_identifier, _password),
    do: respond(:login, {:ok, %{did: "did:fake:test", access_jwt: "fake-jwt"}})

  @impl true
  def create_post(_session, _title, _url),
    do: respond(:create_post, {:ok, "at://did:fake:test/app.bsky.feed.post/fake-rkey"})

  @impl true
  def get_thread(at_uri), do: respond({:get_thread, at_uri}, {:error, :not_stubbed})

  defp respond(key, default) do
    case Application.get_env(:zoeyrinha, :bsky_fake_stubs, %{}) |> Map.get(key, default) do
      fun when is_function(fun, 0) -> fun.()
      fun when is_function(fun, 1) -> fun.(key)
      value -> value
    end
  end
end
