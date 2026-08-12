defmodule Zoeyrinha.Blog.Comments.CacheTest do
  use ExUnit.Case, async: false

  alias Zoeyrinha.Blog.Comment
  alias Zoeyrinha.Blog.Comments.Cache
  alias Zoeyrinha.Bsky.FakeClient

  @table Cache
  @at_uri "at://did:fake:test/app.bsky.feed.post/cache-test"

  setup do
    FakeClient.reset()
    Cache.clear()
    {:ok, counter} = Agent.start_link(fn -> 0 end)
    %{counter: counter}
  end

  test "a miss fetches through the client and caches the parsed comments", %{counter: counter} do
    FakeClient.stub({:get_thread, @at_uri}, fn ->
      Agent.update(counter, &(&1 + 1))
      {:ok, %{thread: %{replies: [reply_node("bob")]}}}
    end)

    assert {:ok, [%Comment{author_handle: "bob.bsky.social"}]} = Cache.fetch(@at_uri)
    assert {:ok, [%Comment{author_handle: "bob.bsky.social"}]} = Cache.fetch(@at_uri)
    assert Agent.get(counter, & &1) == 1
  end

  test "errors are returned and negative-cached", %{counter: counter} do
    FakeClient.stub({:get_thread, @at_uri}, fn ->
      Agent.update(counter, &(&1 + 1))
      {:error, :boom}
    end)

    assert {:error, :boom} = Cache.fetch(@at_uri)
    assert {:error, :boom} = Cache.fetch(@at_uri)
    assert Agent.get(counter, & &1) == 1
  end

  test "expired success entries are re-fetched", %{counter: counter} do
    now = System.monotonic_time(:millisecond)
    :ets.insert(@table, {@at_uri, now - :timer.minutes(16), {:ok, []}})

    FakeClient.stub({:get_thread, @at_uri}, fn ->
      Agent.update(counter, &(&1 + 1))
      {:ok, %{thread: %{replies: [reply_node("bob")]}}}
    end)

    assert {:ok, [%Comment{}]} = Cache.fetch(@at_uri)
    assert Agent.get(counter, & &1) == 1
  end

  test "expired error entries are re-fetched", %{counter: counter} do
    now = System.monotonic_time(:millisecond)
    :ets.insert(@table, {@at_uri, now - :timer.seconds(61), {:error, :old}})

    FakeClient.stub({:get_thread, @at_uri}, fn ->
      Agent.update(counter, &(&1 + 1))
      {:error, :boom}
    end)

    assert {:error, :boom} = Cache.fetch(@at_uri)
    assert Agent.get(counter, & &1) == 1
  end

  test "fresh entries are served without hitting the client" do
    now = System.monotonic_time(:millisecond)
    :ets.insert(@table, {@at_uri, now, {:ok, []}})

    # no stub: a client call would return {:error, :not_stubbed}
    assert {:ok, []} = Cache.fetch(@at_uri)
  end

  test "clear/0 empties the table" do
    now = System.monotonic_time(:millisecond)
    :ets.insert(@table, {@at_uri, now, {:ok, []}})

    assert :ok = Cache.clear()
    assert :ets.lookup(@table, @at_uri) == []
  end

  defp reply_node(handle) do
    %{
      post: %{
        uri: "at://did:plc:#{handle}/app.bsky.feed.post/rep1",
        author: %{handle: "#{handle}.bsky.social", did: "did:plc:#{handle}"},
        record: %{text: "hi", created_at: "2026-08-01T11:00:00.000Z"}
      },
      replies: []
    }
  end
end
