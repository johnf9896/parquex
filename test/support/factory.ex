defmodule Parques.Factory do
  @moduledoc false
  use ExMachina

  use Parques.Factory.GameFactory
  use Parques.Factory.PlayerFactory
end
