defmodule WebFTPWeb.PageView do
  use WebFTPWeb, :view

  def getServerURL() do
    {:ok, url} = :inet.getif()

    url =
      url
      |> List.first |> elem(0)
      |> Tuple.to_list
      |> List.foldl("", fn x,acc -> acc <> "." <> Integer.to_string(x) end)
      |> String.slice(1..-1)

    url <> ":" <> Integer.to_string(Application.get_env(:web_ftp, WebFTPWeb.Endpoint)[:http][:port])
  end

  def path_to_string([h |  t]) do
    if t == [] do
      h
    else
      h <> "/" <> path_to_string(t)
    end

  end

  def path_to_string([]) do
    ""
  end
end

"""
defmodule DemoWeb.ThermostatLive do
  use Phoenix.LiveView
  ...

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 30000)

    case Thermostat.get_user_reading(user_id) do
      {:ok, temperature} ->
        {:ok, assign(socket, temperature: temperature, user_id: user_id)}

      {:error, _reason} ->
        {:ok, redirect(socket, to: "/error")}
    end
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 30000)
    {:ok, temperature} = Thermostat.get_reading(socket.assigns.user_id)
    {:noreply, assign(socket, :temperature, temperature)}
  end
end
"""
