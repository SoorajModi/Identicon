defmodule Identicon do
  @moduledoc """
    Documentation for Identicon.
  """

  alias Identicon.Image

  @doc """
     Generates an unique identicon image for any given input. Saved as input.png.


  ## Examples

       iex> Identicon.main("user_input")
       :ok

  """
  def main(input) do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
    |> remove_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
      Convert a string into an unique sequence of characters

  ## Examples

       iex> Identicon.hash_input "user_input"
       %Identicon.Image{
         colour: nil,
         grid: nil,
         hex: [238, 36, 65, 25, 22, 177, 16, 117, 52, 29, 28, 154, 83, 190, 37, 86]
       }

  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    # Now returning struct
    %Image{hex: hex}
  end

  @doc """
     Takes the first three elements of the list and sets them equal to colour

  ## Examples

       iex> Identicon.pick_colour(%Identicon.Image{hex: [1, 2, 3, 4]})
       %Identicon.Image{
         colour: {1, 2, 3},
         grid: nil,
         hex: [1, 2, 3, 4]
       }
  """

  # As we receive the image as an arg, we are also pattern matching out of the arguement

  def pick_colour(%Image{hex: [r, g, b | _tail]} = image) do
    %Image{image | colour: {r, g, b}}
  end

  @doc """
  Builds the final element of image struct, the grid.

   - splits integer list into 3 part chunks
   - & means we are going to be passing a reference
   - turns every element in list to two element tuple
  """
  def build_grid(%Image{hex: hex} = image) do
    %Image{
      image
      | grid:
          hex
          |> Enum.chunk(3)
          |> Enum.map(&mirror_row/1)
          |> List.flatten()
          |> Enum.with_index()
    }
  end

  @doc """
     Appends the first two elements of a list to the end of the list

  ## Examples

       iex> Identicon.mirror_row([1, 2, 3])
       [1, 2, 3, 2, 1]

  """
  def mirror_row([first, second, third]) do
    [first, second, third, second, first]
  end

  @doc """
     Filters odd elements out of the array.
  """
  def remove_odd_squares(%Image{grid: grid} = image) do
    grid = Enum.reject(grid, fn {code, _} -> rem(code, 2) == 1 end)
    %Image{image | grid: grid}
  end

  @doc """
     Generates a pixel map given an Identicon image.
  """
  def build_pixel_map(%Image{grid: grid} = image) do
    pixel_map = Enum.map(grid, fn {_, index} -> build_inner_square_coordinates(index) end)
    %Image{image | pixel_map: pixel_map}
  end

  defp build_inner_square_coordinates(index) do
    horizontal = rem(index, 5) * 50
    vertical = div(index, 5) * 50

    top_left = {horizontal, vertical}
    bottom_right = {horizontal + 50, vertical + 50}

    {top_left, bottom_right}
  end

  @doc """
     Draws an image given colour and a pixel map.
  """
  def draw_image(%Image{colour: colour, pixel_map: pixel_map}) do
    create_image()
    |> fill_squares(pixel_map, colour)
    |> render()
  end

  defp create_image() do
    :egd.create(250, 250)
  end

  defp fill_squares(image, pixel_map, colour) do
    pixel_map
    |> Enum.each(fn coordinates -> fill_single_square(image, coordinates, colour) end)
    image
  end

  defp render(image) do
    :egd.render(image)
  end

  defp fill_single_square(image, {top_left, bottom_right}, colour) do
    :egd.filledRectangle(image, top_left, bottom_right, :egd.color(colour))
  end

  @doc """
     Saves a png image to a specified file.
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
