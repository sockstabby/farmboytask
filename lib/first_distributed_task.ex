defmodule FirstDistributedTask do

  alias Phoenix.PubSub


  def hello(args) do
    send_message("starting task")

    IO.puts("YAWN #{args}")
    Process.sleep(1000 * 60)
    IO.puts("awake now")

    send_message("ending task")
  end

  defp send_message(msg) do
    PubSub.broadcast(:tasks, "user:123", {:task_update, %{id: 123, msg: msg}})
  end
end
