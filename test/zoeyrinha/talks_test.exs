defmodule Zoeyrinha.TalksTest do
  use ExUnit.Case, async: true

  alias Zoeyrinha.Talks
  alias Zoeyrinha.Talks.Talk

  describe "all_talks/0" do
    test "lists talks newest first, hiding drafts" do
      talks = Talks.all_talks()

      assert Enum.all?(talks, &is_struct(&1, Talk))
      assert talks == Enum.sort_by(talks, & &1.date, {:desc, Date})
      refute Enum.any?(talks, & &1.draft)
    end
  end

  describe "build/3" do
    test "maps frontmatter attrs onto the struct, body becomes the summary" do
      talk =
        Talk.build("whatever.md", %{title: "t", event: "e", date: ~D[2026-01-01]}, "<p>hi</p>")

      assert %Talk{title: "t", event: "e", date: ~D[2026-01-01], body: "<p>hi</p>"} = talk
      refute talk.draft
    end
  end
end
