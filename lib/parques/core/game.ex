defmodule Parques.Core.Game do
  @moduledoc """
  A Game is the primary piece of data, representing a match of Parqués.
  """
  use TypedStruct

  alias Parques.Core.Color
  alias Parques.Core.Player

  @max_players Color.count()

  @type id :: String.t()
  @type state :: :created | :playing | :finished

  typedstruct enforce: true do
    field :id, id()
    field :name, String.t(), default: "New game"
    field :state, state(), default: :created
    field :players, [Player.t()], default: []
  end

  @spec max_players :: pos_integer()
  def max_players, do: @max_players

  @spec new(Enum.t()) :: t()
  def new(fields \\ []) do
    fields =
      fields
      |> Map.new()
      |> Map.put_new_lazy(:id, &UUID.uuid4/0)

    struct!(__MODULE__, fields)
  end

  @spec set_name(t(), String.t()) :: t()
  def set_name(game, new_name) do
    %__MODULE__{game | name: new_name}
  end

  @spec add_player(t(), Player.t()) :: t()
  def add_player(%__MODULE__{players: players, state: :created} = game, player)
      when length(players) < @max_players do
    player_with_color = Player.set_color(player, available_color(game))

    new_players = players ++ [player_with_color]
    %__MODULE__{game | players: new_players}
  end

  @spec available_color(t()) :: Color.t()
  defp available_color(game), do: Color.available(taken_colors(game))

  @spec taken_colors(t()) :: [Color.t()]
  defp taken_colors(%{players: players}), do: Enum.map(players, & &1.color)

  @spec remove_player(t(), Player.t()) :: t()
  def remove_player(%__MODULE__{players: players} = game, player) do
    new_players = Enum.reject(players, &(&1.id == player.id))

    %__MODULE__{game | players: new_players}
  end
end
