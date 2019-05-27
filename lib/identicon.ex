defmodule Identicon do
  @moduledoc """
    Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_colour
  end

  # As we receive the image as an arg, we are also pattern matching out of the arguement
  def pick_colour(%Identicon.Image{hex: [r,g,b | _tail]} = image ) do #must use pattern matching, and acknowledge the rest of the elements in the struct (hence _tail)
    %Identicon.Image{image | colour: {r,g,b}}
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
