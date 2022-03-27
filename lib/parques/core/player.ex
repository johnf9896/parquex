defmodule Parques.Core.Player do
  @moduledoc """
  A Player represents player in the game.
  """
  use TypedStruct

  alias Parques.Core.Color

  typedstruct do
    field :name, String.t(), enforce: true
    field :color, Color.t()
  end

  @spec new(Enum.t()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
