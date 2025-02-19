defmodule ChirpWeb.LogoutController do
  use ChirpWeb, :controller
  alias ChirpWeb.AuthController

  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    conn
    |> AuthController.logout
    |> redirect(to: "/users/new")
  end

end
