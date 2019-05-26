defmodule Identicon do
  @moduledoc """
    Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
  end

  @doc """
      Convert a string into an unique sequence of characters
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}    # Now returning struct
  end
end
