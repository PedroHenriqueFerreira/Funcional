defmodule ChirpWeb.PostLive.PostComponent do
  use ChirpWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @post.id %>" class="post">
      <div class="row">
        <div class="column column-10">
          <div class="post-avatar">
            <img src="https://avatarfiles.alphacoders.com/103/103373.png" height="32" alt="<%= @post.username %>">
          </div>
        </div>
        <div class="column column-90 post-body">
          <b>@<%= @post.username %></b>
          <br/>
          <%= @post.body %>
        </div>
      </div>

      <div class="row">
        <div class="column">
          <a href="#" phx-click="like" phx-target="<%= @myself %>">
            <i class="far fa-heart"></i> <%= @post.likes_count %>
          </a>
        </div>
        <div class="column">
          <a href="#" phx-click="repost" phx-target="<%= @myself %>">
            <i class="fa fa-retweet"></i> <%= @post.reposts_count %>
          </a>
        </div>
        <div class="column">
          <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
            <i class="far fa-edit"></i>
          <% end %>
          <span>  </span>
          <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Remover?"] do %>
            <i class="far fa-trash-alt" onclick="carrega()"></i>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("like", _, socket) do
    Chirp.Timeline.inc_likes(socket.assigns.post)

    {:noreply, socket}
  end

  def handle_event("repost", _, socket) do
    Chirp.Timeline.inc_reposts(socket.assigns.post)

    {:noreply, socket}
  end
end
