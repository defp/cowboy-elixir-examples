defmodule SwSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = []
    supervise(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 10)
  end
end