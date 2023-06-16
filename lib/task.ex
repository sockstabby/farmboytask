defmodule DistributedTask do
  alias Phoenix.PubSub
  require Logger

  @doc """
  This method is called from farmboy when we are scheduled to run.
  """
  def run(roomid, origin_node, id, method, args) do
    # here we would normally look at the id of the task and call the appropriate function for the
    # id passed in. Since we returned 3 task types in get_worker_details, we could be called with
    # id = 1, 2 or 3.

    send_message(id, method, "starting task", roomid, origin_node)

    Logger.debug("Worker Called #{inspect(args)}")
    send_message(id, method, "Walk the dog", roomid, origin_node)
    send_message(id, method, "Cut the grass", roomid, origin_node)
    send_message(id, method, "Clean the gutters", roomid, origin_node)
    send_message(id, method, "Making lunch", roomid, origin_node)
    send_message(id, method, "Going to sleep", roomid, origin_node)

    Process.sleep(String.to_integer(args) * 1000)
    Logger.debug("awake now")
    send_message(id, method, "All done", roomid, origin_node)
  end

  defp send_message(id, method, msg, roomid, origin_node) do
    me = Atom.to_string(node())

    PubSub.broadcast(
      :tasks,
      "tasklog",
      {:task_update,
       %{id: id, method: method, msg: msg, node: me, roomid: roomid, origin_node: origin_node}}
    )
  end

  @spec get_worker_details :: %{worker_registration: %{host: atom, items: [map, ...]}}
  @doc """
  This method is called from the farmboy as soon as this is loaded in the cluster.
  We'll return task meta information so a user can configure a task to run us.
  """
  def get_worker_details() do
    Logger.debug("get_worker_details")

    %{
      worker_registration: %{
        host: node(),
        items: [
          %{
            taskid: 1,
            task_display_name: "Do Stuff and Sleep",
            task_desc: "A description"
          },
          %{
            taskid: 2,
            task_display_name: "Pay Taxes",
            task_desc: "Pay Taxes Description"
          },
          %{
            taskid: 3,
            task_display_name: "Go To Meeting",
            task_desc: "Go To Meeting Description"
          }
        ]
      }
    }
  end

  @doc """
  This method is called periodically from farmboy once we are discovered in the cluster.
  Farmboy uses this information to find a node with the least load average to run ourself.
  """
  def get_worker_resources() do
    %{
      worker_resource_info: %{
        host: node(),
        avg1: :cpu_sup.avg1(),
        avg5: :cpu_sup.avg5(),
        avg15: :cpu_sup.avg15()
      }
    }
  end
end
