--[[
Opos Kit / Slang v0.4
Adds modern slang, meme terms, gaming language, and internet abbreviations.
This blueprint does not talk to users directly.
It writes its kit table into castle.sharedStorage.opos_ai.Dako.kits["slang_core"].
Dako then reads sharedStorage and builds the brain from the installed kits.
Drag this blueprint into the scene and preview it. Do not spawn it from code.
]]

local kit={
  ["abbreviations"]={
    ["afaik"]="as far as i know",
    ["afk"]="away from keyboard",
    ["asap"]="as soon as possible",
    ["btw"]="by the way",
    ["dm"]="direct message",
    ["gg"]="good game",
    ["idk"]="i do not know",
    ["imo"]="in my opinion",
    ["irl"]="in real life",
    ["ngl"]="not gonna lie",
    ["tbh"]="to be honest",
    ["wp"]="well played"
  },
  ["id"]="slang_core",
  ["name"]="Slang Kit",
  ["slang"]={
    ["ate"]="performed very well",
    ["aura"]="vibe presence or charisma",
    ["based"]="bold or strongly approved",
    ["bet"]="okay or agreement",
    ["brainrot"]="absurd repetitive internet humor",
    ["bro"]="friend dude or casual address",
    ["brochacho"]="funny exaggerated version of bro",
    ["bruh"]="surprise disbelief disappointment or calling out something dumb",
    ["bussin"]="very good, usually food",
    ["cap"]="lie or exaggeration",
    ["caught in 4k"]="caught clearly doing something",
    ["cooked"]="ruined, tired, in trouble, or done for",
    ["cooking"]="doing well or making progress",
    ["cringe"]="embarrassing or awkward",
    ["dogwater"]="very bad",
    ["fr"]="for real",
    ["frfr"]="for real for real",
    ["goofy ahh"]="silly or ridiculous",
    ["gyatt"]="exaggerated reaction to attraction, mostly meme slang",
    ["lore accurate"]="matching the original story or expected behavior",
    ["main character"]="person acting like the focus of the story",
    ["mid"]="average or unimpressive",
    ["no cap"]="no lie or seriously",
    ["npc"]="someone acting predictable or robotic",
    ["ratio"]="reply getting more approval than original post",
    ["rizz"]="charisma or flirting skill",
    ["side quest"]="random extra task or distraction",
    ["sigma"]="confident independent person, often a meme",
    ["skibidi"]="nonsense meme word from brainrot humor",
    ["skill issue"]="joking claim that a failure is due to lack of skill",
    ["slay"]="perform impressively",
    ["sus"]="suspicious",
    ["touch grass"]="go outside or take a break from online behavior",
    ["valid"]="acceptable or good",
    ["vibe check"]="judging the mood or energy"
  },
  ["version"]="0.4.0"
}

local function root()
  castle.sharedStorage.opos_ai=castle.sharedStorage.opos_ai or {}
  castle.sharedStorage.opos_ai.Dako=castle.sharedStorage.opos_ai.Dako or {}
  castle.sharedStorage.opos_ai.Dako.kits=castle.sharedStorage.opos_ai.Dako.kits or {}
  return castle.sharedStorage.opos_ai.Dako
end

local function publish()
  local r=root()
  r.kits[kit.id]=kit
  r.last_update=os.time and os.time() or 0
  local dako=castle.closestActorWithTag("Dako")
  if dako then dako:sendMessage("opos_kits_updated",{id=kit.id}) end
end

function onCreate()
  publish()
end

function onUpdate(dt)
end
