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

  defp some_color, do: Enum.random(Color.list())
end
