defmodule ExfileMemoryTest do
  use Exfile.BackendTest, [
    ExfileMemory.Backend, %{
    directory: "/",
    max_size: nil,
    hasher: Exfile.Hasher.Random
  }]
end
