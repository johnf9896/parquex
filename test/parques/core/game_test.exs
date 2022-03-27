defmodule Parques.Core.GameTest do
  @moduledoc false
  use Parques.Case, async: true

  alias Parques.Core.Game

  describe "new/1" do
    test "creates a game" do
      %Game{} = game = Game.new()

      assert game.players == []
    end
  end
end
