defmodule Remote.Users do
  @moduledoc """
  The Users context.
  """

  alias Remote.Users.GenServer

  defdelegate get_at_most_two_users_with_more_than_max_points, to: GenServer
end
