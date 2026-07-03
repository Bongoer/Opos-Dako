--[[
Opos AI / Dako Output Blueprint v0.4

Setup:
1. Drag this blueprint into the scene and preview it.
2. Add a Text component to this blueprint.
3. It subscribes to Dako and displays opos_status/opos_response through my.text.content.
]]
local t=0
local function setText(s)pcall(function() if my and my.text then my.text.content=s or "" end end)end
local function subscribe()
  local dako=castle.closestActorWithTag("Dako")
  if dako then dako:sendMessage("opos_subscribe",{}) else setText("Waiting for Dako tag...") end
end
function onCreate()setText("Waiting for Dako...") subscribe()end
function onMessage(message,triggeringActor,data)
  if message=="opos_status" and data then
    if data.thinking then setText((data.model or "Dako").." is thinking: "..(data.stage or "working")) elseif data.status then setText(data.status) end
  elseif message=="opos_response" and data then setText(data.text or "") end
end
function onUpdate(dt)t=t+dt if t>2 then t=0 subscribe() end end
