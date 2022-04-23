defmodule WebFTPWeb.StaticPageController do
  use WebFTPWeb, :controller

  def download(conn, %{"file" => filename, "path" => path}) do
    IO.inspect path
    dl = rebuild_path_download(path, filename)

    if dl != :nil do
      send_download(conn, {:file, dl})
    else
      text(conn, "no")
    end
  end

  def rebuild_path_download(path, filename) do
    new_path = Application.get_env(:webftp,:root_folder_path) <> path <> "/" <> filename
    cond do
      String.contains?(new_path, "..") -> :nil
      !File.exists?(new_path) -> :nil
      true -> new_path
    end
  end

  def upload(conn, %{"file" => file, "path" => path}) do
    dl = rebuild_path_upload(path, file.filename)
    File.cp(file.path,dl)

    text(conn, "ok")
  end

  def rebuild_path_upload(path, filename) do
    new_path = Application.get_env(:webftp,:root_folder_path) <> path <> "/" <> filename
    cond do
      String.contains?(new_path, "..") -> :nil
      File.exists?(new_path) -> :nil
      true -> new_path
    end
  end
end
