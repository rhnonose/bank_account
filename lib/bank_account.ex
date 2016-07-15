defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    spawn_link(BankAccount, :acc, [0])
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    send account, {self(), :close}
    receive do
      :closed -> :closed
	after
	  1000 -> flunk("Timeout")
    end
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    send account, {self(), :balance}
    receive do
      {:ok, balance} -> balance
	after
	  1000 -> flunk("Timeout")
    end
  end
 
  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    send account, {self(), :update, amount}
    receive do
      {:ok, new_value} -> new_value
	after
	  1000 -> flunk("Timeout")
    end
  end 

  def acc(balance) do
    receive do
      {caller, :balance} -> 
        send caller, {:ok, balance}
        acc(balance)
      {caller, :update, value} ->
        new_value = balance + value
        send caller, {:ok, new_value}
        acc(new_value)
      {caller, :close} ->
        send caller, :closed
    end
  end
end
