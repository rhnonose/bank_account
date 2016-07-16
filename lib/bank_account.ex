defmodule BankAccount do
  use GenServer
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
  @spec open_bank :: account
  def open_bank do
    {:ok, account} = GenServer.start_link(__MODULE__, 0)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    GenServer.stop account, :normal
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    GenServer.call account, :balance
  end
 
  def handle_call(:balance, _from, balance) do
    {:reply, balance, balance}
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: none
  def update(account, amount) do
    GenServer.call account, {:update, amount}
  end 

  def handle_call({:update, amount}, _from, balance) do
    {:reply, balance, balance + amount}
  end
end
