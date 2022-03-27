defmodule Parques.Core.GameTest do
  @moduledoc false
  use Parques.Case, async: true

  alias Parques.Core.Color
  alias Parques.Core.Game

  describe "max_players/0" do
    test "returns the same as the number of colors" do
      assert Game.max_players() == Color.count()
    end
  end

  describe "new/1" do
    test "creates a game" do
      %Game{} = game = Game.new()

      assert is_binary(game.name)
      assert game.players == []
    end
  end

  describe "set_name/2" do
    setup [:game]

    test "changes the name of the game", %{game: game} do
      new_name = "A game with friends"
      game = Game.set_name(game, new_name)

      assert game.name == new_name
    end
  end

  defp game(_context) do
    {:ok, game: build(:game)}
  end
end
