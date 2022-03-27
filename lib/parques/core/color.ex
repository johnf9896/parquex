defmodule Parques.Core.Color do
  @moduledoc """
  Defines the possible colors for players
  """

  @colors [:red, :green, :blue, :yellow]
  @count length(@colors)

  @type t :: :red | :green | :blue | :yellow

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

  defguard is_color(term) when term in @colors
end
