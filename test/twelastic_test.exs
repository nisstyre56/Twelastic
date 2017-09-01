defmodule twelastic do
  use ExUnit.Case
  doctest twelastic

  test "greets the world" do
    assert twelastic.hello() == :world
  end
end
