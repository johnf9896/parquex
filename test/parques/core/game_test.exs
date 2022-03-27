defmodule Parques.Core.GameTest do
  @moduledoc false
  use Parques.Case, async: true

  import Parques.Core.Color, only: [is_color: 1]

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

  describe "add_player/2" do
    setup [:game]

    test "adds a player", %{game: game} do
      player = build(:player)
      game = Game.add_player(game, player)

      assert [added_player] = game.players

      assert added_player.name == player.name
      assert is_color(added_player.color)
    end

    test "every players has a different color", %{game: game} do
      players = build_list(Game.max_players(), :player)

      game =
        Enum.reduce(players, game, fn player, game ->
          Game.add_player(game, player)
        end)

      assert length(game.players) == Game.max_players()

      # Color are assigned in the same order as the list
      assert Enum.map(game.players, & &1.color) == Color.list()
    end
  end

  defp game(_context) do
    {:ok, game: build(:game)}
  end
end
