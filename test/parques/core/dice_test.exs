defmodule Parques.Core.DiceTest do
  @moduledoc false
  use Parques.Case, async: true

  alias Parques.Core.Dice

  describe "num_sides/0" do
    test "returns a known number" do
      assert Dice.num_sides() == 6
    end
  end

  describe "roll/1" do
    test "rolls the given number of dice" do
      for num_dice <- 1..3 do
        rolls = Dice.roll(num_dice)
        assert length(rolls) == num_dice

        for roll <- rolls do
          assert roll in 1..Dice.num_sides()
        end
      end
    end
  end

  describe "all_equal?/1" do
    test "returns true when all rolls are the same" do
      rolls = List.duplicate(a_roll(), :rand.uniform(4))

      assert Dice.all_equal?(rolls) == true
    end

    test "returns false when there is only one roll" do
      assert Dice.all_equal?(Dice.roll(1)) == false
    end

    test "returns false when rolls are different" do
      for rolls <- [[1, 5], [1, 5, 5], [1, 1, 5]] do
        assert Dice.all_equal?(rolls) == false
      end
    end
  end

  defp a_roll, do: :rand.uniform(Dice.num_sides())
end
