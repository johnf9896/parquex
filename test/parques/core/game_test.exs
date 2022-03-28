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

      refute is_nil(game.id)
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

  describe "remove_player/2" do
    setup [:game, :full_of_players]

    test "removes a player", %{game: game} do
      player_to_remove = Enum.random(game.players)

      game = Game.remove_player(game, player_to_remove)

      assert length(game.players) == Game.max_players() - 1

      for player <- game.players do
        assert player.id != player_to_remove.id
      end
    end

    test "can remove all players in any order", %{game: game} do
      players_to_remove = Enum.shuffle(game.players)

      game =
        Enum.reduce(players_to_remove, game, fn player, game ->
          Game.remove_player(game, player)
        end)

      assert game.players == []
    end
  end

  defp game(_context) do
    {:ok, game: build(:game)}
  end

  defp full_of_players(%{game: game}) do
    {:ok, game: with_players(game)}
  end
end
