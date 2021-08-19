defmodule RemoteWeb.UserControllerTest do
  use RemoteWeb.ConnCase

  alias Remote.Users

  @low_attrs %{
    points: 10
  }
  @high_attrs %{
    points: 90
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_users]
    test "lists at most two users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      response = json_response(conn, 200)
      assert response["timestamp"] == nil
      assert length(response["users"]) == 2
    end
  end

  defp create_users(_) do
    for _ <- 1..3 do
      {:ok, _user} = Users.create_user(@low_attrs)
      {:ok, _user} = Users.create_user(@high_attrs)
    end
  end
end
