defmodule IslandsEngine.Board do
  @moduledoc """
  Description of `IslandsEngine.Board`
  """

  alias IslandsEngine.Island

  @doc """
  Create a new board
  """
  def new(), do: %{}

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> Map.put(board, key, island)
    end
  end
end
