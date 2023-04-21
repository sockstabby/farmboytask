# lib/chat/application.ex
defmodule Chat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: BackgroundJob.ClusterSupervisor]]},
      #HordeTaskRouter.HordeRegistry,
      {Task.Supervisor, name: Chat.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      background_job: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
  end
end
