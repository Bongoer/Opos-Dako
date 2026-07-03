--[[
Opos Kit / General Knowledge v0.4
Adds starter general world knowledge.
This blueprint does not talk to users directly.
It writes its kit table into castle.sharedStorage.opos_ai.Dako.kits["general_knowledge"].
Dako then reads sharedStorage and builds the brain from the installed kits.
Drag this blueprint into the scene and preview it. Do not spawn it from code.
]]

local kit={
  ["categories"]={
    ["animal"]={
      "dog",
      "cat",
      "human",
      "bird",
      "fish"
    },
    ["emotion"]={
      "happy",
      "sad",
      "angry",
      "afraid",
      "excited"
    },
    ["planet"]={
      "earth",
      "mars",
      "jupiter",
      "saturn"
    },
    ["science"]={
      "physics",
      "chemistry",
      "biology",
      "astronomy"
    }
  },
  ["facts"]={
    ["cat"]={
      ["class"]="mammal",
      ["sound"]="meow",
      ["type"]="animal"
    },
    ["computer"]={
      ["type"]="machine that processes information"
    },
    ["dog"]={
      ["class"]="mammal",
      ["sound"]="bark",
      ["type"]="animal"
    },
    ["earth"]={
      ["moon"]="Moon",
      ["type"]="planet"
    },
    ["fire"]={
      ["type"]="rapid oxidation with heat and light"
    },
    ["food"]={
      ["type"]="substance organisms eat for energy"
    },
    ["history"]={
      ["type"]="study of past events"
    },
    ["human"]={
      ["class"]="mammal",
      ["type"]="animal"
    },
    ["internet"]={
      ["type"]="global network of connected computers"
    },
    ["language"]={
      ["type"]="system for communication"
    },
    ["music"]={
      ["type"]="organized sound used for expression"
    },
    ["rain"]={
      ["type"]="water falling from clouds"
    },
    ["science"]={
      ["type"]="method for studying the natural world"
    },
    ["snow"]={
      ["type"]="ice crystals falling from clouds"
    },
    ["sun"]={
      ["type"]="star"
    },
    ["water"]={
      ["formula"]="H2O",
      ["type"]="liquid"
    },
    ["weather"]={
      ["type"]="condition of the atmosphere"
    }
  },
  ["id"]="general_knowledge",
  ["name"]="General Knowledge Kit",
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
