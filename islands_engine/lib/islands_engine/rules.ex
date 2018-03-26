defmodule IslandsEngine.Rules do
  alias __MODULE__

  defstruct state: :initialized

  @doc """
  Create a new 'Rules' struct with state `:initialized`

  ## Examples
      iex> Rules.new()
      %Rules{state: :initialized}
  """
  def new(), do: %Rules{}

  @doc """
  Check the action and update the state if it is a valid action

  ## Examples
      iex> rules = Rules.new()
      iex> {:ok, rules} = Rules.check(rules, :add_player)
      {:ok, %Rules{state: :player_set}}
      iex> rules.state
      :player_set
      iex> rules = Rules.new()
      iex> Rules.check(rules, :no_such_rule)
      :error
  """
  def check(%Rules{state: :initialized} = rules, :add_player),
    do: {:ok, %Rules{rules | state: :player_set}}

  def check(_state, _action), do: :error
end
