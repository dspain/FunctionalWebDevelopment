defmodule DocTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Guesses, Island}
  doctest Coordinate
  doctest Guesses
  doctest Island
end
