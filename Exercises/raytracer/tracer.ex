defmodule Tracer do

  @black {0, 0, 0}
  @white {1, 1, 1}
  @delta 0.01

  def tracer(camera, objects) do
    {w, h} = camera.size
    for y <- 1..h, do: for(x <- 1..w, do: trace(x, y, camera, objects))
  end

  def trace(x, y, camera, world) do
    ray = Camera.ray(camera, x, y)
    trace(ray, world.depth, world)
  end

  defp trace(ray, 0 ,world) do world.background end

  defp trace(ray, depth,  %World{objects: objects} = world) do

    case intersect(ray, objects) do
      {:inf, _} ->
	world.background
      {dist, obj} ->
	pos = ray.pos
	dir = ray.dir
	point = Vector.add(pos, Vector.smul(dir, dist - @delta))
	normal = Object.normal(obj,ray, point)
	visible = visible(point, world.lights, objects)
	illumination = Light.combine(point, normal, visible)
	r = %Ray{pos: point, dir: reflection(ray.dir, normal)}
	reflection = trace(r, depth-1, world)
	Light.illuminate(obj, reflection, illumination, world)
    end
  end
  def intersect(ray, objects) do
    List.foldl(objects, {:inf, nil}, fn (object, sofar) ->
      {dist, _} = sofar

      case Object.intersect(object, ray) do
        {:ok, d} when d < dist ->
          {d, object}
        _ ->
          sofar
      end
    end)
  end

  def visible(point, lights, objects) do
    Enum.filter(lights, fn light -> clear(point, light.pos, objects) end)
  end

  def clear(point, origin, objects) do
    dir = Vector.normalize(Vector.sub(origin, point))
    List.foldl(objects, true, fn(obj, acc) ->
      case acc do
	false -> false
	true ->
	  case Object.intersect(obj, %Ray{pos: point, dir: dir}) do
	    :no -> true
	    _ -> false
	  end
      end
    end)
  end
  def reflection(dir, normal) do
    Vector.sub(dir, Vector.smul(normal, 2 * Vector.dot(dir, normal)))
  end
end
