defmodule Identicon do
  @moduledoc """
    Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_colour
  end

  def pick_colour(image) do
    #cannot do hex_list = image[0], have to use pattern matching: %Identicon.Image{hex: hex_list} = image
    #[r,g,b] = hex_list <- does not work, must acknowledge the rest of the elements in hex_list: [r,g,b | _tail] = hex_list

    %Identicon.Image{hex: [r,g,b | _tail]} = image
    [r,g,b]
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
