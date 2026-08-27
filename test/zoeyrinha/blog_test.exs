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

  describe "series_for/2" do
    test "returns nil for posts not in a series" do
      assert Blog.series_for(Blog.get_post_by_id!("hello-world")) == nil
    end

    test "orders parts by date with a slug tiebreak and localizes titles" do
      post = Blog.get_post_by_id!("peri-learns-to-coerce")
      series = Blog.series_for(post, "pt_BR")

      assert series.name == "peri"

      assert Enum.map(series.posts, & &1.id) == [
               "650k-parse-dont-validate",
               "peri-learns-to-coerce"
             ]

      assert series.index == 1
      assert hd(series.posts).lang == "pt_BR"
    end
  end
end
