defmodule Parques.Factory.GameFactory do
  @moduledoc false
  alias Parques.Core.Game

  defmacro __using__(_opts) do
    quote do
      def game_factory do
        %Game{
          id: UUID.uuid4(),
          players: []
        }
      end

      def with_players(game, num_players \\ Game.max_players()) do
        players = build_list(num_players, :player)

        Enum.reduce(players, game, fn player, game ->
          Game.add_player(game, player)
        end)
      end
    end
  end
end
