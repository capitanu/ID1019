defmodule World do

  @background {0.15, 0.15, 0.15}
  @depth 10
  @ambient {0.3, 0.3, 0.3}
  @refraction 1

  defstruct(
    objects: [],
    lights: [],
    background: @background,
    depth: @depth,
    ambient: @ambient,
    refraction: @refraction
  )

end
