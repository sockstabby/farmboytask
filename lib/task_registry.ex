defmodule HordeTaskRouter.TaskRegistry do
  use Horde.Registry

  def start_link(_) do
    #Horde.Registry.start_link(__MODULE__, [keys: :unique], name: __MODULE__)

    name = "task_registry"
    Horde.Registry.start_link(__MODULE__, [keys: :unique], name: via_tuple(name))

  end

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.Registry.init()
  end

  defp members() do
    Enum.map([Node.self() | Node.list()], &{__MODULE__, &1})
  end

  def via_tuple(name), do: {:via, Horde.Registry, {HordeTaskRouter.TaskRegistry, name}}

end