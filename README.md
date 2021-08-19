# Code Exercise for Remote

To test the solution, please start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Design log

  * I wouldn't usually call a GenServer just GenServer, but in this exercise, it makes sense
  * For more involved state, I'd use structs, but for just two pieces of data tuple is fine
  * I am injecting known state to GenServer state when `MIX_ENV=test` for easier testing
  * Normally, I'd also inject the interval because if the test suite runs more than one minute, the tick function could run in the middle of some test; but for a project with nine tests, this would be overkill
  * In `gen_server_test.exs`, I am injecting an impossible state: users with points = -1 so that it is easier to test the randomness
  * I am using `insert_all` instead of `insert` for bulk operations for speed. I didn't want to update a million users one by one
  * the exercise mentions port 3000, but I hope it is okay I left the default 4000
