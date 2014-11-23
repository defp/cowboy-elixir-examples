defmodule HelloWorld.Supervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link({:local, __MODULE__}, __MODULE__, [])
    # Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    procs = []
    {:ok, {{:one_for_one, 10, 10}, procs}}
  end
end
