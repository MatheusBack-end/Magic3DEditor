local old_face = nil
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
  local x = 0
  local y = 0
  local z = 0

  for i = 0, 2, 1 do
    local vertice = vertices:get(i)
    x = x + vertice:getX()
    y = y + vertice:getY()
    z = z + vertice:getZ()
  end

  return createVector3(x / 3, y / 3, z / 3)
end

function moveGizmo_test(vertices)
  gizmo_x:teleportTo(getFaceCenter(vertices))
  --pos:set(getFaceCenter(vertices))
  --Console:log(pos)
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

function traceLaser()
  local direction = camera_component:screenPointNormal(Input:getTouchPosition(0))
  local hit = laser:trace(camera:getGlobalPosition(), direction, 0)

  if hit ~= nil then
    local object = hit:getObject()
    local vertex = object:findComponent("ModelRenderer"):getVertex()
    local vertices = hit:getCollider():getVertex():getVertices()

    local index = getFace(vertices, vertex:getVertices(), vertex:getTriangles())

    if index ~= nil then
      createVisualFace(vertices, object)
      moveGizmo_test(vertices)
      vertex:getTriangles():remove(index)
      last_object = object
    end
  else
    if old_face ~= nil then
      last_object:removeComponent(old_face)
    end
  end
end
