defmodule DistributedTaskTest do
  use ExUnit.Case
  doctest DistributedTask

  test "greets the world" do
    assert DistributedTask.hello() == :world
  end
end
