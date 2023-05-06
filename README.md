# FirstDistributedTask

**TODO: Add description**

## Installation

This is called from another node. we need to run the task supervsior here.

to start worker in dev mode
iex --name worker3@127.0.0.1 --cookie asdf -S mix

iex --name worker4@127.0.0.1 --cookie asdf -S mix

:memsup.get_system_memory_data

:cpu_sup.avg1
:cpu_sup.avg5
:cpu_sup.avg15

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `first_distributed_task` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:first_distributed_task, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/first_distributed_task>.
