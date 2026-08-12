defmodule Zoeyrinha.Blog.Comments.Cache do
  @moduledoc """
  ETS cache for Bluesky comment threads. The GenServer owns the named table;
  callers read and write it directly, so fetches never serialize through a
  single process. Entries: {at_uri, inserted_at_ms, result} where result is
  {:ok, [Comment.t()]} | {:error, term()}. Success TTL 15 min, error TTL 60 s.
  """
  @behaviour GenServer

  alias Zoeyrinha.Blog.Comments
  alias Zoeyrinha.Bsky.Client

  @table __MODULE__
  @ttl_ok_ms :timer.minutes(15)
  @ttl_error_ms :timer.seconds(60)

  def child_spec(opts), do: %{id: __MODULE__, start: {__MODULE__, :start_link, [opts]}}

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @impl GenServer
  def init(_opts) do
    :ets.new(@table, [:named_table, :public, :set, read_concurrency: true])
    {:ok, nil}
  end

  @doc "Returns the comment tree for a thread AT-URI, from ETS when fresh, else fetched, parsed and cached. Errors are negative-cached for 60 s."
  @spec fetch(String.t()) :: {:ok, [Zoeyrinha.Blog.Comment.t()]} | {:error, term()}
  def fetch(at_uri) when is_binary(at_uri) do
    now = System.monotonic_time(:millisecond)

    case lookup(at_uri, now) do
      {:hit, result} -> result
      :miss -> load(at_uri, now)
    end
  end

  @doc "Test helper: drops all entries."
  @spec clear() :: :ok
  def clear, do: :ets.delete_all_objects(@table) && :ok

  defp lookup(at_uri, now) do
    case :ets.lookup(@table, at_uri) do
      [{^at_uri, inserted_at, result}] ->
        if now - inserted_at < ttl_for(result) do
          {:hit, result}
        else
          :ets.delete(@table, at_uri)
          :miss
        end

      [] ->
        :miss
    end
  end

  defp ttl_for({:ok, _}), do: @ttl_ok_ms
  defp ttl_for({:error, _}), do: @ttl_error_ms

  defp load(at_uri, now) do
    result =
      case Client.get_thread(at_uri) do
        {:ok, response} -> Comments.parse_thread(response)
        {:error, _} = error -> error
      end

    :ets.insert(@table, {at_uri, now, result})
    result
  end
end
