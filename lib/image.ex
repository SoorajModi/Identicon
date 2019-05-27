defmodule Identicon.Image do
  defstruct hex: nil, colour: nil
end

# Structs are like maps but strictly enforce what can be placed in it
# Ie. cannot add hex2 property to this struct, but would be able to on a map
# must initialize property values ahead of time otherwise you get an error

# Has no ability to attach functions, can only hold primitive data

# if we know properties we are going to be using, we use structs