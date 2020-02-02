require "tuning"

local smelterrecipes = {}
function AddSmelterSmelterRecipe(smelter, recipe)
	if not smelterrecipes[smelter] then
		smelterrecipes[smelter] = {}
	end
	smelterrecipes[smelter][recipe.name] = recipe
end

local smelteringredients = {}
function AddSmelterIngredientValues(names, tags, cancook, candry)
	for _,name in pairs(names) do
		smelteringredients[name] = { tags= {}}
		for tagname,tagval in pairs(tags) do
			smelteringredients[name].tags[tagname] = tagval
		end
	end
end

function IsModProduct(smelter, name)
	local enabledmods = ModManager:GetEnabledModNames()
    for i,v in ipairs(enabledmods) do
        local mod = ModManager:GetMod(v)
        if mod.smelterrecipes and mod.smelterrecipes[smelter] and table.contains(mod.smelterrecipes[smelter], name) then
            return true
        end
    end
    return false
end


AddSmelterIngredientValues({"copper_dust"}, 		{copper = 0.5, metal = 0.5})
AddSmelterIngredientValues({"copper_ore"}, 			{copper = 1, metal = 1})
AddSmelterIngredientValues({"copper_ingot"}, 		{copper = 3, metal = 3})

AddSmelterIngredientValues({"iron_dust"}, 			{iron = 0.5, metal = 0.5})
AddSmelterIngredientValues({"iron_ore"}, 			{iron = 1, metal = 1})
AddSmelterIngredientValues({"iron_ingot"}, 			{iron = 3, metal = 3})

AddSmelterIngredientValues({"gold_dust"},			{gold = 0.5, metal = 0.5})
AddSmelterIngredientValues({"gold_ore"},			{gold = 1, metal = 1})
AddSmelterIngredientValues({"gold_ingot"},			{gold = 3, metal = 3})

AddSmelterIngredientValues({"moonglass"},			{moonglass = 1})
AddSmelterIngredientValues({"moonrocknugget"},		{moon = 1, mineral = 1})
AddSmelterIngredientValues({"moonglass_ingot"},		{moonglass = 2, moon = 2})

AddSmelterIngredientValues({"rocks", "nitre"},		{mineral = 1})

AddSmelterIngredientValues({"redgem_shard"},		{red = 1, gem = 0.25})
AddSmelterIngredientValues({"orangegem_shard"},		{red = 0.5, yellow = 0.5, gem = 0.25})
AddSmelterIngredientValues({"yellowgem_shard"},		{yellow = 1, gem = 0.25})
AddSmelterIngredientValues({"greengem_shard"},		{yellow = 0.5, blue = 0.5, gem = 0.25})
AddSmelterIngredientValues({"bluegem_shard"},		{blue = 1, gem = 0.25})
AddSmelterIngredientValues({"purplegem_shard"},		{blue = 0.5, red = 0.5, gem = 0.25})
AddSmelterIngredientValues({"nightmarefuel"},		{gem = 0.25})


local function IsSmelterIngredient(prefabname)
    return smelteringredients[prefabname] ~= nil
end

local function GetSmelterIngredientValues(prefablist)
    local prefabs = {}
    local tags = {}
    for k,v in pairs(prefablist) do
        local name = v
        prefabs[name] = (prefabs[name] or 0) + 1
        local data = smelteringredients[name]
        if data ~= nil then
            for kk, vv in pairs(data.tags) do
                tags[kk] = (tags[kk] or 0) + vv
            end
        end
    end
    return { tags = tags, names = prefabs }
end

local function GetSmelterRecipe(smelter, product)
	local recipes = smelterrecipes[smelter] or {}
	return recipes[product]
end

function GetCandidateSmelterRecipes(smelter, ingdata)
	local recipes = smelterrecipes[smelter] or {}
	local candidates = {}

	for k,v in pairs(recipes) do
		if v.test(smelter, ingdata.names, ingdata.tags) then
			table.insert(candidates, v)
		end
	end

	table.sort( candidates, function(a,b) return (a.priority or 0) > (b.priority or 0) end )
	if #candidates > 0 then
		local top_candidates = {}
		local idx = 1
		local val = candidates[1].priority or 0

		for k,v in ipairs(candidates) do
			if k > 1 and (v.priority or 0) < val then
				break
			end
			table.insert(top_candidates, v)
		end
		return top_candidates
	end

	return candidates
end

local function CalculateSmelterRecipe(smelter, names)
	local ingdata = GetSmelterIngredientValues(names)
	local candidates = GetCandidateSmelterRecipes(smelter, ingdata)

	table.sort( candidates, function(a,b) return (a.weight or 1) > (b.weight or 1) end )
	local total = 0
	for k,v in pairs(candidates) do
		total = total + (v.weight or 1)
	end

	local val = math.random()*total
	local idx = 1
	while idx <= #candidates do
		val = val - candidates[idx].weight
		if val <= 0 then
			return candidates[idx].name, candidates[idx].cooktime or 1
		end

		idx = idx+1
	end
end

return { CalculateSmelterRecipe = CalculateSmelterRecipe, IsSmelterIngredient = IsSmelterIngredient, recipes = smelterrecipes, smelteringredients = smelteringredients, GetSmelterRecipe = GetSmelterRecipe}
