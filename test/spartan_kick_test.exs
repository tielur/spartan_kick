defmodule SpartanKickTest do
  use ExUnit.Case
  doctest SpartanKick

  test "greets the world" do
    assert SpartanKick.hello() == :world
  end
end
