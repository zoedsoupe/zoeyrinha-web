defmodule Zoeyrinha.BlogTest do
  use ExUnit.Case, async: true

  alias Zoeyrinha.Blog

  @bilingual_id "comments-from-the-atmosphere"

  describe "get_post_by_id!/2" do
    test "returns the English version by default" do
      post = Blog.get_post_by_id!(@bilingual_id)
      assert post.lang == "en"
    end

    test "returns the pt_BR version when requested" do
      post = Blog.get_post_by_id!(@bilingual_id, "pt_BR")
      assert post.lang == "pt_BR"
    end

    test "falls back to English for posts without a translation" do
      post = Blog.get_post_by_id!("hello-world", "pt_BR")
      assert post.lang == "en"
    end

    test "drafts raise a 404 even on a direct URL" do
      assert_raise Zoeyrinha.Blog.NotFoundError, fn ->
        Blog.get_post_by_id!("present-day-present-time")
      end
    end
  end

  describe "all_posts/1" do
    test "lists one entry per id" do
      ids = Enum.map(Blog.all_posts("pt_BR"), & &1.id)
      assert ids == Enum.uniq(ids)
    end

    test "prefers the requested locale when a translation exists" do
      post = Enum.find(Blog.all_posts("pt_BR"), &(&1.id == @bilingual_id))
      assert post.lang == "pt_BR"
    end
  end
end
