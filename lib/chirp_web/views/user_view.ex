defmodule ChirpWeb.UserView do
  use ChirpWeb, :view
  alias Chirp.User

  def first_name(%User{name: name}) do
    name |> String.split(" ") |> Enum.at(0)
  end
end
