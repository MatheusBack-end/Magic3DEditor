collider_file = nil
triangles = nil
model = nil
vertex = nil
vertices = nil

function get_vertices_from_triangle(triangle)
  local v = luajava.newInstance("java.util.ArrayList")

  v:add(vertices:get(triangle:getX()))
  v:add(vertices:get(triangle:getY()))
  v:add(vertices:get(triangle:getZ()))

  return v
end

function generate()
  for i=0, triangles:size() -1, 1 do
    local collider = Collider:new()
    local vertex_l = Vertex:new()
    local triangle = luajava.newInstance("java.util.ArrayList")
    local vector = Vector3:new()
    vector:setX(0)
    vector:setY(1) -- <<<<< codigo lixo 
    vector:setZ(2)
    triangle:add(vector )
    local vertice = get_vertices_from_triangle(triangles:get(i))
    vertex_l:setVertices(vertice)
    vertex_l:setTriangles(triangle)
    collider:setVertex(vertex_l)
    myObject:addComponent(collider)
  end
end

function start()
  model = myObject:findComponent("ModelRenderer")
  vertex = model:getVertex()
  vertices = vertex:getVertices()
  triangles = vertex:getTriangles()
  generate()
end

function update()
end
