defmodule Remote.Users do
  @moduledoc """
  The Users context.
  """

  alias Remote.Repo

  alias Remote.Users.GenServer
  alias Remote.Users.User

  defdelegate get_at_most_two_users_with_more_than_max_points, to: GenServer

  @doc """
  Returns the list of users.

  ## Examples

  iex> list_users()
  [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
