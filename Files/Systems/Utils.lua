function createColor(alpha, red, green, blue)
  local color = Color:new()
  color:setIntAlpha(alpha)
  color:setIntRed(red)
  color:setIntGreen(green)
  color:setIntBlue(blue)

  return color
end

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

function count(table)
  local count = 0

  for i, k in pairs(table) do
    count = count + 1
  end

  return count
end

function clamp(min, value, max)
  if value > max then
    return min
  end

  return value
end
