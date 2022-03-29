defmodule Parques.Core.ColorTest do
  @moduledoc false
  use Parques.Case, async: true

  require Parques.Core.Color

  alias Parques.Core.Color

  describe "is_color/1" do
    test "returns true for a color" do
      color = some_color()

      assert Color.is_color(color) == true
    end

    test "return false for something else" do
      assert Color.is_color(nil) == false
    end
  end

  describe "count/0" do
    test "returns the number of colors" do
      assert Color.count() == 4
    end
  end

  describe "list/0" do
    test "returns list of colors of known size" do
      colors = Color.list()

      assert length(colors) == Color.count()

      for color <- colors do
        assert is_atom(color)
      end
    end
  end

  describe "first/1" do
    test "returns the first color" do
      assert Color.first() == hd(Color.list())
      assert Color.first() == hd(Color.list())
    end
  end

  describe "available/1" do
    test "returns the first color when none is taken" do
      assert Color.available([]) == Color.first()
    end

    test "returns nil when all are taken" do
      assert Color.available(Color.list()) == nil
    end

    test "returns a color until none is available" do
      taken_color = some_color()

      returned_colors =
        for _i <- 1..(Color.count() - 1), reduce: [taken_color] do
          taken_colors ->
            another_color = Color.available(taken_colors)
            assert another_color not in taken_colors

            [another_color | taken_colors]
        end

      assert MapSet.new(returned_colors) == MapSet.new(Color.list())
    end
  end

  describe "next/2" do
    test "chooses the other when there are two colors" do
      colors = Color.list() |> Enum.shuffle() |> Enum.take(2)
      [first_color, second_color] = colors

      assert Color.next(colors, first_color) == second_color
      assert Color.next(colors, second_color) == first_color
    end

    test "every color in the list gives the next" do
      colors = Color.list() -- [some_color()]
      num_colors = length(colors)

      for {color, index} <- Enum.with_index(colors) do
        next_index = index + 1 - num_colors
        next_color = Enum.at(colors, next_index)
        assert Color.next(colors, color) == next_color
      end
    end
  end

  defp some_color, do: Enum.random(Color.list())
end
