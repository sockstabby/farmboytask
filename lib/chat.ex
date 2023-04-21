defmodule Chat do
  def send_message() do
    #spawn_task("FirstDistributedTask", :local_func, :"foo@Erics-MacBook-Pro", [message])
    spawn_task("FirstDistributedTask", :local_func, :"foo@Erics-MacBook-Pro", [])
    #spawn_task("FirstDistributedTask", "local_func", :"foo@Erics-MacBook-Pro", [])


  end

  def spawn_task(module, fun, recipient, args) do
    recipient
    |> remote_supervisor()
    |> Task.Supervisor.async(module, fun, args)
    |> Task.await()
  end

  defp remote_supervisor(recipient) do
    {Chat.TaskSupervisor, recipient}
  end
end
