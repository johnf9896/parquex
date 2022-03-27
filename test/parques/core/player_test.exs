defmodule Parques.Core.PlayerTest do
  @moduledoc false
  use Parques.Case, async: true

  alias Parques.Core.Player

  describe "new/1" do
    test "creates a player" do
      %Player{} = player = Player.new(name: "John")

      assert player.name == "John"
    end
  end
end
