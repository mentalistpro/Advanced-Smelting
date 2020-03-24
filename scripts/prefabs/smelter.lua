local assets=
{
	Asset("ANIM", "anim/smelter.zip"),
	Asset("ATLAS", "images/smelter.xml"),
	Asset("IMAGE", "images/smelter.tex"),
}

local prefabs =
{
	"collapse_small"
}

-----------------------------------------------------------------------------------------------------

local function getstatus(inst)
	local result
	if inst:HasTag("burnt") then
		result = "BURNT"
	elseif inst.components.melter.cooking and inst.components.melter:GetTimeToCook() > 15 then
		result = "COOKING_LONG"
	elseif inst.components.melter.cooking then
		result = "COOKING_SHORT"
	elseif inst.components.melter.done then
		result = "DONE"
	else
		result = "EMPTY"
	end
	return result
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
	
    if not inst:HasTag("burnt") and inst.components.melter.product ~= nil and inst.components.melter:IsDone() then
        inst.components.melter:Harvest()
    end
	
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
  
	inst.components.lootdropper:DropLoot()
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit_empty")
		if inst.components.melter.cooking then
			inst.AnimState:PushAnimation("smelting_loop")
		elseif inst.components.melter.done then
			inst.AnimState:PushAnimation("idle_full")
		else
			inst.AnimState:PushAnimation("idle_empty")
		end
	end
end

local function onopen(inst)
	if not inst:HasTag("burnt") then
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
		--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_3", "open")
	end
end

local function onclose(inst)
	if not inst:HasTag("burnt") then
		if not inst.components.melter.cooking then
			inst.AnimState:PlayAnimation("idle_empty")
			inst.SoundEmitter:KillSound("snd")
		end	
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_3", "close")
	end
end

local function onfar(inst)
	if inst.components.container then
		inst.components.container:Close()
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_empty")
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/build")
	inst:DoTaskInTime(1/30, function()
		if inst.AnimState:IsCurrentAnimation("place") then
			inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
		end
	end)
	inst:DoTaskInTime(4/30, function()
		if inst.AnimState:IsCurrentAnimation("place") then
			inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
		end
	end)
	inst:DoTaskInTime(8/30, function()
		if inst.AnimState:IsCurrentAnimation("place") then
			inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
		end
	end)
	inst:DoTaskInTime(12/30, function()
		if inst.AnimState:IsCurrentAnimation("place") then
			inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
		end
	end)
	inst:DoTaskInTime(14/30, function()
		if inst.AnimState:IsCurrentAnimation("place") then
			inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
		end
	end)
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
		inst.Light:Enable(false)
	end
end

-----------------------------------------------------------------------------------------------------
-- components/melter

local function ShowProduct(inst)
	if not inst:HasTag("burnt") then
		local product = inst.components.melter.product
		inst.AnimState:OverrideSymbol("swap_item", "alloy", "alloy01")
	end
end

local function startcookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_pre")
		inst.AnimState:PushAnimation("smelting_loop", true)
		inst.SoundEmitter:KillSound("snd")
		inst.SoundEmitter:PlaySound("dontstarve/common/forestfire")
		--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/smelter/move_1")
		--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/smelt_LP", "snd")
		inst.Light:Enable(true)
	end
end

local function continuecookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_loop", true)
		--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/smelt_LP", "snd")
		inst.Light:Enable(true)
	end
end

local function continuedonefn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle_full")
		ShowProduct(inst)
	end
end

local function donecookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_pst")
		inst.AnimState:PushAnimation("idle_full")
		ShowProduct(inst)
		inst.SoundEmitter:KillSound("snd")
		inst.SoundEmitter:KillSound("dontstarve/common/forestfire")
		inst.Light:Enable(false)
		
		inst:DoTaskInTime(1/30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_1")
			end
		end)
		inst:DoTaskInTime(8/30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_2")
			end
		end)
		inst:DoTaskInTime(14/30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/pour")
			end
		end)
		inst:DoTaskInTime(31/30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				inst.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
				--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/steam")
			end
		end)
		inst:DoTaskInTime(36/30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
			end
		end)
		inst:DoTaskInTime(49/30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				--inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_2")
			end
		end)
	end
end

local function spoilfn(inst)
	if not inst:HasTag("burnt") then
		inst.components.melter.product = inst.components.melter.spoiledproduct
		ShowProduct(inst)
	end
end

local function harvestfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle_empty")
	end
end

-----------------------------------------------------------------------------------------------------

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	if TUNING.CITYLAMP_MINIMAP == 1 then
		minimap:SetIcon("smelter.tex")
	end

	local light = inst.entity:AddLight()
	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235/255,62/255,12/255)

	inst.AnimState:SetBank("smelter")
	inst.AnimState:SetBuild("smelter")
	inst.AnimState:PlayAnimation("idle_empty")

	MakeObstaclePhysics(inst, .5)
	MakeSnowCoveredPristine(inst)

	inst:AddTag("structure")

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("melter")
	inst.components.melter.onstartcooking = startcookfn
	inst.components.melter.oncontinuecooking = continuecookfn
	inst.components.melter.oncontinuedone = continuedonefn
	inst.components.melter.ondonecooking = donecookfn
	inst.components.melter.onharvest = harvestfn
	inst.components.melter.onspoil = spoilfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("smelter")
	inst.components.container:SetNumSlots(4)
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(3,5)
	inst.components.playerprox:SetOnPlayerFar(onfar)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	MakeSnowCovered(inst)

	inst:ListenForEvent("onbuilt", onbuilt)

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

return Prefab("smelter", fn, assets, prefabs),
	MakePlacer("smetler_placer", "smelter", "smelter", "idle_empty")
