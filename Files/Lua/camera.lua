local touchs = {nil, nil, nil};
local camera;
local pivot_x;
local in_zoom = false;
local last_distance = 0;
local sensitivity = 11.3;

function start()
  set_touchs();
  set_pivots();
end

function set_touchs()
  touchs[1] = Input:getAxisValue("touch");
  
  for i=2, 3, 1 do
    touchs[i] = Input:getTouch(i - 2);
  end
end

function set_pivots()
  pivot_x = myObject:findChildObject("pivot-x");
  camera = pivot_x:findChildObject("camera");
end

function update()
  zoom();
  
  if not in_zoom and EditorData.in_move == false then
    myTransform:rotateInSeconds(0, -touchs[1]:getX() * sensitivity, 0);
    pivot_x:rotateInSeconds(touchs[1]:getY() * sensitivity, 0, 0);
  end
end

function apply_zoom(value)
  camera:moveInSeconds(0, 0, value);
  in_zoom = true;
  EditorData.in_zoom = true;
end

function zoom()
  if touchs[2]:isPressed() and touchs[3]:isPressed() then
    local distance = touchs[2]:getPosition():distance(touchs[3]:getPosition());
    
    if last_distance == 0 then
      last_distance = distance;
    end
    
    apply_zoom(distance - last_distance)
    last_distance = distance
  else
    last_distance = 0;
    in_zoom = false;
    EditorData.in_zoom = false;
  end
end
