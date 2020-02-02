local _G = GLOBAL

Assets =
{
}

PrefabFiles =
{
  "alloy",
  "iron",
  "smelter",
}


--------------------------------------------------------------------
-- Bybass nil function and variables
_G.MakeBlowInHurricane = function(...)
end
_G.MakeInventoryFloatable = function(...)
end
_G.TUNING.WINDBLOWN_SCALE_MIN = {
  MEDIUM = nil,
}
_G.TUNING.WINDBLOWN_SCALE_MAX = {
  MEDIUM = nil,
}


--------------------------------------------------------------------
local Ingredient = _G.Ingredient
local RECIPETABS = _G.RECIPETABS
local TECH = _G.RECIPETABS

AddRecipe(
  "smelter",
  {
    Ingredient("cutstone", 6),
    Ingredient("boards", 4),
    Ingredient("redgem", 1)
  },
  RECIPETABS.SCIENCE,
  TECH.SCIENCE_TWO,
  "smetler_placer",
  nil,
  nil,
  nil,
  nil,
  "images/smelter.xml", -- atlas
  "smelter.tex" -- image
)
AddRecipe(
  "antmaskhat",
  {
    Ingredient("chitin", 5),
    Ingredient("footballhat", 1)
  },
  RECIPETABS.WAR,
  TECH.SCIENCE_ONE
)
AddRecipe(
  "antsuit",
  {
    Ingredient("chitin", 5),
    Ingredient("armorwood", 1)
  },
  RECIPETABS.WAR,
  TECH.SCIENCE_ONE
)


--------------------------------------------------------------------
local STRINGS = GLOBAL.STRINGS
-------------------------------
if STRINGS.CHARACTERS.WALANI == nil then STRINGS.CHARACTERS.WALANI = {
  DESCRIBE = {},
} end -- DLC002
if STRINGS.CHARACTERS.WARLY == nil then STRINGS.CHARACTERS.WARLY = {
  DESCRIBE = {},
} end -- DLC002
if STRINGS.CHARACTERS.WOODLEGS == nil then STRINGS.CHARACTERS.WOODLEGS = {
  DESCRIBE = {},
} end -- DLC002
if STRINGS.CHARACTERS.WILBA == nil then STRINGS.CHARACTERS.WILBA = {
  DESCRIBE = {},
} end -- DLC003
if STRINGS.CHARACTERS.WARBUCKS == nil then STRINGS.CHARACTERS.WARBUCKS = {
  DESCRIBE = {},
} end -- DLC003
-------------------------------
-- Prefab
STRINGS.NAMES.ALLOY = "Alloy"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALLOY = "Ahoy there, alloy!"
STRINGS.CHARACTERS.WALANI.DESCRIBE.ALLOY = "Hope this is worth all the trouble."
STRINGS.CHARACTERS.WARBUCKS.DESCRIBE.ALLOY = "I say! That's useful."
STRINGS.CHARACTERS.WARLY.DESCRIBE.ALLOY = "Metal cooked to perfection."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ALLOY = "A metal worthy of the Sons of Ivaldi."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ALLOY = "Durable."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ALLOY = "Gosh. That's a lot of metal."
STRINGS.CHARACTERS.WENDY.DESCRIBE.ALLOY = "Cold and hard, like my existence."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ALLOY = "Iron that has gone through metallic bonding."
STRINGS.CHARACTERS.WILBA.DESCRIBE.ALLOY = "IS'T BLOCK O' HARD METALS"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ALLOY = "Fire makes everything better."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ALLOY = "Fire make it strong like Wolfgang."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ALLOY = "It's like a block of wood made out of metal."
STRINGS.CHARACTERS.WOODLEGS.DESCRIBE.ALLOY = "Ahoy, alloy!"
STRINGS.CHARACTERS.WX78.DESCRIBE.ALLOY = "PRECIOUS METAL"

STRINGS.NAMES.SMELTER = "Smelter"
STRINGS.RECIPE_DESC.SMELTER = "Turn Iron into Alloy"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SMELTER = "I smelt that!"
STRINGS.CHARACTERS.WALANI.DESCRIBE.SMELTER = "I'll just let that do all the work for me."
STRINGS.CHARACTERS.WARBUCKS.DESCRIBE.SMELTER = "I say, that's rather clever!"
STRINGS.CHARACTERS.WARLY.DESCRIBE.SMELTER = "'Smelt' bad, if you ask me."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SMELTER = "The tools of dwarves."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SMELTER = "Finally we're catching up to the Iron Age."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SMELTER = "Yeesh, that's hot!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.SMELTER = "It blazes with more passion than I know."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SMELTER = "A metalsmithing tool."
STRINGS.CHARACTERS.WILBA.DESCRIBE.SMELTER = "'TIS FWOOSHY MACHINES"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.SMELTER = "Oh yeah! Now I can burn metal."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SMELTER = "Fire make metal bricks."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.SMELTER = "Hrumph. A big production for a little metal."
STRINGS.CHARACTERS.WOODLEGS.DESCRIBE.SMELTER = "A cannon fer makin' metals."
STRINGS.CHARACTERS.WX78.DESCRIBE.SMELTER = "HELLO, FRIEND"

STRINGS.NAMES.IRON = "Iron Ore"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.IRON = "Isn't it ironic?"
STRINGS.CHARACTERS.WALANI.DESCRIBE.IRON = "This has gotta be good for something."
STRINGS.CHARACTERS.WARBUCKS.DESCRIBE.IRON = "A fine mineral specimen."
STRINGS.CHARACTERS.WARLY.DESCRIBE.IRON = "I wonder what I could cook up with this."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.IRON = "'Tis material for metalwork."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.IRON = "A solid mineral."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.IRON = "We could make all kinds of neat stuff with this."
STRINGS.CHARACTERS.WENDY.DESCRIBE.IRON = "Iron. Like my heart."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.IRON = "Ferrum."
STRINGS.CHARACTERS.WILBA.DESCRIBE.IRON = "'TIS METAL O' THE ZAPPY BIRD"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.IRON = "I can't burn it with just my lighter."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.IRON = "Iron is strong like Wolfgang."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.IRON = "Can't chop this too well."
STRINGS.CHARACTERS.WOODLEGS.DESCRIBE.IRON = "'Tis not gold, but a treasure nonetheless."
STRINGS.CHARACTERS.WX78.DESCRIBE.IRON = "HELLO FRIEND"
-------------------------------
-- Action
STRINGS.ACTIONS.SMELT = "Smelt"
--------------------------------------------------------------------


local ACTIONS = _G.ACTIONS

local old_cook_fn = ACTIONS.COOK.fn
ACTIONS.COOK.fn = function(act)
  if act.target.components.melter ~= nil then
    if act.target.components.melter:IsCooking() then
        --Already cooking
        return true
    end
    local container = act.target.components.container
    if container ~= nil and container:IsOpen() and not container:IsOpenedBy(act.doer) then
        return false, "INUSE"
    elseif not act.target.components.melter:CanCook() then
        return false
    end
    act.target.components.melter:StartCooking()
    return true
  end
  return old_cook_fn(act)
end

local old_harvest_fn = ACTIONS.HARVEST.fn
ACTIONS.HARVEST.fn = function(act)
  if act.target.components.melter ~= nil then
    return act.target.components.melter:Harvest(act.doer)
  end
  return old_harvest_fn(act)
end
--------------------------------------------------------------------
-- make `rock1`, `rock2` and `rock_moon` drop iron ore
local function change_rockdrop(drop_rate)
  return function(inst)
    if inst and inst.components.lootdropper then
      if drop_rate and 0 <= drop_rate and drop_rate <= 1 then
        local ld = inst.components.lootdropper
        ld:AddChanceLoot("iron", drop_rate)
      end
    end
  end
end

AddPrefabPostInit("rock1", change_rockdrop(0.25))
AddPrefabPostInit("rock2", change_rockdrop(0.5))
AddPrefabPostInit("rock_moon", change_rockdrop(1.0))
--------------------------------------------------------------------
if DEBUG then
  local SpawnPrefab = _G.SpawnPrefab
  AddPlayerPostInit(function(inst)
    local function giveitem(item_name)
      local item = SpawnPrefab(item_name)
      if item then
        inst.components.inventory:GiveItem(item)
      end
    end

    -- Spawn items in tester's inventory
    if inst.components.inventory then
      giveitem("iron")
      giveitem("iron")
      giveitem("iron")
      giveitem("iron")
      giveitem("alloy")
    end
  end)
end
