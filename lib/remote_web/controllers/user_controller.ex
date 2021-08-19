defmodule RemoteWeb.UserController do
  use RemoteWeb, :controller

  alias Remote.Users.GenServer

  action_fallback RemoteWeb.FallbackController

  def index(conn, _params) do
    {timestamp, users} = GenServer.get_at_most_two_users_with_more_than_max_points()
    render(conn, "index.json", users: users, timestamp: timestamp)
  end
end
