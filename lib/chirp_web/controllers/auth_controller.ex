defmodule ChirpWeb.AuthController do
  import Plug.Conn
  import Phoenix.Controller
  alias Chirp.User
  alias ChirpWeb.Router.Helpers, as: Routes

  alias Chirp.Repo

  @doc """
    Para que o Plug funciona, precisa:
    adicionar em router.ex:
      "plug ChirpWeb.Auth, repo: Chirp.Repo"
      no final do "pipeline :browser do"

    adicionar em chirp_web.ex: no final, interno  ao quote, nas macros: controller e router
      "import ChirpWeb.Auth, only: [authenticate_user: 2] # New import"
  """

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end
  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)
    assign(conn, :current_user, user)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
        |> put_flash(:error, "O login é requerido para acessar esta página")
        |> redirect(to: "/sessions/new")
        |> halt()
    end
  end

  def login(conn, user) do
    conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
      #configure_session(renew: true): gera nova session id para o cookie, previne session fixation attacks
  end

  def login_by_username_and_pass(conn, username, given_pass) do
      user = Repo.get_by(User, username: username)

      cond do
        user && Bcrypt.verify_pass(given_pass, user.password_hash) -> {:ok, login(conn, user)}
        user -> {:error, :unauthorized, conn}
        true ->
          #dummy_checkpw()
          #dummy_checkpw(): tempo variável, para dificultar "Ataque de Temporização"
          {:error, :not_found, conn}
      end
  end

  def logout(conn) do
    conn |> configure_session(drop: true)
  end

end
