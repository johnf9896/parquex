defmodule Parques.Core.Color do
  @moduledoc """
  Defines the possible colors for players
  """

  @colors [:red, :green, :blue, :yellow]
  @count length(@colors)

  @type t :: :red | :green | :blue | :yellow

  defguard is_color(term) when term in @colors

  @spec count :: pos_integer()
  def count, do: @count

  @spec list :: [t()]
  def list, do: @colors

  @spec first :: t()
  def first, do: hd(@colors)

  @spec available([t()]) :: t() | nil
  def available(taken) when length(taken) <= @count do
    List.first(@colors -- taken)
  end

  @spec next([t()], t()) :: t()
  def next(colors, current) when is_color(current) do
    num_colors = length(colors)
    ordered_colors = Enum.filter(list(), &(&1 in colors))
    ^num_colors = length(ordered_colors)

    index = Enum.find_index(ordered_colors, &(&1 == current))
    next_index = rem(index + 1, num_colors)
    Enum.at(ordered_colors, next_index)
  end
end
