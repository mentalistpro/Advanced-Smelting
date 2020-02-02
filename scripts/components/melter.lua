local cooking = require("smelting")

local function ondone(self, done)
    if done then
        self.inst:AddTag("donecooking")
    else
        self.inst:RemoveTag("donecooking")
    end
end

local function oncheckready(inst)
    if inst.components.container ~= nil and
        not inst.components.container:IsOpen() and
        inst.components.container:IsFull() then
        inst:AddTag("readytocook")
    end
end

local function onnotready(inst)
    inst:RemoveTag("readytocook")
end

local Melter = Class(function(self, inst)
	self.inst = inst
	self.cooking = false
	self.done = false

    self.cooktimemult = 1
	self.product = nil
    self.spoiledproduct = "alloy"
	self.task = nil
	self.targettime = nil

    inst:ListenForEvent("itemget", oncheckready)
    inst:ListenForEvent("onclose", oncheckready)

    inst:ListenForEvent("itemlose", onnotready)
    inst:ListenForEvent("onopen", onnotready)

	self.inst:AddTag("stewer")
	self.inst:AddTag("smelter")
	end,
	nil,
{
	done = ondone,
})

--------------------------------------------------------------------------------------------------------


function Melter:OnRemoveFromEntity()
    self.inst:RemoveTag("stewer")
    self.inst:RemoveTag("donecooking")
    self.inst:RemoveTag("readytocook")
end

local function dostew(inst)
	local stewercmp = inst.components.melter
	stewercmp.task = nil
	
	if stewercmp.ondonecooking then
		stewercmp.ondonecooking(inst)
	end
	
	stewercmp.done = true
	stewercmp.cooking = nil
end

function Melter:CanCook()
	return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function Melter:GetTimeToCook()
	if self.cooking then
		return self.targettime - GetTime()
	end
	return 0
end

function Melter:IsCooking()
    return not self.done and self.targettime ~= nil
end

function Melter:IsDone()
	return self.done
end


--------------------------------------------------------------------------------------------------------
-- Cooking

function Melter:StartCooking()
	if not self.done and not self.cooking then
		if self.inst.components.container ~= nil then
			self.done = nil
			self.cooking = true
			if self.onstartcooking  ~= nil then
				self.onstartcooking(self.inst)
			end			
			self.product = "alloy"
			
			local cooktime = 0.2
			local grow_time = TUNING.BASE_COOK_TIME * cooktime * self.cooktimemult
			self.targettime = GetTime() + grow_time
			self.task = self.inst:DoTaskInTime(grow_time, dostew, "stew")

			self.inst.components.container:Close()
			self.inst.components.container:DestroyContents()
			self.inst.components.container.canbeopened = false
		end
	end
end

function Melter:StopCooking(reason)
	if self.task  ~= nil then
		self.task:Cancel()
		self.task = nil
	end
	
	if self.product and reason and reason == "fire" then
	local prod = SpawnPrefab(self.product)
		if prod ~= nil then
			prod.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			prod:DoTaskInTime(0, function(prod) prod.Physics:Stop() end)
		end
	end

	self.product = nil
	self.targettime = nil
end

--------------------------------------------------------------------------------------------------------
-- Save/Load

function Melter:OnSave()
	local time = GetTime()
	if self.cooking then
		local data = {}
		data.cooking = true
		data.product = self.product
		if self.targettime  ~= nil and self.targettime > time then
			data.time = self.targettime - time
		end
		return data
		
	elseif self.done then
		local data = {}
		data.product = self.product
		data.timesincefinish = -(GetTime() - (self.targettime or 0))
		data.done = true
		return data
	end
end

function Melter:OnLoad(data)
	if data.cooking then
		self.product = data.product
		if self.oncontinuecooking ~= nil then
			local time = data.time or 1
			self.oncontinuecooking(self.inst)
			self.cooking = true
			self.targettime = GetTime() + time
			self.task = self.inst:DoTaskInTime(time, dostew, "stew")
			if self.inst.components.container ~= nil then
			self.inst.components.container.canbeopened = false
			end
		end
		
	elseif data.done then
		self.done = true
		self.targettime = data.timesincefinish
		self.product = data.product
		if self.oncontinuedone ~= nil then
			self.oncontinuedone(self.inst)
		end		
		if self.inst.components.container ~= nil then
			self.inst.components.container.canbeopened = false
		end
	end
end

--------------------------------------------------------------------------------------------------------

function Melter:GetDebugString()
    local status = (self:IsCooking() and "COOKING")
				or (self:IsDone() and "FULL")
				or "EMPTY"

    return string.format("%s %s timetocook: %.2f ",
            self.product or "<none>",
            status,
            self:GetTimeToCook())
end

function Melter:Harvest(harvester)
	if self.done then
		if self.onharvest ~= nil then
			self.onharvest(self.inst)
		end

		if self.product ~= nil then
			local loot = SpawnPrefab("alloy")
			if loot ~= nil then
				if harvester ~= nil and harvester.components.inventory ~= nil then
					harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
                else
                    LaunchAt(loot, self.inst, nil, 1, 1)
				end
			end
			self.product = nil
		end

		self.done = nil
		self.targettime = nil

        if self.inst.components.container ~= nil then      
            self.inst.components.container.canbeopened = true
        end
		
		return true
	end
end

function Melter:LongUpdate(dt)
	if self:IsCooking() then
		if self.task ~= nil then
			self.task:Cancel()
			self.task = nil
		end

		self.targettime = self.targettime - dt

		if self.cooking then
			local time_to_wait = self.targettime - GetTime()
			if time_to_wait < 0 then
				dostew(self.inst)
			else
				self.task = self.inst:DoTaskInTime(time_to_wait, dostew, "stew")
			end
		end
	end
end

return Melter
