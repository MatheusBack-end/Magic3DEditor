local sens = 10.5

local touch = nil
local pivot_x = nil
local camera = nil
local camera_component = nil
local laser = nil

function start()
  laser = Laser:new()
  touch = Input:getAxisValue("touch")
  pivot_x = myObject:findChildObject("pivot-x")
  camera = pivot_x:findChildObject("camera")
  camera_component = camera:findComponent("Camera")
end

function update()
  if Input:getTouch(0):isDown() then
    local hit = laser:trace(camera:getGlobalPosition(), 
      camera_component:screenPointNormal(Input:getTouchPosition(0)),
      100.5)

    Console:log(hit ~= nil)

    if hit ~= nil then
      local tst = "c"--hit:getCollider():getVertex():getVertices():get(0)

      Console:log(tst)
    end
  end

  myTransform:rotateInSeconds(0, -touch:getX() * sens, 0)
  pivot_x:rotateInSeconds(touch:getY() * sens, 0, 0)
end
