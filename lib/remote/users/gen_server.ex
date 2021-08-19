defmodule Remote.Users.GenServer do
  use GenServer
  alias Remote.Repo
  alias Remote.Users.User
  import Ecto.Query

  @one_minut_in_ms 60 * 1000

  # Client API
  def start_link(opts) do
    max_number = Keyword.get(opts, :max_number) || integer_from_zero_to_n_inclusive(100)
    last_query_time = Keyword.get(opts, :last_query_time) || nil
    GenServer.start_link(__MODULE__, {max_number, last_query_time}, opts)
  end

  def get_at_most_two_users_with_more_than_max_points() do
    GenServer.call(__MODULE__, :get_at_most_two_users_with_more_than_max_points)
  end

  # Callbacks
  @impl true
  def init(initial_state) do
    send(self(), :tick)
    # this is the only timer in the project so it is not worth to use `send_after`
    :timer.send_interval(@one_minut_in_ms, :tick)
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_at_most_two_users_with_more_than_max_points, _from, {max_number, last_query_time}) do
    at_most_two_users =
      (from u in User, where: u.points > ^max_number, limit: 2)
      |> Repo.all()
    {:reply, {last_query_time, at_most_two_users}, {max_number, DateTime.utc_now()}}
  end

  @impl true
  def handle_info(:tick, {_, last_query_time}) do
    (from u in User, [update: [set: [points: fragment("floor(random() * 101)::int")]]])
    |> Repo.update_all([])
    new_max_number = integer_from_zero_to_n_inclusive(100)
    {:noreply, {new_max_number, last_query_time}}
  end

  defp integer_from_zero_to_n_inclusive(n), do: :rand.uniform(n+1) - 1
end
