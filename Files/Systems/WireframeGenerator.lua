local model_vertices = nil
local model_triangles = nil
local frame_vertices = nil
local frame_triangles = nil

local triangles_map = {0, 1, 2, 1, 3, 2, 5, 6, 4, 2, 1, 0, 2, 3, 1, 5, 4, 0, 2, 5, 0, 1, 6, 7, 1, 7, 3}

function makeWireframeFromFace(triangle)
  local vertices = getVerticesFromTriangle(triangle, model_vertices)

  for i = 0, 2, 1 do
    drawLine(vertices:get(i), vertices:get(clamp(0, i + 1, 2)))
  end
end

function add(x, y, z)
  local size = frame_vertices:size()
  frame_vertices:add(createVector3(x, y, z))

  return size
end

function lineVertices(a, b, lt)
  local vertices = AList:new()
  
  vertices:add(add(a:getX() + lt, a:getY() + lt, a:getZ()))
  vertices:add(add(a:getX() - lt, a:getY() + lt, a:getZ()))
  vertices:add(add(b:getX() + lt, b:getY() + lt, b:getZ()))
  vertices:add(add(b:getX() - lt, b:getY() + lt, b:getZ()))
  vertices:add(add(a:getX() + lt, a:getY() - lt, a:getZ()))
  vertices:add(add(b:getX() + lt, b:getY() - lt, b:getZ()))
  vertices:add(add(a:getX() - lt, a:getY() - lt, a:getZ()))
  vertices:add(add(b:getX() - lt, b:getY() - lt, b:getZ()))

  return vertices
end

function lineTriangles(v)
  for i = 0, count(triangles_map) - 1, 3 do
    frame_triangles:add(createVector3(v:get(triangles_map[i]), v:get(triangles_map[i + 1]), v:get(triangles_map[i + 2])))
  end
end

function drawLine(A, B)
  local line_thickness = 0.002

  lineTriangles(lineVertices(A, B, line_thickness))
end

function createNewMaterial(model_renderer)
  local material = Material:new()
  local color = createColor(255, 0, 0, 0)
  material:setColor("diffuse", color)
  model_renderer:setMaterial(material)
end

function createNewModelRenderer()
  local model_renderer = ModelRenderer:new()
  local vertex = Vertex:new()
  vertex:setVertices(frame_vertices)
  vertex:setTriangles(frame_triangles)
  model_renderer:setVertex(vertex)
  createNewMaterial(model_renderer)

  return model_renderer
end

function generate()
  frame_vertices = AList:new()
  frame_triangles = AList:new()

  for i = 0, (model_triangles:size() -1), 1 do
    makeWireframeFromFace(model_triangles:get(i))
  end

  myObject:addComponent(createNewModelRenderer())
end

function start()
  local model_renderer = myObject:findComponent("ModelRenderer")
  local vertex = model_renderer:getVertex()
  model_vertices = vertex:getVertices()
  model_triangles = vertex:getTriangles()

  generate()
end

function update()end
