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
        roll = Dice.roll(num_dice)
        assert length(roll) == num_dice

        for roll <- roll do
          assert roll in 1..Dice.num_sides()
        end

        assert Dice.is_roll(roll)
      end
    end
  end

  describe "all_equal?/1" do
    test "returns true when all rolls are the same" do
      roll = List.duplicate(a_roll(), Enum.random(2..4))

      assert Dice.all_equal?(roll) == true
    end

    test "returns false when there is only one roll" do
      assert Dice.all_equal?(Dice.roll(1)) == false
    end

    test "returns false when rolls are different" do
      for roll <- [[1, 5], [1, 5, 5], [1, 1, 5]] do
        assert Dice.all_equal?(roll) == false
      end
    end
  end

  describe "is_roll/1" do
    for {roll, is_roll} <- [{[1, 2], true}, {[1], true}, {[], false}, {5, false}] do
      test "with #{inspect(roll)} returns #{is_roll}" do
        assert Dice.is_roll(unquote(roll)) == unquote(is_roll)
      end
    end
  end

  defp a_roll, do: :rand.uniform(Dice.num_sides())
end
