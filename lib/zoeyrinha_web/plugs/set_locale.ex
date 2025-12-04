defmodule ZoeyrinhaWeb.Plugs.SetLocale do
  @moduledoc """
  Plug to set the Gettext locale based on the user's cookie preference.
  Falls back to the default locale (en) if no cookie is set.
  """
  import Plug.Conn

  @supported_locales Gettext.known_locales(ZoeyrinhaWeb.Gettext)
  @default_locale "en"

  def init(_opts), do: nil

  def call(conn, _opts) do
    locale =
      conn
      |> get_locale_from_cookie()
      |> validate_locale()

    Gettext.put_locale(ZoeyrinhaWeb.Gettext, locale)
    assign(conn, :locale, locale)
  end

  defp get_locale_from_cookie(conn) do
    conn
    |> fetch_cookies()
    |> Map.get(:cookies, %{})
    |> Map.get("locale")
  end

  defp validate_locale(locale) when locale in @supported_locales, do: locale
  defp validate_locale(_), do: @default_locale
end
