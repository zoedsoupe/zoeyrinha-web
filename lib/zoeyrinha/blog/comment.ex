defmodule Zoeyrinha.Blog.Comment do
  @moduledoc "A single comment parsed from a Bluesky thread reply."

  @type segment ::
          {:text, String.t()}
          | {:link, String.t(), uri :: String.t()}
          | {:mention, String.t(), did :: String.t()}

  @type t :: %__MODULE__{
          uri: String.t() | nil,
          url: String.t() | nil,
          text: String.t(),
          segments: [segment()],
          created_at: DateTime.t() | nil,
          author_handle: String.t() | nil,
          author_display_name: String.t() | nil,
          author_avatar: String.t() | nil,
          author_did: String.t() | nil,
          like_count: non_neg_integer(),
          reply_count: non_neg_integer(),
          replies: [t()]
        }

  defstruct [
    :uri,
    :url,
    :created_at,
    :author_handle,
    :author_display_name,
    :author_avatar,
    :author_did,
    text: "",
    segments: [],
    like_count: 0,
    reply_count: 0,
    replies: []
  ]
end
