defmodule ChirpWeb.PostLive.Index do
  use ChirpWeb, :live_view

  alias Chirp.Timeline
  alias Chirp.Timeline.Post

  alias ChirpWeb.UserController

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Timeline.subscribe()

    socket =
      socket
      |> assign(:current_user, get_current_user(session) || nil)
      |> assign(:posts, list_posts())

    {:ok, socket}
  end

  defp get_current_user(session) do
    case session["user_id"] do
      nil -> nil
      user_id -> UserController.get_user!(user_id)
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Criar Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  def handle_info({:post_updated, updated_post}, socket) do
    {:noreply, update(socket, :posts, fn posts ->
      for post <- posts do
        case post.id == updated_post.id do
          true -> updated_post
          _ -> post
        end
      end
    end
    )}
  end

  def handle_info({:post_deleted, deleted_post}, socket) do
    {:noreply,
     update(socket, :posts, fn posts ->
       posts
       |> Enum.reject(fn post ->
         post.id == deleted_post.id
       end)
     end)}
  end

  defp list_posts do
    Timeline.list_posts()
  end
end
