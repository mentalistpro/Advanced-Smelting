local assets =
{
	Asset("ANIM", "anim/alloy.zip"),
	Asset("ATLAS", "images/alloy.xml"),
    Asset("IMAGE", "images/alloy.tex"),
}

local function shine(inst)
    inst.task = nil

	inst.AnimState:PlayAnimation("sparkle")
	inst.AnimState:PushAnimation("idle")
	inst.task = inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetBank("alloy")
	inst.AnimState:SetBuild("alloy")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("molebait")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "ELEMENTAL"
	inst.components.edible.hungervalue = 2

	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/alloy.xml"
    inst.components.inventoryitem.imagename = "alloy"

	inst:AddComponent("bait")	
	inst:AddComponent("inspectable")
	inst:AddComponent("stackable")
	inst:AddComponent("tradable")

	shine(inst)
	return inst
end

return Prefab("alloy", fn, assets)
