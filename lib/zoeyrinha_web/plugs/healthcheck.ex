defmodule ZoeyrinhaWeb.Healthcheck do
  @moduledoc """
  Plug to handle the API Health Check.
  """

  import Plug.Conn

  def init(options), do: options

  def call(%Plug.Conn{request_path: "/health"} = conn, _opts) do
    conn
    |> send_resp(200, Jason.encode!(check_health()))
    |> put_resp_header("content-type", "application/json")
    |> halt()
  end

  def call(conn, _opts), do: conn

  defp check_health do
    %{
      status: "ok",
      message: "Sistema operacional e estável. Continuamos evitando mutações! 💻",
      uptime: get_uptime(),
      joke: "Qual é o superpoder do código funcional? Ele nunca envelhece, é imutável! 🚀"
    }
  end

  defp get_uptime do
    {milliseconds, _} = :erlang.statistics(:wall_clock)
    seconds = div(milliseconds, 1000)
    format_time(seconds)
  end

  defp format_time(total_seconds) do
    days = div(total_seconds, 86_400)
    hours = div(rem(total_seconds, 86_400), 3600)
    minutes = div(rem(total_seconds, 3600), 60)
    seconds = rem(total_seconds, 60)

    "#{days} days, #{hours} hours, #{minutes} minutes, #{seconds} seconds"
  end
end
