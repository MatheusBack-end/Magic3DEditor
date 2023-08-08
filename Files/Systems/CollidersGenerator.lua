local triangles = nil
local vertices = nil

function createFaceCollider(index)
  local collider = Collider:new()
  local vertex = Vertex:new()
  local face_triangles = AList:new()
  local face_vertices = getVerticesFromTriangle(triangles:get(index), vertices)

  face_triangles:add(createVector3(0, 1, 2))
  vertex:setVertices(face_vertices)
  vertex:setTriangles(face_triangles)
  collider:setVertex(vertex)
  
  return collider
end

function generate()
  for i = 0, triangles:size() -1, 1 do
    myObject:addComponent(createFaceCollider(i))
  end
end

function start()
  local vertex = myObject:findComponent("ModelRenderer"):getVertex()
  vertices = vertex:getVertices()
  triangles = vertex:getTriangles()

  generate()
end

function update()end
