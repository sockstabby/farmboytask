defmodule FirstDistributedTask do

  alias Phoenix.PubSub


  def hello(roomid, args) do
    send_message("starting task", roomid)



    IO.puts("YAWN #{IO.inspect(args)}")
    Process.sleep(1000 * 60)
    IO.puts("awake now")

    send_message("ending task", roomid)
  end

  defp send_message(msg, roomid) do
    me = Atom.to_string(node)
    PubSub.broadcast(:tasks, "user:123", {:task_update, %{id: 123, msg: msg, node: me, roomid: roomid}})
  end
end
