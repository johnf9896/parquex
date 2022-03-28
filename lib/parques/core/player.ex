defmodule Parques.Core.Player do
  @moduledoc """
  A Player represents player in the game.
  """
  use TypedStruct

  import Parques.Core.Color, only: [is_color: 1]

  alias Parques.Core.Color

  @type id :: String.t()

  typedstruct enforce: true do
    field :id, id()
    field :name, String.t()
    field :color, Color.t(), enforce: false
  end

  @spec new(Enum.t()) :: t()
  def new(fields) do
    fields =
      fields
      |> Map.new()
      |> Map.put_new_lazy(:id, &UUID.uuid4/0)

    struct!(__MODULE__, fields)
  end

  @spec set_color(t(), Color.t()) :: t()
  def set_color(player, new_color) when is_color(new_color) do
    %__MODULE__{player | color: new_color}
  end
end
