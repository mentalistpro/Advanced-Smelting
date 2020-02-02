local assets =
{
	Asset("ANIM", "anim/iron_ore.zip"),
	Asset("ATLAS", "images/iron.xml"),
    Asset("IMAGE", "images/iron.tex"),
}

local function onsave(inst, data)
	data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("iron_ore")
	inst.AnimState:SetBuild("iron_ore")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("molebait")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "ELEMENTAL"
	inst.components.edible.hungervalue = 1

	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/iron.xml"
    inst.components.inventoryitem.imagename = "iron"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

	inst.OnSave = onsave
	inst.OnLoad = onload
	return inst
end

return Prefab("iron", fn, assets)
