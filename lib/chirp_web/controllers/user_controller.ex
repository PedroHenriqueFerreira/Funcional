defmodule ChirpWeb.UserController do
  use ChirpWeb, :controller
  alias Chirp.Repo
  alias Chirp.Usuario

  def index(conn, _params) do
    users = Repo.tudo(Usuario)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    usuario = Repo.pega_by_id(Usuario, id)
    render conn, "show.html", user: usuario
  end

end
