defmodule IslandsEngine.Guesses do
  @moduledoc """
  Documentation for IslandsEngine.Guesses
  """
  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @doc """
  Generate a new MapSet for guesses, broken down into hits and misses

  ## Examples
      iex> guesses = Guesses.new()
      %Guesses{hits: Enum.into([], MapSet.new), misses: Enum.into([], MapSet.new)}
      iex> {:ok, coordinate1} = Coordinate.new(1,1)
      iex> {:ok, coordinate2} = Coordinate.new(2,2)
      iex> guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate1))
      %Guesses{
        hits: [%Coordinate{col: 1, row: 1}] |> Enum.into(MapSet.new),
        misses: [] |> Enum.into(MapSet.new)
      }
      iex> guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate2))
      %Guesses{
        hits: [
          %Coordinate{col: 1, row: 1},
          %Coordinate{col: 2, row: 2}
        ] |> Enum.into(MapSet.new),
        misses: [] |> Enum.into(MapSet.new)
      }
      iex> guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate1))
      %Guesses{
        hits: [
          %Coordinate{col: 1, row: 1},
          %Coordinate{col: 2, row: 2}
        ] |> Enum.into(MapSet.new),
        misses: [] |> Enum.into(MapSet.new)
      }
      iex> guesses
      %Guesses{
        hits: [
          %Coordinate{col: 1, row: 1},
          %Coordinate{col: 2, row: 2}
        ] |> Enum.into(MapSet.new),
        misses: [] |> Enum.into(MapSet.new)
      }

  """
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @doc """
  Add a coordinate to list of hits and misses

  ## Examples
      iex> guesses = Guesses.new()
      iex> {:ok, coordinate1} = Coordinate.new(8,3)
      iex> guesses = Guesses.add(guesses, :hit, coordinate1)
      %Guesses{
        hits: [%Coordinate{row: 8, col: 3}] |>
              Enum.into(MapSet.new()),
        misses: Enum.into([], MapSet.new())
      }
      iex> {:ok, coordinate2} = Coordinate.new(9,7)
      iex> guesses = Guesses.add(guesses, :hit, coordinate2)
      %Guesses{
        hits: [
          %Coordinate{row: 8, col: 3},
          %Coordinate{row: 9, col: 7}
        ] |> Enum.into(MapSet.new()),
        misses: Enum.into([], MapSet.new())
      }
      iex> {:ok, coordinate3} = Coordinate.new(1,2)
      iex> Guesses.add(guesses, :miss, coordinate3)
      %Guesses{
        hits: [
          %Coordinate{row: 8, col: 3},
          %Coordinate{row: 9, col: 7}
        ] |> Enum.into(MapSet.new()),
        misses: [%Coordinate{row: 1, col: 2}] |> Enum.into(MapSet.new())
      }
  """
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
