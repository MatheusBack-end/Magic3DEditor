local laser;
local touch;
local camera, camera_pivot;
local gizmo = {"x", "y", "z"};
local text = {};

function start()
  laser = Laser:new();
  camera = myObject:findComponent("Camera");
  camera_pivot = WorldController:findObject("pivot-camera");
  touch = Input:getTouch(0);
  set_gizmos();
  set_texts();
end

function update()
  if touch:isDown() then
    trace_laser();
  end
end

function set_gizmos()
  for i=1, 3, 1 do
    gizmo[i] = WorldController:findObject("gizmo_" .. gizmo[i]);
  end
end

function set_texts()
  local sui = WorldController:findObject("SUI Interface");
  for i=1, 3, 1 do
    text[i] = sui:findChildObject("debug_text" .. i):findComponent("SUIText");
  end
end

function trace_laser()
  local layer = PhysicsLayers:findByName("default");
  local direction = camera:screenPointNormal(touch:getPosition());
  local hit = laser:trace(myTransform:getGlobalPosition(), direction, 0, layer);
  
  if hit then
    local collider = hit:getCollider();
    move_gizmos(get_center(collider), collider:getVertex():getVertices());
  end
end

function get_center(collider)
  local vertices = collider:getVertex():getVertices();
  
  local x, y, z = 0, 0, 0;
  
  for i=0, 2, 1 do
    x = x + vertices:get(i):getX();
    y = y + vertices:get(i):getY();
    z = z + vertices:get(i):getZ();
  end
  
  
  local vector3 = Vector3:new();
  vector3:setX(x / 3);
  vector3:setY(y / 3);
  vector3:setZ(z / 3);

  return vector3;
end

function move_gizmos(to, vertices)
  for k, i in ipairs(gizmo) do
    i:teleportTo(to);
    local data = i:findComponent("gizmo_data").globals;    
    hard_replace(vertices, LuaInvoker:invoke("get", data));
  end
  
  camera_pivot:teleportTo(to);
  gizmo[1]:move(0.25, 0, 0);
  gizmo[2]:move(0, 0.25, 0);
  gizmo[3]:move(0, 0, 0.25);
end

function debug_texts(vertices)
  for i=0, 2, 1 do
    text[i+1]:setText(vertices:get(i):toString());
  end
end


function hard_replace(new, old)
  old:clear();
  
  for i=0, new:size() -1, 1 do
    old:add(new:get(i));
  end
end





