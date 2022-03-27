defmodule Parques.Core.Player do
  @moduledoc """
  A Player represents player in the game.
  """
  use TypedStruct

  import Parques.Core.Color, only: [is_color: 1]

  alias Parques.Core.Color

  typedstruct do
    field :name, String.t(), enforce: true
    field :color, Color.t()
  end

  @spec new(Enum.t()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @spec set_color(t(), Color.t()) :: t()
  def set_color(player, new_color) when is_color(new_color) do
    %{player | color: new_color}
  end
end
