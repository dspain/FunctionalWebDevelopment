defmodule DocTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Guesses, Island, Board, Rules}
  doctest Coordinate
  doctest Guesses
  doctest Island
  doctest Board
  doctest Rules
end
