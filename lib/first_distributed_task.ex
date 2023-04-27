defmodule FirstDistributedTask do

  alias Phoenix.PubSub


  def hello(roomid, origin_node, args) do
    send_message("starting task", roomid, origin_node)

    IO.puts("YAWN #{IO.inspect(args)}")
    Process.sleep(1000 * 60)
    IO.puts("awake now")

    send_message("ending task", roomid, origin_node)
  end

  defp send_message(msg, roomid, origin_node) do
    me = Atom.to_string(node)
    PubSub.broadcast(:tasks, "user:123", {:task_update, %{id: 123, msg: msg, node: me, roomid: roomid, origin_node: origin_node}})
  end
end
