defmodule Zoeyrinha.Blog.FrontmatterTest do
  use ExUnit.Case, async: true

  alias Zoeyrinha.Blog.Frontmatter

  @content ~S"""
  %{
    title: "hello, world",
    description: "Why this blog exists.",
    tags: ~w(meta elixir)
  }
  ---
  Body here.

  A horizontal rule --- inside the body and a } brace stay untouched.
  """

  describe "attrs/1" do
    test "evaluates the frontmatter block into a map" do
      assert {:ok, attrs} = Frontmatter.attrs(@content)
      assert attrs.title == "hello, world"
      assert attrs.description == "Why this blog exists."
      assert attrs.tags == ["meta", "elixir"]
    end

    test "returns an error when there is no frontmatter separator" do
      assert {:error, :no_frontmatter} = Frontmatter.attrs("just markdown\nno separator")
    end

    test "returns an error when the header is not an Elixir map" do
      assert {:error, :invalid_frontmatter} = Frontmatter.attrs("not elixir at all (\n---\nbody")
      assert {:error, :invalid_frontmatter} = Frontmatter.attrs("[1, 2]\n---\nbody")
    end
  end

  describe "insert_attr/3" do
    test "inserts the attribute before the closing } line" do
      at_uri = "at://did:plc:x/app.bsky.feed.post/abc"

      assert {:ok, updated} = Frontmatter.insert_attr(@content, :bsky_thread, at_uri)

      assert updated =~ """
               tags: ~w(meta elixir)
               bsky_thread: "at://did:plc:x/app.bsky.feed.post/abc",
             }
             ---
             """
    end

    test "leaves the body byte-identical" do
      assert {:ok, updated} = Frontmatter.insert_attr(@content, :bsky_thread, "at://x/y/z")

      assert String.split(updated, "---", parts: 2) |> List.last() ==
               String.split(@content, "---", parts: 2) |> List.last()
    end

    test "returns an error when there is no frontmatter separator" do
      assert {:error, :no_frontmatter} =
               Frontmatter.insert_attr("just markdown", :bsky_thread, "at://x/y/z")
    end
  end
end
