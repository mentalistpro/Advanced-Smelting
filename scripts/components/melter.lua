--local cooking = require("smelting")

local function ondone(self, done)
  --print("KK-TEST> function `ondone` invoked: done =", done)
  if done then
    self.inst:AddTag("donecooking")
  else
    self.inst:RemoveTag("donecooking")
  end
end

local Melter = Class(function(self, inst)
  self.inst = inst
  self.cooking = false
  self.done = false

  self.product = nil
  self.recipes = nil
  self.default_recipe = nil
  self.maketastyfood = nil

  self.min_num_for_cook = 4
  self.max_num_for_cook = 4

  self.cookername = nil

  -- stuff to make warly's special recipes possible
  self.specialcookername = nil  -- a special cookername to check first before falling back to cookername default
  self.productcooker = nil    -- hold on to the cookername that is cooking the current product

  self.inst:AddTag("stewer")
end,
nil,
{
  done = ondone,
})

local function dostew(inst)
  local stewercmp = inst.components.melter
  stewercmp.task = nil

  if stewercmp.ondonecooking then
    stewercmp.ondonecooking(inst)
  end

  stewercmp.done = true
  stewercmp.cooking = nil
end

function Melter:SetCookerName(_name)
  self.cookername = _name
end

function Melter:GetTimeToCook()
  if self.cooking then
    return self.targettime - GetTime()
  end
  return 0
end

function Melter:CanCook()
  return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function Melter:IsCooking()
    return not self.done and self.targettime ~= nil
end


function Melter:StartCooking()
  if not self.done and not self.cooking then
    if self.inst.components.container then

      self.done = nil
      self.cooking = true

      if self.onstartcooking then
        self.onstartcooking(self.inst)
      end

      self.product = "alloy"
      local cooktime = 0.2
      self.productcooker = self.inst.prefab

      local grow_time = TUNING.BASE_COOK_TIME * cooktime
      self.targettime = GetTime() + grow_time
      self.task = self.inst:DoTaskInTime(grow_time, dostew, "stew")

      self.inst.components.container:Close()
      self.inst.components.container:DestroyContents()
      self.inst.components.container.canbeopened = false
    end

  end
end

function Melter:OnSave()
  local time = GetTime()
  if self.cooking then
    local data = {}
    data.cooking = true
    data.product = self.product
    data.productcooker = self.productcooker
    if self.targettime and self.targettime > time then
      data.time = self.targettime - time
    end
    return data
  elseif self.done then
    local data = {}
    data.product = self.product
    data.productcooker = self.productcooker
    data.timesincefinish = -(GetTime() - (self.targettime or 0))
    data.done = true
    return data
  end
end

function Melter:OnLoad(data)
  --self.produce = data.produce
  if data.cooking then
    self.product = data.product
    self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
    if self.oncontinuecooking then
      local time = data.time or 1
      self.oncontinuecooking(self.inst)
      self.cooking = true
      self.targettime = GetTime() + time
      self.task = self.inst:DoTaskInTime(time, dostew, "stew")

      if self.inst.components.container then
        self.inst.components.container.canbeopened = false
      end

    end
  elseif data.done then
    self.done = true
    self.targettime = data.timesincefinish
    self.product = data.product
    self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
    if self.oncontinuedone then
      self.oncontinuedone(self.inst)
    end
    if self.inst.components.container then
      self.inst.components.container.canbeopened = false
    end

  end
end

function Melter:GetDebugString()
  local str = nil

  if self.cooking then
    str = "COOKING"
  elseif self.done then
    str = "FULL"
  else
    str = "EMPTY"
  end
    if self.targettime then
      str = str.." ("..tostring(self.targettime - GetTime())..")"
    end

    if self.product then
      str = str.. " ".. self.product
    end
  return str
end

function Melter:IsDone()
  return self.done
end

function Melter:StopCooking(reason)
  if self.task then
    self.task:Cancel()
    self.task = nil
  end
  if self.product and reason and reason == "fire" then
    local prod = SpawnPrefab(self.product)
    if prod then
      prod.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
      prod:DoTaskInTime(0, function(prod) prod.Physics:Stop() end)
    end
  end
  self.product = nil
  self.targettime = nil
end


function Melter:Harvest(harvester)
  --print("HERE?")
  if self.done then
    if self.onharvest then
      self.onharvest(self.inst)
    end

    if self.product then
      if harvester and harvester.components.inventory then
        local loot = nil
        loot = SpawnPrefab("alloy")
        if loot then
          harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
        end
      end
      self.product = nil
    end

    self.done = nil
    self.targettime = nil

    if self.inst.components.container then
      self.inst.components.container.canbeopened = true
    end

    return true
  end
end

function Melter:LongUpdate(dt)
  if not self.paused and self.targettime ~= nil then
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
