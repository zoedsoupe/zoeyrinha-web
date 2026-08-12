defmodule Zoeyrinha.Bsky.Client do
  @moduledoc "Seam over the Bluesky API. Real impl: Zoeyrinha.Bsky.ProtoRune; tests use Zoeyrinha.Bsky.FakeClient."

  @callback login(identifier :: String.t(), password :: String.t()) ::
              {:ok, session :: map()} | {:error, term()}
  @callback create_post(session :: map(), title :: String.t(), url :: String.t()) ::
              {:ok, at_uri :: String.t()} | {:error, term()}
  @callback get_thread(at_uri :: String.t()) :: {:ok, map()} | {:error, term()}

  @spec login(String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def login(identifier, password), do: impl().login(identifier, password)

  @spec create_post(map(), String.t(), String.t()) :: {:ok, String.t()} | {:error, term()}
  def create_post(session, title, url), do: impl().create_post(session, title, url)

  @spec get_thread(String.t()) :: {:ok, map()} | {:error, term()}
  def get_thread(at_uri), do: impl().get_thread(at_uri)

  # Read per call so test overrides take effect without recompilation.
  defp impl, do: Application.get_env(:zoeyrinha, :bsky_client, Zoeyrinha.Bsky.ProtoRune)
end
