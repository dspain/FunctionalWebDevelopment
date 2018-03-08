defmodule IslandsEngine.Guesses do
  @moduledoc """
  Documentation for IslandsEngine.Guesses
  """
  alias __MODULE__

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @doc """
  Generate a new MapSet for guesses, broken down into hits and misses

  """
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}
end
