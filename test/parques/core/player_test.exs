defmodule Parques.Core.PlayerTest do
  @moduledoc false
  use Parques.Case, async: true

  alias Parques.Core.Color
  alias Parques.Core.Player

  describe "new/1" do
    test "creates a player" do
      %Player{} = player = Player.new(name: "John")

      refute is_nil(player.id)
      assert player.name == "John"
    end
  end

  describe "set_color/2" do
    setup [:player]

    test "changes the name of the player", %{player: player} do
      taken_colors = List.wrap(player.color)
      new_color = Enum.random(Color.list() -- taken_colors)

      player = Player.set_color(player, new_color)

      assert player.color == new_color
    end
  end

  defp player(_context) do
    {:ok, player: build(:player)}
  end
end
