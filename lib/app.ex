# lib/chat/application.ex
defmodule Chat.Application do
  @moduledoc false
  use Application
  require Logger

  def start(_type, _args) do
    children_dev = [
      {Cluster.Supervisor, [topologies_gossip(), [name: BackgroundJob.ClusterSupervisorWorker]]},
      #Supervisor.child_spec({Cluster.Supervisor, [topologies_phoenix(), [name: BackgroundJob.ClusterSupervisorPhoenix]]} , id: :phoenix_cluster_sup),
      #Supervisor.child_spec({Cluster.Supervisor, [topologies_router(), [name: BackgroundJob.ClusterSupervisorRouter]]} , id: :router_cluster_sup),
      {Phoenix.PubSub, name: :tasks},
      {Task.Supervisor, name: Chat.TaskSupervisor}
    ]

    children_prod = [
      Supervisor.child_spec({Cluster.Supervisor, [topologies_phoenix(), [name: BackgroundJob.ClusterSupervisorPhoenix]]} , id: :phoenix_cluster_sup),
      Supervisor.child_spec({Cluster.Supervisor, [topologies_router(), [name: BackgroundJob.ClusterSupervisorRouter]]} , id: :router_cluster_sup),
      {Phoenix.PubSub, name: :tasks},
      {Task.Supervisor, name: Chat.TaskSupervisor}
    ]

    env = String.to_atom(System.get_env("MIX_ENV") || "dev")
    Logger.debug("env = #{env}")

    children = if env == :dev, do: children_dev, else: children_prod

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies_gossip do
    [
      background_job: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
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

  defp topologies_phoenix do
    [
      k8s_example: [
        strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "cluster-svc",
          application_name: "hello",
          polling_interval: 3_000
        ]
      ]
    ]
  end

  defp topologies_router do
    [
      k8s_example: [
        strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "cluster-svc",
          application_name: "task_router",
          polling_interval: 3_000
        ]
      ]
    ]
  end
end
