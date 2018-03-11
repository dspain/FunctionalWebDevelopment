defmodule IslandsEngine.Island do
  @moduledoc """
  Documentation for `IslandsEngine.Island`
  """
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  @doc """
  Create a new island using the valid island types (:square, :atoll, :dot, :l_shape, :s_shape),
  using an `IslandsEngine.Coordinate` for the upper left corner.

  ## Examples
      iex> {:ok, coordinate} = Coordinate.new(4,6)
      iex> Island.new(:l_shape, coordinate)
      {:ok,
       %Island{
         coordinates: [
           %Coordinate{col: 6, row: 4},
           %Coordinate{col: 6, row: 5},
           %Coordinate{col: 6, row: 6},
           %Coordinate{col: 7, row: 6}
         ] |> Enum.into(MapSet.new),
         hit_coordinates: Enum.into([], MapSet.new)
       }
      }
      iex> Island.new(:wrong, coordinate)
      {:error, :invalid_island_type}
      iex> {:ok, coordinate} = Coordinate.new(10,10)
      iex> Island.new(:l_shape, coordinate)
      {:error, :invalid_coordinate}
  """
  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  @doc """
  Check if two islands overlap

  ## Examples
      iex> {:ok, square_coordinate} = Coordinate.new(1,1)
      iex> {:ok, square} = Island.new(:square, square_coordinate)
      iex> {:ok, dot_coordinate} = Coordinate.new(1,2)
      iex> {:ok, dot} = Island.new(:dot, dot_coordinate)
      iex> {:ok, l_shape_coordinate} = Coordinate.new(5,5)
      iex> {:ok, l_shape} = Island.new(:l_shape, l_shape_coordinate)
      iex> Island.overlaps?(square, dot)
      true
      iex> Island.overlaps?(square, l_shape)
      false
      iex> Island.overlaps?(l_shape, dot)
      false
  """
  def overlaps?(existing_island, new_island) do
    not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)
  end

  @doc """
  Guess if a coordinate is on an island

  ## Examples
      iex> {:ok, dot_coordinate} = Coordinate.new(4,4)
      iex> {:ok, dot} = Island.new(:dot, dot_coordinate)
      iex> {:ok, coordinate} = Coordinate.new(2,2)
      iex> :miss = Island.guess(dot, coordinate)
      :miss
      iex> dot
      %Island{
        coordinates: [%Coordinate{col: 4, row: 4}] |> Enum.into(MapSet.new()),
        hit_coordinates: Enum.into([], MapSet.new())
      }
      iex> {:ok, coordinate} = Coordinate.new(4,4)
      iex> Island.guess(dot, coordinate)
      {:hit,
       %Island{
        coordinates: [%Coordinate{col: 4, row: 4}] |> Enum.into(MapSet.new()),
        hit_coordinates: [%Coordinate{col: 4, row: 4}] |> Enum.into(MapSet.new())
       }
      }
  """
  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}

      false ->
        :miss
    end
  end

  @doc """
  Check if an island is completely forested

  ## Examples
      iex> {:ok, dot_coordinate} = Coordinate.new(4,4)
      iex> {:ok, dot} = Island.new(:dot, dot_coordinate)
      iex> {:ok, coordinate} = Coordinate.new(4,4)
      iex> {:hit, dot} = Island.guess(dot, coordinate)
      iex> Island.forested?(dot)
      true
  """
  def forested?(island), do: MapSet.equal?(island.coordinates, island.hit_coordinates)

  @doc """
  Return all valid island types
  """
  def types(), do: [:atoll, :dot, :l_shape, :s_shape, :square]

  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(_), do: {:error, :invalid_island_type}

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} -> {:cont, MapSet.put(coordinates, coordinate)}
      {:error, :invalid_coordinate} -> {:halt, {:error, :invalid_coordinate}}
    end
  end
end
