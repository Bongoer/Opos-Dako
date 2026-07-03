--[[
Opos Kit / Math v0.4
Adds mathematics, geometry, formulas, constants, and Einstein/relativity related math knowledge.
This blueprint does not talk to users directly.
It writes its kit table into castle.sharedStorage.opos_ai.Dako.kits["math_core"].
Dako then reads sharedStorage and builds the brain from the installed kits.
Drag this blueprint into the scene and preview it. Do not spawn it from code.
]]

local kit={
  ["id"]="math_core",
  ["math"]={
    ["constants"]={
      ["e"]="approximately 2.71828",
      ["phi"]="approximately 1.61803",
      ["pi"]="approximately 3.14159",
      ["tau"]="approximately 6.28318"
    },
    ["formulas"]={
      ["circle area"]="pi*r*r",
      ["circle circumference"]="2*pi*r",
      ["pythagorean theorem"]="a^2+b^2=c^2",
      ["quadratic formula"]="x=(-b plus or minus sqrt(b^2-4ac))/(2a)",
      ["rectangle area"]="width*height",
      ["slope"]="rise/run",
      ["sphere volume"]="4/3*pi*r^3",
      ["triangle area"]="base*height/2"
    },
    ["geometry"]={
      ["angle"]="space between two rays",
      ["area"]="amount of surface inside a shape",
      ["circle"]="set of points at equal distance from a center",
      ["circumference"]="distance around a circle",
      ["cone"]="3D shape with circular base and one point",
      ["cube"]="3D shape with six equal square faces",
      ["cylinder"]="3D shape with two circular bases",
      ["diameter"]="distance across a circle through the center",
      ["line"]="a straight path extending in both directions",
      ["line segment"]="part of a line with two endpoints",
      ["perimeter"]="distance around a polygon",
      ["point"]="a location with no size",
      ["radius"]="distance from center to circle edge",
      ["ray"]="part of a line with one endpoint",
      ["rectangle"]="polygon with four right angles",
      ["sphere"]="3D shape where all surface points are equal distance from center",
      ["square"]="polygon with four equal sides and four right angles",
      ["triangle"]="polygon with three sides",
      ["volume"]="amount of 3D space inside an object"
    },
    ["number_words"]={
      ["eight"]=8,
      ["eighteen"]=18,
      ["eleven"]=11,
      ["fifteen"]=15,
      ["five"]=5,
      ["four"]=4,
      ["fourteen"]=14,
      ["nine"]=9,
      ["nineteen"]=19,
      ["one"]=1,
      ["seven"]=7,
      ["seventeen"]=17,
      ["six"]=6,
      ["sixteen"]=16,
      ["ten"]=10,
      ["thirteen"]=13,
      ["three"]=3,
      ["twelve"]=12,
      ["twenty"]=20,
      ["two"]=2,
      ["zero"]=0
    },
    ["operations"]={
      ["add"]={
        "add",
        "plus",
        "sum",
        "total",
        "increase"
      },
      ["divide"]={
        "divide",
        "over",
        "quotient"
      },
      ["multiply"]={
        "multiply",
        "times",
        "product"
      },
      ["percent"]={
        "percent",
        "percentage"
      },
      ["power"]={
        "power",
        "exponent",
        "squared",
        "cubed"
      },
      ["subtract"]={
        "subtract",
        "minus",
        "take away",
        "difference",
        "decrease"
      }
    },
    ["physics_math"]={
      ["e equals mc squared"]="mass and energy are equivalent: energy equals mass times the speed of light squared.",
      ["einstein"]="Albert Einstein developed relativity, including E = mc^2 and general relativity.",
      ["general relativity"]="gravity is explained as curvature of spacetime.",
      ["relativity"]="a theory about space, time, gravity, and motion.",
      ["special relativity"]="physics of high speed motion with constant light speed."
    }
  },
  ["name"]="Math and Geometry Kit",
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
