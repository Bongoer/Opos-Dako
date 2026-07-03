--[[
Opos AI / Dako Blueprint v0.4

Setup:
1. Drag this Dako blueprint into the scene and preview it.
2. Add the tag "Dako" to the Dako actor.
3. Drag kit blueprints from opos_kit into the scene and preview them.
4. Kits write their data into castle.sharedStorage.opos_ai.Dako.kits.
5. Dako reads sharedStorage, checks required kits, and answers messages.
6. Input sends opos_chat to Dako. Dako sends opos_status and opos_response back.

Important:
Kits do not send huge data directly by actor message anymore.
Kits publish tables into sharedStorage. Dako uses those tables.
]]

local model={name="Dako",company="Opos AI",version="0.4.0",license="MIT"}
local required={english_core=true,grammar_core=true,slang_core=true,math_core=true,general_knowledge=true,space_knowledge=true}
local requiredName={english_core="English Core Kit",grammar_core="Grammar Kit",slang_core="Slang Kit",math_core="Math Kit",general_knowledge="General Knowledge Kit",space_knowledge="Space Knowledge Kit"}
local state={ready=false,thinking=false,stage="loading",timer=0,t=0,current=nil,jobs={},subscribers={},lastResponse="Dako is loading sharedStorage kits.",missing={}}
local brain={dictionary={},definitions={},facts={},slang={},synonyms={},misspellings={},contractions={},emoji_names={},phrases={},grammar={},math={},relations={},categories={},kits={}}

local function low(s)return string.lower(s or "")end
local function trim(s)return(s or ""):gsub("^%s+",""):gsub("%s+$","")end
local function has(s,q)return string.find(low(s),low(q),1,true)~=nil end
local function clean(s)return low(s or ""):gsub("[?!.;,:"]","")end
local function cap(s)s=trim(s or "") if s=="" then return s end return string.upper(string.sub(s,1,1))..string.sub(s,2)end
local function merge(dst,src)if not src then return end for k,v in pairs(src)do dst[k]=v end end
local function deepMerge(dst,src)if not src then return end for k,v in pairs(src)do if type(v)=="table" and type(dst[k])=="table" then deepMerge(dst[k],v)else dst[k]=v end end end
local function send(actor,msg,data)if actor then pcall(function()actor:sendMessage(msg,data)end)end end
local function notify(msg,data)for i=#state.subscribers,1,-1 do local a=state.subscribers[i] if a then send(a,msg,data)else table.remove(state.subscribers,i)end end end

local function root()
  castle.sharedStorage.opos_ai=castle.sharedStorage.opos_ai or {}
  castle.sharedStorage.opos_ai.Dako=castle.sharedStorage.opos_ai.Dako or {}
  castle.sharedStorage.opos_ai.Dako.model=castle.sharedStorage.opos_ai.Dako.model or model
  castle.sharedStorage.opos_ai.Dako.kits=castle.sharedStorage.opos_ai.Dako.kits or {}
  castle.sharedStorage.opos_ai.Dako.learned=castle.sharedStorage.opos_ai.Dako.learned or {facts={},phrases={},corrections={}}
  return castle.sharedStorage.opos_ai.Dako
end

local function resetBrain()
  brain={dictionary={},definitions={},facts={},slang={},synonyms={},misspellings={},contractions={},emoji_names={},phrases={},grammar={},math={},relations={},categories={},kits={}}
end

local function loadKits()
  local r=root()
  resetBrain()
  state.missing={}
  for id,_ in pairs(required)do if not r.kits[id] then state.missing[#state.missing+1]=id end end
  for id,kit in pairs(r.kits)do
    brain.kits[id]=true
    merge(brain.dictionary,kit.dictionary)
    merge(brain.definitions,kit.definitions)
    merge(brain.facts,kit.facts)
    merge(brain.slang,kit.slang)
    merge(brain.synonyms,kit.synonyms)
    merge(brain.misspellings,kit.misspellings)
    merge(brain.contractions,kit.contractions)
    merge(brain.emoji_names,kit.emoji_names)
    deepMerge(brain.phrases,kit.phrases)
    deepMerge(brain.grammar,kit.grammar)
    deepMerge(brain.math,kit.math)
    deepMerge(brain.relations,kit.relations)
    deepMerge(brain.categories,kit.categories)
  end
  if r.learned then
    merge(brain.facts,r.learned.facts)
    merge(brain.phrases,r.learned.phrases)
    merge(brain.misspellings,r.learned.corrections)
  end
  state.ready=#state.missing==0
  if state.ready then state.stage="ready" state.lastResponse="Dako is ready." else state.stage="missing_kits" end
end

local function missingText()
  if #state.missing==0 then return "No missing kits." end
  local s="Dako cannot start. Missing kits:"
  for i,id in ipairs(state.missing)do s=s.."\n- "..(requiredName[id] or id).." ("..id..")" end
  return s
end

local function words(s)local t={} for w in string.gmatch(clean(s),"%S+")do t[#t+1]=w end return t end
local function canon(w)w=low(w or "") return brain.misspellings[w] or brain.synonyms[w] or w end
local function factThing(k)local f=brain.facts[low(k or "")] if type(f)=="table" then return f.type or f.definition or f.meaning end if type(f)=="string" then return f end return nil end

local function mathEval(expr)
  expr=(expr or ""):gsub("%s+",""):gsub("×","*"):gsub("÷","/")
  if expr=="" or string.find(expr,"[^0-9%+%-%*/%%%(% )%.]") or not string.find(expr,"[0-9]") or not string.find(expr,"[%+%-%*/%%%(%)]") then return nil end
  local i=1
  local function peek()return string.sub(expr,i,i)end
  local function eat(c)if peek()==c then i=i+1 return true end return false end
  local parseExpression,parseTerm,parseFactor
  parseFactor=function()
    if eat("+")then return parseFactor()end
    if eat("-")then local v=parseFactor() if v==nil then return nil end return -v end
    if eat("(")then local v=parseExpression() if v==nil or not eat(")")then return nil end return v end
    local st=i while string.find(peek(),"[0-9%.]")do i=i+1 end
    if st==i then return nil end
    return tonumber(string.sub(expr,st,i-1))
  end
  parseTerm=function()
    local v=parseFactor() if v==nil then return nil end
    while true do
      if eat("*")then local r=parseFactor() if r==nil then return nil end v=v*r
      elseif eat("/")then local r=parseFactor() if r==nil or r==0 then return nil end v=v/r
      elseif eat("%")then local r=parseFactor() if r==nil or r==0 then return nil end v=v%r
      else break end
    end
    return v
  end
  parseExpression=function()
    local v=parseTerm() if v==nil then return nil end
    while true do
      if eat("+")then local r=parseTerm() if r==nil then return nil end v=v+r
      elseif eat("-")then local r=parseTerm() if r==nil then return nil end v=v-r
      else break end
    end
    return v
  end
  local r=parseExpression() if r==nil or i<=#expr then return nil end
  if math.floor(r)==r then return tostring(r) end
  return tostring(math.floor(r*100000+0.5)/100000)
end

local function learnFact(a,b)
  local r=root()
  r.learned.facts[low(a)]={type=b,learned=true}
  brain.facts[low(a)]={type=b,learned=true}
end

local function answer(msg)
  local raw=trim(msg or "")
  local m=clean(raw)
  if raw=="" then return "Type something first." end
  local ma=mathEval(raw) if ma then return raw.." = "..ma end
  local a,b=string.match(m,"^teach me that (.-) is (.+)$") if a and b then learnFact(a,b) return "Learned. "..cap(a).." is "..b.."." end
  local n=string.match(m,"^what is an? (.+)$") or string.match(m,"^what is (.+)$")
  if n then
    n=canon(n)
    if brain.slang[n] then return cap(n).." means "..brain.slang[n].."." end
    if brain.definitions[n] then return cap(n).." means "..brain.definitions[n].."." end
    local f=factThing(n) if f then return cap(n).." is "..f.."." end
    if brain.math and brain.math.geometry and brain.math.geometry[n] then return cap(n).." is "..brain.math.geometry[n].."." end
    if brain.math and brain.math.physics_math and brain.math.physics_math[n] then return cap(n).." is "..brain.math.physics_math[n] end
    return "I do not know what "..n.." is yet. Teach me with: teach me that "..n.." is something."
  end
  if m=="hi" or m=="hey" or m=="hello" or m=="yo" or m=="sup" then return "Hey. I am Dako. I can talk, do math, understand slang, and use installed knowledge kits." end
  if has(m,"missing") or has(m,"kits") then return missingText() end
  if has(m,"einstein ring") then return "An Einstein ring is a ring shaped image caused by gravitational lensing when a massive object bends light from a background object." end
  if has(m,"einstein") then return "Albert Einstein is linked to relativity, E = mc^2, spacetime, and gravitational lensing." end
  if has(m,"space") then return "Space is the vast region beyond Earth atmosphere. The Space Knowledge Kit includes planets, galaxies, black holes, relativity, gravitational lensing, and Einstein rings." end
  if has(m,"geometry") then return "Geometry studies shapes, size, distance, angles, area, volume, and space." end
  if has(m,"math") or has(m,"mathematics") then return "Mathematics studies numbers, patterns, shapes, logic, and change. The Math Kit includes arithmetic, formulas, constants, geometry, and relativity concepts." end
  local ws=words(m) for i=1,#ws do local w=canon(ws[i]) if brain.slang[w] then return cap(w).." means "..brain.slang[w].."." end end
  return "I understand the sentence, but I need a clearer question or more knowledge from kits. Ask what something is, use math, or teach me a fact."
end

local function startJob(actor,data)
  if not state.ready then send(actor,"opos_response",{model=model.name,text=missingText(),error=true}) return end
  state.jobs[#state.jobs+1]={actor=actor,id=data and data.id or 0,text=data and data.text or ""}
end

local function beginNext()
  if state.thinking or #state.jobs==0 then return end
  state.current=table.remove(state.jobs,1)
  state.thinking=true
  state.timer=0.55+math.min(#state.current.text*0.025,2.5)
  state.stage="understanding"
  notify("opos_status",{model=model.name,thinking=true,stage=state.stage})
  send(state.current.actor,"opos_status",{model=model.name,thinking=true,stage=state.stage,id=state.current.id})
end

function onCreate()
  root()
  loadKits()
end

function onMessage(message,triggeringActor,data)
  if message=="opos_chat" then startJob(triggeringActor,data or {})
  elseif message=="opos_subscribe" then state.subscribers[#state.subscribers+1]=triggeringActor send(triggeringActor,"opos_status",{model=model.name,status=state.ready and "Dako ready" or missingText()})
  elseif message=="opos_kits_updated" then loadKits() notify("opos_status",{model=model.name,status=state.ready and "Dako loaded sharedStorage kits" or missingText()})
  elseif message=="opos_reload_kits" then loadKits()
  end
end

function onUpdate(dt)
  state.t=state.t+dt
  if not state.ready and state.t>1 then state.t=0 loadKits() end
  beginNext()
  if state.thinking then
    state.timer=state.timer-dt
    if state.timer<1.5 and state.stage=="understanding" then state.stage="searching kits" notify("opos_status",{model=model.name,thinking=true,stage=state.stage}) end
    if state.timer<0.75 and state.stage=="searching kits" then state.stage="writing" notify("opos_status",{model=model.name,thinking=true,stage=state.stage}) end
    if state.timer<=0 then
      local text=answer(state.current.text)
      state.lastResponse=text
      send(state.current.actor,"opos_response",{model=model.name,id=state.current.id,text=text,thinking=false})
      notify("opos_response",{model=model.name,id=state.current.id,text=text,thinking=false})
      state.current=nil state.thinking=false state.stage="ready"
    end
  end
end

local function drawText(s,x,y,size,r,g,b,ax,ay)castle.draw.setColor(r,g,b,1) castle.draw.text(s,x,y,size,ax or "center",ay or "center")end
local function rect(x,y,w,h,r,g,b,a)castle.draw.setColor(r,g,b,a or 1) castle.draw.rectangle("fill",x,y,w,h)end
function onDraw()
  if #state.missing>0 then
    rect(-1.2,-1.2,2.4,2.4,0.45,0.05,0.06,0.95)
    drawText("!",0,-0.25,6,1,1,1,"center","center")
    drawText("Missing Dako kits",0,1.25,3,1,0.85,0.85,"center","center")
    local y=1.85
    for i,id in ipairs(state.missing)do drawText(requiredName[id] or id,0,y,2.2,1,1,1,"center","center") y=y+0.42 end
  end
end
