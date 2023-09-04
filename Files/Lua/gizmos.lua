local in_move = false;
local selected;
local touch;
local laser;
local camera;
local triangles;
local vertices;
local foo;
local slide;
vertex = nil;
test = nil;
local collider;
local wireframe;

function start()
  slide = Input:getAxisValue("touch");
  touch = Input:getTouch(0);
  laser = Laser:new();
  camera = myObject:findComponent("Camera");
  selected = WorldController:findObject("test-object");
  collider = selected:findComponent("CollidersGenerator").globals;
  vertex = selected:findComponent("ModelRenderer"):getVertex();
  triangles = vertex:getTriangles();
  vertices = vertex:getVertices();

  wireframe = Wireframe:new();
  wireframe.line_width = 0.003;
  wireframe.w_vertex = Vertex:new();
  local m = ModelRenderer:new();
  m:setMaterial(Material:new());
  wireframe:make(vertex);
  m:setVertex(wireframe.w_vertex);
  selected:addComponent(m);
end

function setup_vars()
  selected = WorldController:findObject("test-object");
  vertex = selected:findComponent("ModelRenderer"):getVertex();
  vertices = vertex:getVertices();
  triangles = vertex:getTriangles();
end

function update()
  setup_vars();
  
  if touch:isPressed() then
    if not in_move then
      trace_laser();
    end
  else
    if in_move then
      update_collider();
    end
    in_move = false;
    EditorData.in_move = false;
  end
  
  if not EditorData.in_zoom then
    move();
  end
end

function update_collider()
  LuaInvoker:invoke("update_colliders", collider);
end

function trace_laser()
  local layer = PhysicsLayers:findByName("gizmos");
  local direction = camera:screenPointNormal(touch:getPosition());
  local hit = laser:trace(myTransform:getGlobalPosition(), direction, 0, layer);
  
  if hit then
    in_move = true;
    EditorData.in_move = true;
    foo = hit:getColliderObject();
    test = get_vertices(foo);
  end
end

function move()
  if in_move then
    if foo:getName() == "gizmo_x" then
      move_face(test, slide:getX() / 40);
    end
    
    if foo:getName() == "gizmo_y" then
      move_face_y(test, slide:getY() / 40);
    end
    
    if foo:getName() == "gizmo_z" then
      move_face_z(test, slide:getX() / 40);
    end

    wireframe:make(vertex);
  end
end

function move_face(face, value)
  if face then
    local a = vertices:get(face:getX());
    local b = vertices:get(face:getY());
    local c = vertices:get(face:getZ());
  
    a:sumX(value);
    b:sumX(value);
    c:sumX(value);
  end
  
  vertex:setVertices(vertices);
end

function move_face_y(face, value)
  if face then
    local a = vertices:get(face:getX());
    local b = vertices:get(face:getY());
    local c = vertices:get(face:getZ());
  
    a:sumY(value);
    b:sumY(value);
    c:sumY(value);
  end
  
  vertex:setVertices(vertices);
end

function move_face_z(face, value)
  if face then
    local a = vertices:get(face:getX());
    local b = vertices:get(face:getY());
    local c = vertices:get(face:getZ());
  
    a:sumZ(value);
    b:sumZ(value);
    c:sumZ(value);
  end
  
  vertex:setVertices(vertices);
end

function get_vertices(object)
  local data = object:findComponent("gizmo_data").globals;
  local face = LuaInvoker:invoke("get", data);

  for i=0, triangles:size() - 1, 1 do
    if is_equals(face, triangles:get(i)) then
      return triangles:get(i);
    end
  end
end

function is_equals(a, b)
  equals = true;
  b = get_vertices_from_triangle(b);
  
  for i=0, 2, 1 do
    if not a:get(i):equals(b:get(i)) then
      equals = false;
    end
  end
  
  return equals;
end

function get_vertices_from_triangle(triangle)
  local vertice = AList:new();
  
  vertice:add(vertices:get(triangle:getX()))
  vertice:add(vertices:get(triangle:getY()))
  vertice:add(vertices:get(triangle:getZ()))
  
  return vertice;
end









