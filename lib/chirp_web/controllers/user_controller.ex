defmodule ChirpWeb.UserController do
  use ChirpWeb, :controller
  alias Chirp.Repo
  alias Chirp.User

  plug :authenticate_user when action in [:index, :show, :edit]

  def get_user!(id), do: Repo.get!(User, id)

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    usuario = Repo.get(User, id)
    render conn, "show.html", user: usuario
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    user_exists = Repo.get_by(User, username: changeset.changes.username)

    cond do
      user_exists ->
        conn
          |> put_flash(:error, "Usuário já existente no sistema")
          |> render("new.html", changeset: changeset)
      true ->
        case Repo.insert(changeset) do
          {:ok, user} ->
            conn
              |> ChirpWeb.AuthController.login(user)
              |> put_flash(:info, "Usuário #{user.name} criado com sucesso")
              |> redirect(to: Routes.page_path(conn, :index))

          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    %{ "user_id" => user_id } = get_session(conn)

    user = Repo.get(User, id)

    cond do
      (user.id != user_id) ->
        conn
        |> put_flash(:error, "Usuário não pode ser deletado por terceiros")
        |> redirect(to: Routes.user_path(conn, :index))

      true ->
        case user do
          nil ->
            conn
            |> put_flash(:error, "Usuário não encontrado")
            |> redirect(to: Routes.user_path(conn, :index))

          user ->
            Repo.delete(user)
            conn
            |> put_flash(:info, "Usuário deletado com sucesso")
            |> redirect(to: Routes.user_path(conn, :index))
        end
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, %{})

    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    %{ "user_id" => user_id } = get_session(conn)

    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    cond do
      (user.id != user_id) ->
        conn
          |> put_flash(:error, "Usuário não pode ser atualizado por terceiros")
          |> redirect(to: Routes.user_path(conn, :show, user))

      true ->
        case Repo.update(changeset) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "Usuário atualizado com sucesso")
            |> redirect(to: Routes.user_path(conn, :show, user))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end
    end
  end
end
