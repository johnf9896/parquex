defmodule Parques.Core.Game do
  @moduledoc """
  A Game is the primary piece of data, representing a match of Parques.
  """
  use TypedStruct

  alias Parques.Core.Player

  typedstruct enforce: true do
    field :name, String.t(), default: "New game"
    field :players, [Player.t()], default: []
  end

  @spec new(Enum.t()) :: t()
  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end

  @spec set_name(t(), String.t()) :: t()
  def set_name(game, new_name) do
    %{game | name: new_name}
  end
end
