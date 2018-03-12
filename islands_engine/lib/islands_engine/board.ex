defmodule IslandsEngine.Board do
  @moduledoc """
  Description of `IslandsEngine.Board`
  """

  alias IslandsEngine.{Coordinate, Island}

  @doc """
  Create a new board

  ## Examples
      iex> Board.new()
      %{}
  """
  def new(), do: %{}

  @doc """
  Position an island on the board

  ## Examples
      iex> board = Board.new()
      iex> {:ok, square_coordinate} = Coordinate.new(1,1)
      iex> {:ok, square} = Island.new(:square, square_coordinate)
      iex> board = Board.position_island(board, :square, square)
      %{
        square: %Island{
          coordinates: [
            %Coordinate{col: 1, row: 1},
            %Coordinate{col: 1, row: 2},
            %Coordinate{col: 2, row: 1},
            %Coordinate{col: 2, row: 2}
          ] |> Enum.into(MapSet.new()),
          hit_coordinates: Enum.into([], MapSet.new())
        }
      }
      iex> {:ok, dot_coordinate} = Coordinate.new(2,2)
      iex> {:ok, dot} = Island.new(:dot, dot_coordinate)
      iex> Board.position_island(board, :dot, dot)
      {:error, :overlapping_island}
  """
  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> Map.put(board, key, island)
    end
  end

  def overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  def all_islands_positioned?(board) do
    Enum.all?(Island.types(), &Map.has_key?(board, &1))
  end

  @doc """
  Guess if a coordinate is a hit or miss,  return a 4-tuple of information:

    `{:hit/:miss, :none/:island_type, :win/:no_win, board}`

  ## Examples
      iex> board = Board.new()
      iex> {:ok, square_coordinate} = Coordinate.new(1,1)
      iex> {:ok, square} = Island.new(:square, square_coordinate)
      iex> board = Board.position_island(board, :square, square)
      iex> {:ok, dot_coordinate} = Coordinate.new(3,3)
      iex> {:ok, dot} = Island.new(:dot, dot_coordinate)
      iex> board = Board.position_island(board, :dot, dot)
      iex> {:ok, guess_coordinate} = Coordinate.new(10,10)
      iex> {:miss, :none, :no_win, board} = Board.guess(board, guess_coordinate)
      {:miss, :none, :no_win,
        %{
          square: %Island{
            coordinates: [
              %Coordinate{col: 1, row: 1},
              %Coordinate{col: 1, row: 2},
              %Coordinate{col: 2, row: 1},
              %Coordinate{col: 2, row: 2}
            ] |> Enum.into(MapSet.new()),
            hit_coordinates: Enum.into([], MapSet.new())
          },
          dot: %Island{
            coordinates: [
              %Coordinate{col: 3, row: 3}
            ] |> Enum.into(MapSet.new()),
            hit_coordinates: Enum.into([], MapSet.new())
          }
        }
      }
      iex> {:ok, hit_coordinate} = Coordinate.new(1,1)
      iex> {:hit, :none, :no_win, board} = Board.guess(board, hit_coordinate)
      {:hit, :none, :no_win,
        %{
          square: %Island{
            coordinates: [
              %Coordinate{col: 1, row: 1},
              %Coordinate{col: 1, row: 2},
              %Coordinate{col: 2, row: 1},
              %Coordinate{col: 2, row: 2}
            ] |> Enum.into(MapSet.new()),
            hit_coordinates: [
              %Coordinate{col: 1, row: 1}
            ] |> Enum.into(MapSet.new())
          },
          dot: %Island{
            coordinates: [
              %Coordinate{col: 3, row: 3}
            ] |> Enum.into(MapSet.new()),
            hit_coordinates: Enum.into([], MapSet.new())
          }
        }
      }
      iex> square = %{square | hit_coordinates: square.coordinates}
      iex> board = Board.position_island(board, :square, square)
      iex> {:ok, win_coordinate} = Coordinate.new(3,3)
      iex> {:hit, :dot, :win, _board} = Board.guess(board, win_coordinate)
      {:hit, :dot, :win,
        %{
          square: %Island{
            coordinates: [
              %Coordinate{col: 1, row: 1},
              %Coordinate{col: 1, row: 2},
              %Coordinate{col: 2, row: 1},
              %Coordinate{col: 2, row: 2}
            ] |> Enum.into(MapSet.new()),
            hit_coordinates: [
              %Coordinate{col: 1, row: 1},
              %Coordinate{col: 1, row: 2},
              %Coordinate{col: 2, row: 1},
              %Coordinate{col: 2, row: 2}
            ] |> Enum.into(MapSet.new())
          },
          dot: %Island{
            coordinates: [
              %Coordinate{col: 3, row: 3}
            ] |> Enum.into(MapSet.new()),
            hit_coordinates: [
              %Coordinate{col: 3, row: 3}
            ] |> Enum.into(MapSet.new()),
          }
        }
      }
  """
  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forest_check(board, key), win_check(board), board}
  end

  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp forest_check(board, key) do
    case forested?(board, key) do
      true -> key
      false -> :none
    end
  end

  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    case all_forested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  defp all_forested?(board),
    do: Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)
end
