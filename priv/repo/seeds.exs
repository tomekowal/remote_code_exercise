# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Remote.Repo.insert!(%Remote.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Remote.Repo
alias Remote.Users.User

# Insert one million users in batches of 1000
# Because nobody has time for inserting them one by one
# but postgres can't handle too many parameters at the same time to insert all million at once
:timer.tc(fn ->
  for _ <- 1..1_000 do
    Repo.insert_all(
      User,
      List.duplicate(%{points: 0, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}, 1_000)
    )
  end
end)
