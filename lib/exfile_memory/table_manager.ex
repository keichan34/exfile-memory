defmodule ExfileMemory.TableManager do
  @moduledoc """
  TableManager keeps track of a ETS table.
  """

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @doc """
  Returns the tid of the ets table the TableManager owns.
  """
  def table(table_manager) do
    GenServer.call(table_manager, :table)
  end

  ## Callbacks

  def init(_opts) do
    send(self, :initialize)
    {:ok, %{table_id: nil}}
  end

  def handle_info(:initialize, state) do
    rand = :crypto.rand_uniform(10_000, 99_999)
    table_id = :ets.new(:"exfilememory_#{rand}", [:public])
    state = put_in(state.table_id, table_id)
    {:noreply, state}
  end

  def handle_call(:table, _from, %{table_id: tid} = state) do
    {:reply, tid, state}
  end
end
