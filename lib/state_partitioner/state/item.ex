defmodule StatePartitioner.State.Item do
  defstruct [:key, :expiry, :data]

  def new(key, data \\ %{}) do
    new_with_expiry(key, DateTime.add(now(), expiry(), :millisecond), data)
  end

  def new_with_expiry(key, expiry, data \\ %{}) do
    %__MODULE__{
      key: key,
      data: data,
      expiry: expiry
    }
  end

  def expired?(%__MODULE__{expiry: expiry}) do
    if DateTime.compare(expiry, now()) == :lt do
      true
    else
      false
    end
  end

  def expiry do
    :timer.minutes(2)
  end

  def now do
    DateTime.utc_now()
  end
end
