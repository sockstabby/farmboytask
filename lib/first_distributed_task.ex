defmodule FirstDistributedTask do
  @moduledoc """
  Documentation for `FirstDistributedTask`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FirstDistributedTask.hello()
      :world

  """
  def hello(_args) do
    IO.puts("YAWN")
    #Process.sleep(1000 * 60 * 60)
    Process.sleep( 1000 * 60)

    IO.puts("awake now")

    :world
  end

  def local_func ([msg]) do
    IO.puts("hello there #{msg}")
    #raise "oops"
    :local_func
  end
end
