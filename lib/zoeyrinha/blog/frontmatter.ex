defmodule Zoeyrinha.Blog.Frontmatter do
  @moduledoc """
  String surgery over the Elixir-map frontmatter of blog posts, used by
  dev-time tooling (`mix blog.announce`) to read and extend post metadata
  without touching the markdown body.
  """

  @doc "Evaluates the Elixir-map frontmatter block (everything before the first --- line). Dev-time tooling only."
  @spec attrs(String.t()) :: {:ok, map()} | {:error, :no_frontmatter | :invalid_frontmatter}
  def attrs(content) when is_binary(content) do
    lines = String.split(content, "\n")

    case Enum.find_index(lines, &(&1 == "---")) do
      nil ->
        {:error, :no_frontmatter}

      idx ->
        header = lines |> Enum.take(idx) |> Enum.join("\n")

        try do
          case Code.eval_string(header) do
            {%{} = attrs, _binding} -> {:ok, attrs}
            _ -> {:error, :invalid_frontmatter}
          end
        rescue
          _ -> {:error, :invalid_frontmatter}
        end
    end
  end

  @doc "Inserts `  key: \"value\",` before the closing } line of the frontmatter block. Pure string surgery; body untouched."
  @spec insert_attr(String.t(), atom(), String.t()) ::
          {:ok, String.t()} | {:error, :no_frontmatter | :invalid_frontmatter}
  def insert_attr(content, key, value)
      when is_binary(content) and is_atom(key) and is_binary(value) do
    lines = String.split(content, "\n")

    with sep when is_integer(sep) <- Enum.find_index(lines, &(&1 == "---")),
         header <- Enum.take(lines, sep),
         rest <- Enum.drop(lines, sep),
         rev_idx when is_integer(rev_idx) <- Enum.find_index(Enum.reverse(header), &(&1 == "}")) do
      close_idx = length(header) - 1 - rev_idx
      line = "  #{key}: #{inspect(value)},"

      header =
        header
        |> List.update_at(close_idx - 1, &ensure_trailing_comma/1)
        |> List.insert_at(close_idx, line)

      {:ok, (header ++ rest) |> Enum.join("\n")}
    else
      nil -> {:error, :no_frontmatter}
    end
  end

  # the attr before the insertion point needs a trailing comma for the
  # resulting map to still parse
  defp ensure_trailing_comma(line) do
    if String.ends_with?(line, ","), do: line, else: line <> ","
  end
end
