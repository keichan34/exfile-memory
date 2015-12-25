defmodule ExfileMemory do
  use Application

  @doc false
  def start(_type, _args) do
    ExfileMemory.Supervisor.start_link()
  end
end
