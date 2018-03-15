defmodule IslandsEngine.Rules do
  alias __MODULE__

  defstruct state: :initialized

  def new(), do: %Rules{}
end
