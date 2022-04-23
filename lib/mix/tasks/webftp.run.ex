defmodule Mix.Tasks.WebFtp.Run do
   @moduledoc """
    Runs the simple \"Web FTP\" server.
    In the background, this command runs mix phx.server, but the first argument must be the path to where you want your files served. The rest of the arguments are passed directly to mix phx.server

    Usage: mix web_ftp.run <path to folder> [arguments to mix phx.server]
   """
   use Mix.Task

   @shortdoc "Runs the simple \"Web FTP\" server"
   def run(args) do
    cond do
      length(args) < 1 ->
        IO.puts("Too few arguments! Check mix help web_ftp.run")
      !File.exists?(Enum.at(args,0)) ->
        IO.puts("The folder you provided does not exist!")
      true ->
        path =
          Enum.at(args,0)
          |> ensure_end_slash()

        Application.put_env(:webftp, :root_folder_path, path)
        Mix.Task.run("phx.server", Enum.slice(args, 1..-1))
    end
   end

   def ensure_end_slash(path) do
    if !String.ends_with?(path, "/") or !String.ends_with?(path, "\\") do
       path <> "/"
    else
      path
    end
   end
end
