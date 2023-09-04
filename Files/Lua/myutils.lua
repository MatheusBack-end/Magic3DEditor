Utils = {}

function Utils:new()
	local object = {}

	setmetatable(object, self)
	self.__index = self

	return object
end

function Utils:debug(value)
	Console:log(value)
end

function start()
	luaname = "utils"
end

function update()
end

function getTable()
	return Utils
end

function new()
	return Utils:new()
end

function Utils:createColor(alpha, red, green, blue)
  local color = Color:new()
  color:setIntAlpha(alpha)
  color:setIntRed(red)
  color:setIntGreen(green)
  color:setIntBlue(blue)

  return color
end

function Utils:createVector3(x, y, z)
  local vector3 = Vector3:new();
  vector3:setX(x);
  vector3:setY(y);
  vector3:setZ(z);

  return vector3
end

function Utils:getVerticesFromTriangle(triangle, list_of_vertices)
  local vertices = AList:new()

  vertices:add(list_of_vertices:get(triangle:getX()))
  vertices:add(list_of_vertices:get(triangle:getY()))
  vertices:add(list_of_vertices:get(triangle:getZ()))

  return vertices
end

function Utils:count(table)
  local count = 0

  for i, k in pairs(table) do
    count = count + 1
  end

  return count
end

function Utils:clamp(min, value, max)
  if value > max then
    return min
  end

  return value
end
