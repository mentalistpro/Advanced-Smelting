GLOBAL.CHEATS_ENABLED = true
GLOBAL.require( 'debugkeys' )

local _G = GLOBAL
local require = _G.require
local ACTIONS = _G.ACTIONS
local Ingredient = _G.Ingredient
local RECIPETABS = _G.RECIPETABS
local STRINGS = _G.STRINGS
local TECH = _G.RECIPETABS
local Vector3 = _G.Vector3

Assets = 
{
    Asset("ATLAS", "images/alloy.xml"),
    Asset("IMAGE", "images/alloy.tex"),
    Asset("ATLAS", "images/iron.xml"),
    Asset("IMAGE", "images/iron.tex"),
    Asset("ATLAS", "images/smelter.xml"),
    Asset("IMAGE", "images/smelter.tex"),
    Asset("ATLAS", "minimap/smelter.xml"),
    Asset("IMAGE", "minimap/smelter.tex"),
}

PrefabFiles =
{
	"alloy",
	"iron",
	"smelter",

}

AddMinimapAtlas("minimap/smelter.xml")

--------------------------------------------------------------------------------------------------

--//CONTENT//
--#1 Actions
--#2 Configs
--#3 Recipes
--#4 Strings
--#5 scripts/containers.lua

--------------------------------------------------------------------------------------------------
--#1 Actions

local old_cook_fn = ACTIONS.COOK.fn
ACTIONS.COOK.fn = function(act)
	if act.target.components.melter ~= nil then
		if act.target.components.melter:IsCooking() then
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

--------------------------------------------------------------------------------------------------
--#2 Configs

TUNING.CITYLAMP_MINIMAP = GetModConfigData("minimap_icon")

--------------------------------------------------------------------------------------------------
--#3 Recipes

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
	"images/smelter.xml",
	"smelter.tex"
)

--------------------------------------------------------------------------------------------------
--#4 Strings

if STRINGS.CHARACTERS.WALANI == nil then STRINGS.CHARACTERS.WALANI = { DESCRIBE = {},} end -- DLC002
if STRINGS.CHARACTERS.WARBUCKS == nil then STRINGS.CHARACTERS.WARBUCKS = { DESCRIBE = {},} end -- DLC003
if STRINGS.CHARACTERS.WHEELER == nil then STRINGS.CHARACTERS.WHEELER = { DESCRIBE = {},} end -- DLC003
if STRINGS.CHARACTERS.WILBA == nil then STRINGS.CHARACTERS.WILBA = { DESCRIBE = {},} end -- DLC003
if STRINGS.CHARACTERS.WOODLEGS == nil then STRINGS.CHARACTERS.WOODLEGS = { DESCRIBE = {},} end -- DLC002

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

--------------------------------------------------------------------------------------------------
--#5 scripts/containers.lua

local containers = require "containers"

local params = {}

local old_widgetsetup = containers.widgetsetup
function containers.widgetsetup(container, prefab, data, ...)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        return old_widgetsetup(container, prefab, data, ...)
    end
end	

params.smelter =
{
	widget =
	{
		slotpos =
		{
			Vector3(0, 64 + 32 + 8 + 4, 0),
			Vector3(0, 32 + 4, 0),
			Vector3(0, -(32 + 4), 0),
			Vector3(0, -(64 + 32 + 8 + 4), 0),
		},
		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		pos = Vector3(200, 0, 0),
		side_align_tip = 100,
		buttoninfo = 
		{
			text = "Smelt",
			position = Vector3(0, -165, 0),
		}
	},
	acceptsstacks = false,
	type = "cooker"
}

function params.smelter.itemtestfn(container, item, slot)
	return not container.inst:HasTag("burnt") and item.prefab == "iron"
end

function params.smelter.widget.buttoninfo.fn(inst)
	if inst.components.container ~= nil then
		_G.BufferedAction(inst.components.container.opener, inst, ACTIONS.COOK):Do()
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		_G.SendRPCToServer(_G.RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
	end
end

function params.smelter.widget.buttoninfo.validfn(inst)
	return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

