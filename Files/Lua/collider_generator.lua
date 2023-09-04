local triangles;
local vertices;
local utils;

function createFace(face)
	local collider = Collider:new();
  local vertex = Vertex:new();
  local face_triangles = AList:new();
  local face_vertices = utils:getVerticesFromTriangle(face, vertices);

  face_triangles:add(utils:createVector3(0, 1, 2));
  vertex:setVertices(face_vertices);
  vertex:setTriangles(face_triangles);
  collider:setVertex(vertex);
	
  return collider;
end

function update_face(face, collider)
  local vertex = Vertex:new();
  local face_triangles = AList:new();
  local face_vertices = utils:getVerticesFromTriangle(face, vertices);
  face_triangles:add(utils:createVector3(0, 1, 2));
  vertex:setVertices(face_vertices);
  vertex:setTriangles(face_triangles);
  collider:setVertex(vertex);
end

function generate()
	setupVars();

  for i = 0, triangles:size() -1, 1 do
    myObject:addComponent(createFace(triangles:get(i)));
  end
end

function setupVars()
	local vertex = myObject:findComponent("ModelRenderer"):getVertex();
	utils = LuaInstance:newInstance(myObject, "myutils");
	vertices = vertex:getVertices();
	triangles = vertex:getTriangles();
end

function update_colliders()
  setupVars();
  local colliders = myObject:findComponents("Collider");
  
  for i=0, triangles:size() -1, 1 do
    update_face(triangles:get(i), colliders:get(i));
  end
end

function start()
  generate();
  update_colliders();
end

function update()end
