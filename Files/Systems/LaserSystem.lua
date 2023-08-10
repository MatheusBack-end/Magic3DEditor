local old_face = nil

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
      vertex:getTriangles():remove(index)
    end
  end
end
