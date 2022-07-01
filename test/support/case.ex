defmodule Parques.Case do
  @moduledoc """
  This module defines the test case to be used by tests by default.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Parques.Factory
    end
  end

  setup tags do
    Mimic.set_mimic_from_context(tags)
    Mimic.verify_on_exit!()
    :ok
  end
end
