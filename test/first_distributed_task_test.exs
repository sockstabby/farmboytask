defmodule FirstDistributedTaskTest do
  use ExUnit.Case
  doctest FirstDistributedTask

  test "greets the world" do
    assert FirstDistributedTask.hello() == :world
  end
end
