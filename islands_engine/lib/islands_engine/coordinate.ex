defmodule IslandsEngine.Coordinate do
  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  def new(row, col), do: {:ok, %Coordinate{row: row, col: col}}
end
