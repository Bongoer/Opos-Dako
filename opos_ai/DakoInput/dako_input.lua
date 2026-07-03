--[[
Opos AI / Dako Input Blueprint v0.4

Setup:
1. Drag this blueprint into the scene and preview it.
2. Add a Text component to this blueprint.
3. This script displays input status using my.text.content.
4. Touch the actor to open Castle text input.
5. It finds the actor tagged "Dako" and sends opos_chat.
]]
local open=false
local cooldown=0
local requestId=0
local last=""
local function trim(s)return(s or ""):gsub("^%s+",""):gsub("%s+$","")end
local function setText(s)pcall(function() if my and my.text then my.text.content=s or "" end end)end
local function submit(text)
  local dako=castle.closestActorWithTag("Dako")
  if not dako then setText("Missing Dako actor tag: Dako") return end
  requestId=requestId+1
  setText("> "..text)
  dako:sendMessage("opos_chat",{id=requestId,text=text})
end
local function openInput()
  if open then return end
  open=true
  castle.getTextInput(function(v)
    local text=trim(v or "")
    if text~="" and text~=last then last=text submit(text) end
    open=false
  end)
end
function onCreate()setText("Tap to message Dako")end
function onMessage(message,triggeringActor,data)
  if message=="opos_status" and data and data.thinking then setText("Dako thinking: "..(data.stage or "working")) end
  if message=="opos_response" and data then setText("Tap to message Dako") end
end
function onUpdate(dt)
  cooldown=math.max(0,cooldown-dt)
  local touches=castle.getTouches()
  if #touches>0 and cooldown<=0 then cooldown=0.45 openInput() end
end
