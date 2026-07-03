--[[
Opos Kit / Space Knowledge v0.4
Adds space, astronomy, relativity, gravitational lensing, Einstein ring, black holes, and universe knowledge.
This blueprint does not talk to users directly.
It writes its kit table into castle.sharedStorage.opos_ai.Dako.kits["space_knowledge"].
Dako then reads sharedStorage and builds the brain from the installed kits.
Drag this blueprint into the scene and preview it. Do not spawn it from code.
]]

local kit={
  ["facts"]={
    ["asteroid"]={
      ["type"]="small rocky body orbiting the Sun"
    },
    ["black hole"]={
      ["type"]="region where gravity is so strong that not even light escapes"
    },
    ["comet"]={
      ["type"]="icy object that can form a tail near the Sun"
    },
    ["dark energy"]={
      ["type"]="unknown cause of accelerated expansion of the universe"
    },
    ["dark matter"]={
      ["type"]="unseen matter inferred from gravity"
    },
    ["einstein ring"]={
      ["type"]="ring shaped image caused by gravitational lensing when a massive object bends light from a background object"
    },
    ["event horizon"]={
      ["type"]="boundary around a black hole beyond which light cannot escape"
    },
    ["galaxy"]={
      ["type"]="huge system of stars gas dust and dark matter"
    },
    ["general relativity"]={
      ["type"]="Einstein theory that gravity is curvature of spacetime"
    },
    ["gravitational lensing"]={
      ["type"]="bending of light by gravity, predicted by general relativity"
    },
    ["light year"]={
      ["type"]="distance light travels in one year"
    },
    ["meteor"]={
      ["type"]="space rock burning in an atmosphere"
    },
    ["milky way"]={
      ["type"]="the galaxy that contains the Solar System"
    },
    ["moon"]={
      ["type"]="natural satellite"
    },
    ["nebula"]={
      ["type"]="cloud of gas and dust in space"
    },
    ["planet"]={
      ["type"]="large round body orbiting a star"
    },
    ["redshift"]={
      ["type"]="stretching of light to longer wavelengths as objects move away or space expands"
    },
    ["solar system"]={
      ["type"]="the Sun and objects gravitationally bound to it"
    },
    ["space"]={
      ["type"]="the vast region beyond Earth atmosphere"
    },
    ["spacetime"]={
      ["type"]="the combined fabric of space and time"
    },
    ["star"]={
      ["type"]="hot glowing ball of plasma powered by fusion"
    },
    ["supernova"]={
      ["type"]="explosion of a star"
    },
    ["universe"]={
      ["type"]="all space time matter and energy"
    }
  },
  ["id"]="space_knowledge",
  ["name"]="Space Knowledge Kit",
  ["relations"]={
    ["black hole"]={
      ["has"]="event horizon",
      ["related_to"]="gravity"
    },
    ["earth"]={
      ["has_moon"]="Moon",
      ["orbits"]="sun"
    },
    ["einstein ring"]={
      ["caused_by"]="gravitational lensing",
      ["related_to"]="general relativity"
    },
    ["moon"]={
      ["orbits"]="earth"
    }
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
