defmodule DocTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Guesses}
  doctest Coordinate
  doctest Guesses
end
