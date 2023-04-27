# lib/chat/application.ex
defmodule Chat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: BackgroundJob.ClusterSupervisor]]},
      {Phoenix.PubSub, name: :tasks},
      {Task.Supervisor, name: Chat.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      k8s_example: [
        strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "cluster-svc",
          application_name: "worker",
          polling_interval: 3_000
        ]
      ]
    ]
  end
end
