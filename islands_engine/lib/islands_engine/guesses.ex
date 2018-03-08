defmodule IslandsEngine.Guesses do
  @moduledoc """
  Documentation for IslandsEngine.Guesses
  """
  alias __MODULE__

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @doc """
  Generate a new MapSet for guesses, broken down into hits and misses

  ## Examples
    iex> guesses = Guesses.new()
    %IslandsEngine.Guesses{hits: Enum.into([], MapSet.new), misses: Enum.into([], MapSet.new)}
    iex> {:ok, coordinate1} = Coordinate.new(1,1)
    {:ok, %IslandsEngine.Coordinate{col: 1, row: 1}}
    iex> {:ok, coordinate2} = Coordinate.new(2,2)
    {:ok, %IslandsEngine.Coordinate{col: 2, row: 2}}
    iex> guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate1))
    %IslandsEngine.Guesses{
      hits: [%IslandsEngine.Coordinate{col: 1, row: 1}] |> Enum.into(MapSet.new),
      misses: [] |> Enum.into(MapSet.new)
    }
    iex> guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate2))
    %IslandsEngine.Guesses{
      hits: [
        %IslandsEngine.Coordinate{col: 1, row: 1},
        %IslandsEngine.Coordinate{col: 2, row: 2}
      ] |> Enum.into(MapSet.new),
      misses: [] |> Enum.into(MapSet.new)
    }
    iex> guesses = update_in(guesses.hits, &MapSet.put(&1, coordinate1))
    %IslandsEngine.Guesses{
      hits: [
        %IslandsEngine.Coordinate{col: 1, row: 1},
        %IslandsEngine.Coordinate{col: 2, row: 2}
      ] |> Enum.into(MapSet.new),
      misses: [] |> Enum.into(MapSet.new)
    }
    iex> guesses
    %IslandsEngine.Guesses{
      hits: [
        %IslandsEngine.Coordinate{col: 1, row: 1},
        %IslandsEngine.Coordinate{col: 2, row: 2}
      ] |> Enum.into(MapSet.new),
      misses: [] |> Enum.into(MapSet.new)
    }

  """
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}
end
