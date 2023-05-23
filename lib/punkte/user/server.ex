defmodule Punkte.User.Server do
  use GenServer

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

    Task.async(fn -> Punkte.User.Evaluate.call() end)

    {:noreply, Map.merge(state, %{max_number: generate_random()})}
  end

  @impl true
  def handle_call(:fetch, _from, %{max_number: max_number, timestamp: timestamp} = state) do
    {:reply, [timestamp, Punkte.User.Fetch.call(max_number)],
     Map.merge(state, %{timestamp: now!()})}
  end

  @impl true
  def handle_call(:reset, _f, _s) do
    {:reply, :ok, initial_state()}
  end

  def fetch, do: GenServer.call(__MODULE__, :fetch)
  def reset, do: GenServer.call(__MODULE__, :reset)

  defp now! do
    DateTime.utc_now()
  end

  defp generate_random do
    Enum.random(Punkte.User.points_interval())
  end

  defp initial_state do
    %{max_number: 0, timestamp: nil}
  end

  defp schedule_work do
    Process.send_after(self(), :evaluate, interval())
  end

  defp interval do
    Application.fetch_env!(punkte:, :interval)
  end
end
