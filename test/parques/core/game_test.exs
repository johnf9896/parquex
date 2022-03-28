defmodule Parques.Core.GameTest do
  @moduledoc false
  use Parques.Case, async: true

  import Parques.Core.Color, only: [is_color: 1]

  require Parques.Core.Game

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
      assert game.players == %{}
      assert is_nil(game.creator)
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

  describe "is_game_player/2" do
    setup [:game, :player]

    test "returns true for a player in the game", %{game: game, player: player} do
      game = Game.add_player(game, player)

      assert Game.is_game_player(game, player) == true
    end

    test "returns false for a player not in the game", %{game: game, player: player} do
      assert Game.is_game_player(game, player) == false
    end
  end

  describe "players/1" do
    setup [:game, :full_of_players]

    test "returns the list of players sorted by color", %{game: game} do
      players = Game.players(game)
      assert length(players) == Color.count()

      for {player, color} <- Enum.zip(players, Color.list()) do
        assert player.color == color
      end
    end
  end

  describe "add_player/2" do
    setup [:game, :player]

    test "adds a player", %{game: game, player: player} do
      game = Game.add_player(game, player)

      assert [added_player] = Game.players(game)

      assert added_player.name == player.name
      assert is_color(added_player.color)
      assert game.color_map[added_player.color] == player.id
    end

    test "every players has a different color", %{game: game} do
      players = build_list(Game.max_players(), :player)

      game =
        Enum.reduce(players, game, fn player, game ->
          Game.add_player(game, player)
        end)

      assert map_size(game.players) == Game.max_players()

      # Color are assigned in the same order as the list
      assert Enum.map(Game.players(game), & &1.color) == Color.list()
    end

    test "adding a player again does nothing", %{game: game, player: player} do
      game =
        game
        |> Game.add_player(player)
        |> Game.add_player(%{player | name: "With another name"})

      assert get_player(game, player).name == player.name
    end

    test "creator is set when the first player is added", %{game: game, player: player} do
      assert is_nil(game.creator)
      assert game.players == %{}

      game = Game.add_player(game, player)
      assert game.creator.id == player.id
    end

    test "creator is kept when another player is added", %{game: game, player: player} do
      game = with_players(game, 1)
      creator = game.creator
      refute is_nil(creator)

      game = Game.add_player(game, player)
      assert game.creator == creator
    end
  end

  describe "remove_player/2" do
    setup [:game, :full_of_players]

    test "removes a player", %{game: game} do
      player_to_remove = random_player(game)

      game = Game.remove_player(game, player_to_remove)

      assert map_size(game.players) == Game.max_players() - 1

      refute Map.has_key?(game.players, player_to_remove.id)
    end

    test "can remove all players in any order", %{game: game} do
      players_to_remove = Enum.shuffle(game.players)

      game =
        Enum.reduce(players_to_remove, game, fn {_id, player}, game ->
          Game.remove_player(game, player)
        end)

      assert game.players == %{}
    end

    test "removing a non-existent player does nothing", %{game: game} do
      player_to_remove = random_player(game)

      game =
        game
        |> Game.remove_player(player_to_remove)
        |> Game.remove_player(player_to_remove)

      refute Map.has_key?(game.players, player_to_remove.id)
    end

    test "creator rights are passed when current creator leaves", %{game: game} do
      creator = game.creator

      game = Game.remove_player(game, creator)

      refute is_nil(game.creator)
      assert game.creator.id != creator.id
    end

    test "creator is unset when last player leaves" do
      game = build(:game) |> with_players(1)

      game = Game.remove_player(game, game.creator)
      assert game.players == %{}
      assert is_nil(game.creator)
    end
  end

  describe "set_player_color/3" do
    setup [:game]

    test "allows changing to an available color", %{game: game} do
      player = build(:player)
      game = Game.add_player(game, player)
      %{color: old_color} = get_player(game, player)

      another_color = Enum.random(Color.list() -- [old_color])

      game = Game.set_player_color(game, player, another_color)

      assert game.players[player.id].color == another_color

      # Color map is updated
      assert is_nil(game.color_map[old_color])
      assert game.color_map[another_color] == player.id
    end

    test "allows changing to a taken color (swap)", %{game: game} do
      game = with_players(game)
      [player1, player2] = random_players(game, 2)

      game = Game.set_player_color(game, player1, player2.color)
      new_player1 = get_player(game, player1)
      new_player2 = get_player(game, player2)

      assert new_player1.color == player2.color
      assert new_player2.color == player1.color

      # Color map is updated
      assert game.color_map[new_player1.color] == player1.id
      assert game.color_map[new_player2.color] == player2.id
    end
  end

  defp game(_context) do
    {:ok, game: build(:game)}
  end

  defp full_of_players(%{game: game}) do
    {:ok, game: with_players(game)}
  end

  defp player(_context) do
    {:ok, player: build(:player)}
  end

  defp get_player(game, player), do: game.players[player.id]

  defp random_player(game) do
    {_id, player} = Enum.random(game.players)
    player
  end

  defp random_players(game, count) do
    game.players |> Map.values() |> Enum.shuffle() |> Enum.take(count)
  end
end
