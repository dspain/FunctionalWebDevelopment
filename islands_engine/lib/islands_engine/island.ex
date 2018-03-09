defmodule IslandsEngine.Island do
  @moduledoc """
  Documentation for IslandsEngine.Island
  """
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  @doc """
  Create a new island
  """
  def new(), do: %Island{coordinates: MapSet.new(), hit_coordinates: MapSet.new()}
end
