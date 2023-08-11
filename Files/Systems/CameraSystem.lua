local sens = 10.5
local touch = nil
local pivot_x = nil
local camera = nil
local camera_component = nil
local laser = nil
local gizmo_x = nil

function start()
  laser = Laser:new()
  touch = Input:getAxisValue("touch")
  pivot_x = myObject:findChildObject("pivot-x")
  camera = pivot_x:findChildObject("camera")
  camera_component = camera:findComponent("Camera")
  gizmo_x = WorldController:findObject("gizmo_x")
end

function update()
  if Input:getTouch(0):isDown() then
    traceLaser()
  end

  myTransform:rotateInSeconds(0, -touch:getX() * sens, 0)
  pivot_x:rotateInSeconds(touch:getY() * sens, 0, 0)
end
