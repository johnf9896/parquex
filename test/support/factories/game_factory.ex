defmodule Parques.Factory.GameFactory do
  @moduledoc false
  alias Parques.Core.Game

  defmacro __using__(_opts) do
    quote do
      def game_factory do
        %Game{
          id: UUID.uuid4(),
          players: []
        }
      end
    end
  end
end
