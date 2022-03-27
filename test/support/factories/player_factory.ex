defmodule Parques.Factory.PlayerFactory do
  @moduledoc false
  alias Parques.Core.Player

  defmacro __using__(_opts) do
    quote do
      def player_factory do
        %Player{
          name: sequence(:player_name, &"John Doe #{&1}")
        }
      end
    end
  end
end
