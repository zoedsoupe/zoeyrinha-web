defmodule Zoeyrinha.Blog.CommentsTest do
  use ExUnit.Case, async: true

  alias Zoeyrinha.Blog.Comment
  alias Zoeyrinha.Blog.Comments

  describe "parse_thread/1" do
    test "parses nested replies into a comment tree" do
      assert {:ok, [bob, dan]} = Comments.parse_thread(thread_fixture())

      assert %Comment{
               uri: "at://did:plc:bob/app.bsky.feed.post/rep1",
               url: "https://bsky.app/profile/did:plc:bob/post/rep1",
               text: "great post",
               author_handle: "bob.bsky.social",
               author_display_name: "Bob",
               author_avatar: "https://img/bob.png",
               author_did: "did:plc:bob",
               like_count: 3,
               reply_count: 1,
               created_at: %DateTime{}
             } = bob

      assert [carol] = bob.replies
      assert carol.text == "thanks"
      assert carol.author_display_name == nil
      assert carol.author_avatar == nil
      assert carol.like_count == 0
      assert carol.reply_count == 0
      assert carol.replies == []

      assert dan.text == "nice"
      # the notFoundPost nested under dan is dropped
      assert dan.replies == []
    end

    test "returns an empty list when the thread has no replies" do
      assert {:ok, []} = Comments.parse_thread(%{thread: %{replies: []}})
    end

    test "returns an error for malformed responses" do
      assert {:error, :invalid_thread} = Comments.parse_thread(%{})
      assert {:error, :invalid_thread} = Comments.parse_thread(%{thread: %{}})
    end
  end

  describe "segments/2" do
    test "text without facets is a single text segment" do
      assert [{:text, "hello world"}] = Comments.segments("hello world", [])
    end

    test "slices link facets on UTF-8 byte offsets, not char offsets" do
      text = "olá https://example.com ok"
      # "olá " is 5 bytes (á is 2 bytes); the URL is 19 bytes
      facet = %{
        index: %{byte_start: 5, byte_end: 24},
        features: [%{"$type": "app.bsky.richtext.facet#link", uri: "https://example.com"}]
      }

      assert [
               {:text, "olá "},
               {:link, "https://example.com", "https://example.com"},
               {:text, " ok"}
             ] = Comments.segments(text, [facet])
    end

    test "handles multibyte emoji before a span" do
      text = "🎉🎉 https://example.com"
      # two 4-byte emoji + space = 9 bytes
      facet = %{
        index: %{byte_start: 9, byte_end: 28},
        features: [%{"$type": "app.bsky.richtext.facet#link", uri: "https://example.com"}]
      }

      assert [
               {:text, "🎉🎉 "},
               {:link, "https://example.com", "https://example.com"}
             ] = Comments.segments(text, [facet])
    end

    test "mention facets carry the did" do
      text = "@alice.bsky.social hi"

      facet = %{
        index: %{byte_start: 0, byte_end: 18},
        features: [%{"$type": "app.bsky.richtext.facet#mention", did: "did:plc:alice"}]
      }

      assert [
               {:mention, "@alice.bsky.social", "did:plc:alice"},
               {:text, " hi"}
             ] = Comments.segments(text, [facet])
    end

    test "overlapping spans drop the later one" do
      text = "olá https://example.com ok"

      first = %{
        index: %{byte_start: 5, byte_end: 24},
        features: [%{"$type": "app.bsky.richtext.facet#link", uri: "https://example.com"}]
      }

      overlapping = %{
        index: %{byte_start: 10, byte_end: 26},
        features: [%{"$type": "app.bsky.richtext.facet#link", uri: "https://other.example"}]
      }

      assert [
               {:text, "olá "},
               {:link, "https://example.com", "https://example.com"},
               {:text, " ok"}
             ] = Comments.segments(text, [overlapping, first])
    end

    test "unknown facet types stay plain text" do
      text = "love #elixir"

      facet = %{
        index: %{byte_start: 5, byte_end: 12},
        features: [%{"$type": "app.bsky.richtext.facet#tag", tag: "elixir"}]
      }

      assert [{:text, "love #elixir"}] = Comments.segments(text, [facet])
    end

    test "out-of-bounds spans are dropped" do
      text = "short"

      facet = %{
        index: %{byte_start: 0, byte_end: 99},
        features: [%{"$type": "app.bsky.richtext.facet#link", uri: "https://example.com"}]
      }

      assert [{:text, "short"}] = Comments.segments(text, [facet])
    end
  end

  describe "post_url/1" do
    test "converts a post AT-URI to the bsky.app URL" do
      assert "https://bsky.app/profile/did:plc:alice/post/3k2abc" =
               Comments.post_url("at://did:plc:alice/app.bsky.feed.post/3k2abc")
    end

    test "returns nil on malformed input" do
      assert Comments.post_url("at://did:plc:alice/app.bsky.feed.like/3k2abc") == nil
      assert Comments.post_url("https://example.com") == nil
      assert Comments.post_url(nil) == nil
    end
  end

  defp thread_fixture do
    %{
      thread: %{
        post: %{
          uri: "at://did:plc:zoey/app.bsky.feed.post/root1",
          author: %{
            handle: "zoey.dev",
            display_name: "Zoey",
            avatar: "https://img/zoey.png",
            did: "did:plc:zoey"
          },
          record: %{text: "root post", facets: [], created_at: "2026-08-01T10:00:00.000Z"},
          like_count: 5,
          reply_count: 2
        },
        replies: [
          %{
            post: %{
              uri: "at://did:plc:bob/app.bsky.feed.post/rep1",
              author: %{
                handle: "bob.bsky.social",
                display_name: "Bob",
                avatar: "https://img/bob.png",
                did: "did:plc:bob"
              },
              record: %{text: "great post", facets: [], created_at: "2026-08-01T11:00:00.000Z"},
              like_count: 3,
              reply_count: 1
            },
            replies: [
              %{
                post: %{
                  uri: "at://did:plc:carol/app.bsky.feed.post/rep2",
                  author: %{handle: "carol.bsky.social", did: "did:plc:carol"},
                  record: %{text: "thanks", created_at: "2026-08-01T12:00:00.000Z"}
                },
                replies: []
              }
            ]
          },
          %{
            "$type": "app.bsky.feed.defs#blockedPost",
            uri: "at://did:plc:x/app.bsky.feed.post/blocked"
          },
          %{
            post: %{
              uri: "at://did:plc:dan/app.bsky.feed.post/rep3",
              author: %{handle: "dan.bsky.social", did: "did:plc:dan"},
              record: %{text: "nice", created_at: "2026-08-01T13:00:00.000Z"}
            },
            replies: [
              %{
                "$type": "app.bsky.feed.defs#notFoundPost",
                uri: "at://did:plc:y/app.bsky.feed.post/gone"
              }
            ]
          }
        ]
      }
    }
  end
end
