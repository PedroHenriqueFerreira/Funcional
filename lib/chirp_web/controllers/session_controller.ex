defmodule ChirpWeb.SessionController do
  use ChirpWeb, :controller

  alias Chirp.Repo
  alias ChirpWeb.AuthController

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => password}}) do
    case AuthController.login_by_username_and_pass(conn, user, password, repo: Repo) do
        {:ok, conn} ->
          conn
          |> put_flash(:info, "Seja bem-vindo novamente")
          |> redirect(to: Routes.page_path(conn, :index))
        {:error, _reason, conn} ->
          conn
          |> put_flash(:error, "Usuário e/ou senha inválidos")
          |> render("new.html")
    end
  end

  def delete(conn, _) do
    #IO.inspect(conn)
    conn
    |> AuthController.logout
    |> redirect(to: Routes.page_path(conn, :index))
    #|> put_flash(:info, "Peace Out")
    #|> redirect(to: "/")
  end
end
