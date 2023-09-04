-- Camera System
local sens = 10.5
local touch = nil
local pivot_x = nil
local camera = nil
local camera_component = nil
local laser = nil
local gizmo_x = nil
local gizmo_y = nil
local gizmo_z = nil
local is_down = false
local selected_gizmo = nil
local debug_text = nil
local old_face = nil

function start()
  laser = Laser:new()
  touch = Input:getAxisValue("touch")
  pivot_x = myObject:findChildObject("pivot-x")
  camera = pivot_x:findChildObject("camera")
  camera_component = camera:findComponent("Camera")

  gizmo_x = WorldController:findObject("gizmo_x")
  gizmo_y = WorldController:findObject("gizmo_y")
  gizmo_z = WorldController:findObject("gizmo_z")
	local ldebug_text = WorldController:findObject("debug_text")
	debug_text = ldebug_text:findComponent("SUIText")	
end

function update()
  if selected_gizmo ~= nil then
		--debug_text:setText(touch:getX())
		if old_face ~= nil then
			moveFace(old_face, -touch:getX())
		end
	else
		debug_text:setText("none")
	end

  if is_down and Input:getTouch(0):isDown() == false then
    traceLaser()
  end

  if Input:getTouch(0):isPressed() then
		moveGizmo()
	else
		selected_gizmo = nil
	end

  is_down = Input:getTouch(0):isDown()

  myTransform:rotateInSeconds(0, -touch:getX() * sens, 0)
  pivot_x:rotateInSeconds(touch:getY() * sens, 0, 0)


end

-- Utils
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

-- Laser System
--local old_face = nil -- 80
local last_object = nil

function getFace(vertices_collider, model_vertices, triangles)
  for i = 0, triangles:size() -1, 1 do
    local vertices = getVerticesFromTriangle(triangles:get(i), model_vertices)
    local is_equal = true

    for j = 0, 2, 1 do
      if vertices_collider:get(j) ~= vertices:get(j) then
        is_equal = false
      end
    end

    if is_equal then
      return i
    end
  end
end

function getFaceCenter(vertices)
  local x, y, z = 0, 0, 0

  for i = 0, 2, 1 do
    local vertice = vertices:get(i)
    x = x + vertice:getX()
    y = y + vertice:getY()
    z = z + vertice:getZ()
  end

  return createVector3(x / 3, y / 3, z / 3)
end

function moveGizmo_test(vertices)
  local center = getFaceCenter(vertices)
  gizmo_x:teleportTo(center)
  gizmo_x:move(0.25, 0, 0)
  gizmo_y:teleportTo(center)
  gizmo_y:move(0, 0.25, 0)
  gizmo_z:teleportTo(center)
  gizmo_z:move(0, 0, 0.25)
end

function isEqualsVertices(v1, v2)
	local is_equals = true

	for i=0, 2, 1 do
		is_equals = v1:equals(v2)
	end

	return is_equals
end

function getTrianglesFromVertices(vertices, triangles, ov)
  --Console:log(vertices:size())
	for i=0, triangles:size() -1, 1 do
		local v = getVerticesFromTriangle(triangles:get(i), vertices)

		if isEqualsVertices(ov, v) then
			return i
		end 
	end
end

function updateWireframe(object)
	local globals = object:findComponent("LuaExecutor").globals

	LuaInvoker:invoke("generate", globals)
end

function updateCollider(object)
	local globals = object:findComponents("LuaExecutor"):get(1).globals

	LuaInvoker:invoke("generate", globals)
end

function moveFace(face, value)
	local vertex = face:getVertex()
	local vertices = vertex:getVertices()
	local ot = last_object:findComponent("ModelRenderer"):getVertex():getTriangles()
	local ov = last_object:findComponent("ModelRenderer"):getVertex():getVertices()
	local tst = getTrianglesFromVertices(ov, ot, vertices)

	moveObjectFace(last_object, vertices, createVector3(value / 10, 0, 0), tst)
	
	for i=0, 2, 1 do
		local v = vertices:get(i)
		v:setX(v:getX() + (value / 10))
		vertices:set(i, v)
		--debug_text:setText(vertices:get(i):getX())	
	end

	moveGizmo_test(vertices)

	vertex:setVertices(vertices)
	face:setVertex(vertex)
	updateWireframe(last_object)
  --myObject:teleportTo(getFaceCenter(vertices))
end

function moveObjectFace(object, face, vector, id)
	local model_renderer = object:findComponent("ModelRenderer")
	local vertices = model_renderer:getVertex():getVertices()
	local triangles = model_renderer:getVertex():getTriangles()
  local t = triangles:get(id)

	--Console:log(t)
	local x = t:getX()
	local y = t:getY()
	local z = t:getZ()
	local vx = vertices:get(x)
	local vy = vertices:get(y)
  local vz = vertices:get(z)

	vx:set(vx:getX() + vector:getX(), vx:getY() + vector:getY(), vx:getZ() + vector:getZ())
	vy:set(vy:getX() + vector:getX(), vy:getY() + vector:getY(), vy:getZ() + vector:getZ())
	vz:set(vz:getX() + vector:getX(), vz:getY() + vector:getY(), vz:getZ() + vector:getZ())
	vertices:set(x, vx)
	vertices:set(y, vy)
	vertices:set(z, vz)
	
	model_renderer:getVertex():setVertices(vertices)
end

function createVisualFace(vertices, object)
  local vertex = Vertex:new()
  local triangles = AList:new()
  local model_renderer = ModelRenderer:new()
  local material = Material:new()
  local color = createColor(255, 0, 255, 0)

  triangles:add(createVector3(0, 1, 2))
  vertex:setVertices(vertices)
  vertex:setTriangles(triangles)
  model_renderer:setVertex(vertex)
  material:setColor("diffuse", color)
  model_renderer:setMaterial(material)

  if old_face then
    object:removeComponent(old_face)
  end

  object:addComponent(model_renderer)
  old_face = model_renderer
end

function moveGizmo()
	if selected_gizmo == nil then
		local layer = PhysicsLayers:findByName("gizmos")
		local direction = camera_component:screenPointNormal(Input:getTouchPosition(0))
		local hit = laser:trace(camera:getGlobalPosition(), direction, layer)

		if hit ~= nil then
			if hit:getObject():getName() == "gizmo_x" then
				selected_gizmo = hit:getObject()
			end
		end
	end
end

function traceLaser()
	if last_object ~= nil then
		updateCollider(last_object)
	end

  local direction = camera_component:screenPointNormal(Input:getTouchPosition(0))
  local hit = laser:trace(camera:getGlobalPosition(), direction, 0)

  if hit ~= nil then
    local object = hit:getObject()
		
		if object:getTag() ~= "gizmo" then
    	local vertex = object:findComponent("ModelRenderer"):getVertex()
    	local vertices = hit:getCollider():getVertex():getVertices()
			
    	local index = getFace(vertices, vertex:getVertices(), vertex:getTriangles())

	    if index ~= nil then
  	    createVisualFace(vertices, object)
    	  moveGizmo_test(vertices)
1				myObject:teleportTo(getFaceCenter(vertices))
    	  --vertex:getTriangles():remove(index)
    	  last_object = object
    	end
  	end

  elseif old_face ~= nil then
    --last_object:removeComponent(old_face)
  end
end
