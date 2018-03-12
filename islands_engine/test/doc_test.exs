defmodule DocTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Guesses, Island, Board}
  doctest Coordinate
  doctest Guesses
  doctest Island
  doctest Board
end
