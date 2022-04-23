defmodule WebFTPWeb.IndexLive do
  use WebFTPWeb, :live_view

  def render(assigns) do
    Phoenix.View.render(WebFTPWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _, socket) do
    path = []
    socket = assign(socket, :path, path)
    socket = assign(socket, :files, get_files(path))

    if connected?(socket), do: Process.send_after(self(), :update, 1000)
    {:ok, push_event(socket, "navigate", %{})}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)

    path = socket.assigns[:path]
    socket = assign(socket, :files, get_files(path))

    {:noreply, push_event(socket, "navigate", %{})}
  end

  def handle_event("download", %{"path" => filename}, socket) do
    IO.puts("DOWNLOAD: " <> filename)
    {:noreply, socket}
  end

  def handle_event("navigate", %{"path" => foldername}, socket) do
    IO.puts("NAVIGATE: " <> foldername)
    path = socket.assigns[:path]
    files = socket.assigns[:files]
    path =
      if foldername == ".." do
        path |> Enum.reverse() |> tl() |> Enum.reverse()
      else
        if Enum.member?(files, {:folder, foldername}) do
          path ++ [foldername]
        else
          path
        end
      end
    socket = assign(socket, :path, path)
    socket = assign(socket, :files, get_files(path))

    {:noreply, push_event(socket, "navigate", %{})}
  end

  def get_files(path) do
    root = Application.get_env(:webftp,:root_folder_path)
    get_files(path, root)
  end
  defp get_files([h | tail], root) do
    get_files(tail, root <> h <> "/")
  end
  defp get_files([], root) do
    if File.exists?(root) do
      {:ok, files} = File.ls(root)
      files =
        Enum.map(files, fn x ->
          case File.ls(root <> x) do
            {:error, _} -> {:file, x}
            _ -> {:folder, x}
          end
        end)
      files
    else
      []
    end
  end

end
