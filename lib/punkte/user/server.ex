defmodule Punkte.User.Server do
  use GenServer

  require Logger

  def start_link(_state) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    schedule_work()

    {:ok, initial_state()}
  end

  @impl true
  def handle_info(:evaluate, state) do
    schedule_work()
    random_number = generate_random()

    Logger.info("Processing a new cycle, the new number is (#{random_number})")

    Task.start_link(fn -> Punkte.User.Evaluate.call() end)

    {:noreply, Map.merge(state, %{max_number: random_number})}
  end

  @impl true
  def handle_call(:fetch, _from, %{max_number: max_number, timestamp: timestamp} = state) do
    result = [timestamp, Punkte.User.Fetch.call(max_number)]

    {:reply, {:ok, result}, Map.merge(state, %{timestamp: now!()})}
  end

  # fetch/0 is just an alias to make code a bit clearer
  def fetch, do: GenServer.call(__MODULE__, :fetch)

  defp now! do
    DateTime.utc_now()
  end

  defp generate_random do
    Enum.random(points_interval())
  end

  defp initial_state do
    %{max_number: 0, timestamp: nil}
  end

  defp schedule_work do
    Process.send_after(self(), :evaluate, interval())
  end

  defp interval do
    Application.fetch_env!(:punkte, :interval)
  end

  defp points_interval do
    Application.fetch_env!(:punkte, :points_interval)
  end
end
