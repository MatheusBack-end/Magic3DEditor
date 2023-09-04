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

function start()
  laser = Laser:new()
  touch = Input:getAxisValue("touch")
  pivot_x = myObject:findChildObject("pivot-x")
  camera = pivot_x:findChildObject("camera")
  camera_component = camera:findComponent("Camera")

  gizmo_x = WorldController:findObject("gizmo_x")
  gizmo_y = WorldController:findObject("gizmo_y")
  gizmo_z = WorldController:findObject("gizmo_z")
end

function update()
  if is_down and Input:getTouch(0):isDown() == false then
    traceLaser()
  end

  is_down = Input:getTouch(0):isDown()
  
  myTransform:rotateInSeconds(0, -touch:getX() * sens, 0)
  pivot_x:rotateInSeconds(touch:getY() * sens, 0, 0)

  
end
