defmodule Chirp.Repo do
  use Ecto.Repo,otp_app: :chirp,adapter: Ecto.Adapters.Postgres

  alias Chirp.Usuario

  def tudo(Usuario) do
    [%Usuario{id: "1", name: "Lucas Warley", username: "Lucas", password: "123"},
    %Usuario{id: "2", name: "João das Neves", username: "Neves", password: "1234"}]
  end

  def tudo(_module), do: []


  def pega_by_id(module, id) do
    Enum.find tudo(module), fn map -> map.id == id end
  end

  # def pegar_by_value(module,paams) do
  #   users = todos(module)
  #   Enum.find users, fn u -> Enum.all?(params, fn {key, val} -> Map.get(u, key) == val end)
  #   end
  # end

end
