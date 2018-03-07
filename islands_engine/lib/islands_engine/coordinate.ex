defmodule IslandsEngine.Coordinate do
  @moduledoc """
  Documentation for IslandsEngine.Coordinate
  """
  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  @doc """
  Creates a new coordinate.  Coordinate must have a row and column within
  the @board_range parameters.

  ## Examples

      iex> Coordinate.new(1,1)
      {:ok, %Coordinate{row: 1, col: 1}}

  """
  def new(row, col) when row in @board_range and col in @board_range,
    do: {:ok, %Coordinate{row: row, col: col}}

  def new(_row, _col), do: {:error, :invalid_coordinate}
end
