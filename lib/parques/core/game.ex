defmodule Parques.Core.Game do
  @moduledoc """
  A Game is the primary piece of data, representing a match of Parques.
  """
  use TypedStruct

  alias Parques.Core.Player

  typedstruct enforce: true do
    field :players, [Player.t()], default: []
  end

  @spec new(Enum.t()) :: t()
  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end
end
