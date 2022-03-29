defmodule Parques.Core.Dice do
  @moduledoc """
  Functions for dealing with dice
  """

  @num_sides 6

  @type roll :: nonempty_list(pos_integer())

  @spec num_sides :: pos_integer()
  def num_sides, do: @num_sides

  @spec roll(pos_integer()) :: roll()
  def roll(num_dice) when num_dice > 0 do
    Enum.map(1..num_dice, fn _ ->
      :rand.uniform(@num_sides)
    end)
  end

  @spec all_equal?(roll()) :: boolean()
  def all_equal?([_]), do: false
  def all_equal?([_ | _] = roll), do: Enum.all?(roll, &(&1 == hd(roll)))
end
