defmodule Identicon.Image do
  defstruct hex: nil
end

# Structs are like maps but strictly enforce what can be placed in it
# Ie. cannot add hex2 property to this struct, but would be able to on a map

# Has no ability to attach functions, can only hold primitive data