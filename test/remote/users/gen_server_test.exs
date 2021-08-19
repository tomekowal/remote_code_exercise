defmodule Remote.Users.GenServerTest do
  use Remote.DataCase

  alias Remote.Repo
  alias Remote.Users
  alias Remote.Users.User
  alias Remote.Users.GenServer, as: MyGenServer

  @low_attrs %{
    points: 10
  }
  @high_attrs %{
    points: 90
  }

  describe "get_at_most_two_users_with_more_than_max_points" do
    setup [:create_users]

    test "returns previous timestamp and updates internal timestamp value" do
      first_timestamp = DateTime.utc_now()

      {:reply, {^first_timestamp, _}, {_, second_timestamp}} =
        MyGenServer.handle_call(
          :get_at_most_two_users_with_more_than_max_points, self(), {50, first_timestamp}
        )

      refute first_timestamp == second_timestamp
    end

    test "returns max two users" do
      {:reply, {_, users}, {_, _}} =
        MyGenServer.handle_call(
          :get_at_most_two_users_with_more_than_max_points, self(), {50, nil}
        )

      assert length(users) <= 2
    end
  end

  describe "tick" do
    setup [:create_users_with_negative_points]

    test "updates users' points value" do
      {:noreply, {_, _}} =
        MyGenServer.handle_info(
          :tick, {50, nil}
        )

      for user <- Users.list_users() do
        assert user.points >= 0
        assert user.points <= 100
      end
    end
  end

  defp create_users(_) do
    for _ <- 1..3 do
      {:ok, _user} = Users.create_user(@low_attrs)
      {:ok, _user} = Users.create_user(@high_attrs)
    end
  end

  # add broken data that is out of range of 0 to 100 to make it easy to test random values
  defp create_users_with_negative_points(_) do
    Repo.insert_all(User, List.duplicate(%{points: -1, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}, 3))
    :ok
  end
end
