defmodule IslandsEngine.Rules do
  alias __MODULE__

  defstruct state: :initialized,
            player1: :islands_not_set,
            player2: :islands_not_set

  @doc """
  Create a new 'Rules' struct with state `:initialized`

  ## Examples
      iex> Rules.new()
      %Rules{state: :initialized,
        player1: :islands_not_set,
        player2: :islands_not_set
      }
  """
  def new(), do: %Rules{}

  @doc """
  Check the action and update the state if it is a valid action

  ## Examples
      iex> rules = Rules.new()
      iex> {:ok, rules} = Rules.check(rules, :add_player)
      {:ok, %Rules{state: :players_set}}
      iex> rules.state
      :players_set
      iex> rules = Rules.new()
      iex> Rules.check(rules, :no_such_rule)
      :error
      iex> rules = %Rules{rules | state: :players_set}
      iex> {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
      {:ok, %Rules{state: :players_set, player1: :islands_not_set, player2: :islands_not_set}}
      iex> {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
      {:ok, %Rules{state: :players_set, player1: :islands_not_set, player2: :islands_not_set}}
      iex> rules.state
      :players_set
      iex> rules = Rules.new()
      iex> rules = %Rules{rules | state: :players_set}
      iex> {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
      iex> {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
      iex> rules.state
      :players_set
      iex> Rules.check(rules, {:position_islands, :player1})
      :error
      iex> {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
      iex> {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
      iex> Rules.check(rules, {:position_islands, :player2})
      :error
      iex> rules.state
      :player1_turn
      iex> Rules.check(rules, {:set_islands, :player2})
      :error
      iex> rules.state
      :player1_turn
      iex> Rules.check(rules, :add_player)
      :error
      iex> Rules.check(rules, {:position_islands, :player1})
      :error
      iex> Rules.check(rules, {:position_islands, :player2})
      :error
      iex> Rules.check(rules, {:set_islands, :player1})
      :error
  """
  def check(%Rules{state: :initialized} = rules, :add_player),
    do: {:ok, %Rules{rules | state: :players_set}}

  def check(%Rules{state: :players_set} = rules, {:position_islands, player}) do
    case Map.fetch!(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end

  def check(%Rules{state: :players_set} = rules, {:set_islands, player}) do
    rules = Map.put(rules, player, :islands_set)

    case both_players_islands_set?(rules) do
      true -> {:ok, %Rules{rules | state: :player1_turn}}
      false -> {:ok, rules}
    end
  end

  def check(_state, _action), do: :error

  defp both_players_islands_set?(rules),
    do: rules.player1 == :islands_set && rules.player2 == :islands_set
end
