defmodule Parques.Core.Game do
  @moduledoc """
  A Game is the primary piece of data, representing a match of Parques.
  """
  use TypedStruct

  alias Parques.Core.Color
  alias Parques.Core.Player

  @max_players Color.count()

  typedstruct enforce: true do
    field :name, String.t(), default: "New game"
    field :players, [Player.t()], default: []
  end

  @spec max_players :: pos_integer()
  def max_players, do: @max_players

  @spec new(Enum.t()) :: t()
  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end

  @spec set_name(t(), String.t()) :: t()
  def set_name(game, new_name) do
    %__MODULE__{game | name: new_name}
  end

  @spec add_player(t(), Player.t()) :: t()
  def add_player(%__MODULE__{players: players} = game, player)
      when length(players) < @max_players do
    player_with_color = Player.set_color(player, available_color(game))

    new_players = players ++ [player_with_color]
    %__MODULE__{game | players: new_players}
  end

  @spec available_color(t()) :: Color.t()
  defp available_color(game), do: Color.available(taken_colors(game))

  @spec taken_colors(t()) :: [Color.t()]
  defp taken_colors(%{players: players}), do: Enum.map(players, & &1.color)
end
