function createVector3(x, y, z)
  local vector3 = Vector3:new()
  vector3:set(x, y, z)

  return vector3
end

function getVerticesFromTriangle(triangle, list_of_vertices)
  local vertices = AList:new()

  vertices:add(list_of_vertices:get(triangle:getX()))
  vertices:add(list_of_vertices:get(triangle:getY()))
  vertices:add(list_of_vertices:get(triangle:getZ()))

  return vertices
end
