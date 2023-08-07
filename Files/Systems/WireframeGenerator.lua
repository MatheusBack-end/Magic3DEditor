local model_vertices = nil
local model_triangles = nil
local frame_vertices = nil
local frame_triangles = nil

function vector3(x, y, z)
  local vector3 = Vector3:new()
  
  vector3:setX(x)
  vector3:setY(y)
  vector3:setZ(z)

  return vector3
end

function make_wireframe_from_face(triangle)
  local a = model_vertices:get(triangle:getX())
  local b = model_vertices:get(triangle:getY())
  local c = model_vertices:get(triangle:getZ())

  draw_line(a, b)
  draw_line(b, c)
  draw_line(c, a)
end

function add_vertice(v)
  local size = frame_vertices:size()
  frame_vertices:add(v)

  return size
end

function draw_line(A, B)
  --TODO: codigo lixo, refatorar ao longo do projeto
  local s = 0.003

  local va = add_vertice(vector3(A:getX() + s, A:getY() + s, A:getZ()))
  local vb = add_vertice(vector3(A:getX() - s, A:getY() + s, A:getZ()))
  local vc = add_vertice(vector3(B:getX() + s, B:getY() + s, B:getZ()))
  local vd = add_vertice(vector3(B:getX() - s, B:getY() + s, B:getZ()))
  local ve = add_vertice(vector3(A:getX() + s, A:getY() - s, A:getZ()))
  local vf = add_vertice(vector3(B:getX() + s, B:getY() - s, B:getZ()))
  local vg = add_vertice(vector3(A:getX() - s, A:getY() - s, A:getZ()))
  local vh = add_vertice(vector3(B:getX() - s, B:getY() - s, B:getZ()))

  frame_triangles:add(vector3(va, vb, vc))
  frame_triangles:add(vector3(vb, vd, vc))
  frame_triangles:add(vector3(vf, vg, ve))
  frame_triangles:add(vector3(vf, vh, vg))
  frame_triangles:add(vector3(vc, vb, va))
  frame_triangles:add(vector3(vc, vd, vb))
  frame_triangles:add(vector3(vf, ve, va))
  frame_triangles:add(vector3(vc, vf, va))  
  frame_triangles:add(vector3(vb, vg, vh))
  frame_triangles:add(vector3(vb, vh, vd))
end

function generate()
  frame_vertices = luajava.newInstance("java.util.ArrayList")
  frame_triangles = luajava.newInstance("java.util.ArrayList")

  local eol = false -- end of list

  for i = 0, (model_triangles:size() -1), 1 do
    make_wireframe_from_face(model_triangles:get(i))
  end

  --draw_line(vector3(0,0,0), vector3(0,0,0.8))
  local new_model_renderer = ModelRenderer:new()
  local new_vertex = Vertex:new()
  local color = Color:new(0,0,0)
  color:setIntRed(0)
  color:setIntGreen(0)
  color:setIntBlue(0)
  new_vertex:setVertices(frame_vertices)
  new_vertex:setTriangles(frame_triangles)
  new_model_renderer:setVertex(new_vertex)
  new_model_renderer:setMaterial(Material:new())
  myObject:addComponent(new_model_renderer)
  new_model_renderer:getMaterial():setColor("diffuse", color)
end

function start()
  local model_renderer = myObject:findComponent("ModelRenderer")
  local vertex = model_renderer:getVertex()
  model_vertices = vertex:getVertices()
  model_triangles = vertex:getTriangles()

  generate()
end

function update()
end
