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
    %{game | name: new_name}
  end
end
