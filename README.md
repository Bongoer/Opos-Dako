# Opos AI - Dako v0.4

Dako is split into one AI actor and multiple kit blueprints.

## The important change in v0.4

Kits do not send huge data directly to Dako by message anymore.
Each kit writes its structured Lua table into:

```lua
castle.sharedStorage.opos_ai.Dako.kits[kit.id]
```

Then Dako reads `castle.sharedStorage.opos_ai.Dako.kits` and builds its brain from the installed kits.

## Folders

- `opos_ai/Dako` - main Dako brain actor. Add tag `Dako`.
- `opos_ai/DakoInput` - input actor using `my.text.content`.
- `opos_ai/DakoOutput` - output actor using `my.text.content`.
- `opos_kit/EnglishCoreKit` - 20,000+ bootstrap vocabulary records, definitions, synonyms, contractions, misspellings, emoji text names.
- `opos_kit/GrammarKit` - grammar patterns, question forms, connectors, response templates.
- `opos_kit/SlangKit` - modern slang, meme terms, internet abbreviations.
- `opos_kit/MathKit` - arithmetic, mathematics, geometry, formulas, constants, Einstein and relativity concepts.
- `opos_kit/GeneralKnowledgeKit` - starter world knowledge.
- `opos_kit/SpaceKnowledgeKit` - astronomy, black holes, gravitational lensing, Einstein ring, relativity, universe facts.

## Setup in Castle

1. Drag Dako into the scene and preview it.
2. Add the tag `Dako` to the Dako actor.
3. Drag DakoInput and DakoOutput into the scene and preview them.
4. Add Text components to DakoInput and DakoOutput.
5. Drag every kit blueprint into the scene and preview it.
6. Kits publish themselves to sharedStorage.
7. Dako loads the sharedStorage data.

## Missing kits

If a required kit is missing, Dako draws a simple warning icon using `castle.draw` and lists the missing kit names.

## Message API

Input to Dako:

```lua
dako:sendMessage("opos_chat", { id = 1, text = "what is an einstein ring" })
```

Output subscribes:

```lua
dako:sendMessage("opos_subscribe", {})
```

Dako response:

```lua
actor:sendMessage("opos_response", { id = 1, model = "Dako", text = "..." })
```

## Notes

No server access is used.
No emoji glyphs are used, only emoji text names.
The current project is symbolic, not an LLM yet.
