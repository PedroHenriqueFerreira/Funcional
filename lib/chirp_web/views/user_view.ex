defmodule ChirpWeb.UserView do
  use ChirpWeb, :view
  alias Chirp.Usuario

  def first_name(%Usuario{name: name}) do
    name |> String.split(" ") |> Enum.at(0)
  end
end
