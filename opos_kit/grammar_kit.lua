--[[
Opos Kit / Grammar v0.4
Adds question forms, sentence kinds, connectors, grammar patterns, and response templates.
This blueprint does not talk to users directly.
It writes its kit table into castle.sharedStorage.opos_ai.Dako.kits["grammar_core"].
Dako then reads sharedStorage and builds the brain from the installed kits.
Drag this blueprint into the scene and preview it. Do not spawn it from code.
]]

local kit={
  ["grammar"]={
    ["connectors"]={
      ["although"]="shows contrast",
      ["and"]="adds information",
      ["because"]="gives a reason",
      ["but"]="shows contrast",
      ["however"]="shows contrast",
      ["if"]="starts a condition",
      ["or"]="offers alternatives",
      ["then"]="shows consequence",
      ["therefore"]="shows result"
    },
    ["patterns"]={
      {
        ["intent"]="define",
        ["pattern"]="what is {thing}"
      },
      {
        ["intent"]="identify_person",
        ["pattern"]="who is {person}"
      },
      {
        ["intent"]="explain_reason",
        ["pattern"]="why is {thing} {property}"
      },
      {
        ["intent"]="instructions",
        ["pattern"]="how do i {action}"
      },
      {
        ["intent"]="explain_process",
        ["pattern"]="how does {thing} work"
      },
      {
        ["intent"]="classify",
        ["pattern"]="is {a} a {b}"
      },
      {
        ["intent"]="remember",
        ["pattern"]="remember my {key} is {value}"
      },
      {
        ["intent"]="learn_fact",
        ["pattern"]="teach me that {a} is {b}"
      }
    },
    ["question_words"]={
      "what",
      "why",
      "how",
      "when",
      "where",
      "who",
      "which",
      "can",
      "could",
      "would",
      "should",
      "do",
      "does",
      "did",
      "is",
      "are",
      "was",
      "were"
    },
    ["response_templates"]={
      ["define"]={
        "{term} means {meaning}.",
        "{term} is {meaning}."
      },
      ["memory"]={
        "Got it. I will remember {key} = {value}."
      },
      ["reason"]={
        "The likely reason is {reason}."
      },
      ["unknown"]={
        "I do not know that yet. Teach me with: teach me that {term} is {meaning}."
      }
    },
    ["sentence_kinds"]={
      ["command"]="asks for action",
      ["exclamation"]="shows strong emotion",
      ["question"]="asks for information",
      ["statement"]="gives information"
    }
  },
  ["id"]="grammar_core",
  ["name"]="Grammar Kit",
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
