defmodule Test do

  def snap do
    camera = Camera.normal({800, 600})

    obj1 = %Sphere{radius: 140, pos: {0, 0, 700}, color: {0.0, 0.2, 0.8}}
    obj2 = %Sphere{radius: 50, pos: {200, 0, 600}, color: {0.3, 0.9, 0.4}}
    obj3 = %Sphere{radius: 50, pos: {-80, 55, 400}, color: {0.15, 0, 0}}

    light1 = %Light{pos: {0,0,200}, color: {1,1,0.5}}
    light2 = %Light{pos: {0,50,100}, color: {1,1,1}}

    world = %World{objects: [obj1, obj2, obj3], lights: [light1, light2]}
    image = Tracer.tracer(camera, world)
    PPM.write("test.ppm", image)
  end

end
