MESSAGE:New("SupplySystem script started successfully", 5):ToAll()

BlueSupplyPoints = 100
RedSupplyPoints = 100

local loadingZoneA = ZONE:New("LoadingZoneA")
--local loadingZoneB = ZONE:New("LoadingZoneB")
local unloadingZoneA = ZONE:New("UnloadingZoneA")
--local unloadingZoneB = ZONE:New("UnloadingZoneB")

Spawn_Blue_Supply_Chinook_A = SPAWN
        :New("Blue Supply Chinook A")
        :InitLimit( 2, 0 )
        :SpawnScheduled( 0, 0 )

local Blue_Supply_Chinook_A = {s
    name = "Blue Supply Chinook A",
    unitLoadingZone = loadingZoneA,
    unitUnloadingZone = unloadingZoneA,
    loadStatus = "unloaded",
    loadCapacity = 10850 -- kg
}

local convoyBlueList = {
    Blue_Supply_Chinook_A
}

local function CheckUnitCountInConvoy(convoyObj)
    local convoyGroup = GROUP:FindByName(convoyObj.name)
    local count = convoyGroup:GetSize()
    MESSAGE:New("The size of " .. convoyObj.name .. ": " .. count, 5):ToAll()
    return count
end

local function AddSupplyPoints(side, addPointsAmount)
    if side == "blue" then
        BlueSupplyPoints = BlueSupplyPoints + addPointsAmount
        MESSAGE:New("Blue supply points updated.\nAdded: " .. addPointsAmount .. "\nTotal: " .. BlueSupplyPoints, 5):ToAll()
    elseif side == "red" then
        RedSupplyPoints = RedSupplyPoints + addPointsAmount
        MESSAGE:New("Red supply points updated.\nAdded: " .. addPointsAmount .. "\nTotal: " .. RedSupplyPoints, 5):ToAll()
    else
        MESSAGE:New("Error, could not add any points", 5):ToAll()
    end
end

local function CheckConvoyInLoadingZone(convoyObj, zoneName)
    local convoyGroup = GROUP:FindByName(convoyObj.name)
    if convoyGroup and convoyGroup:IsAlive() and convoyObj.loadStatus == "unloaded" then
        if convoyGroup:IsPartlyOrCompletelyInZone(zoneName) then
            MESSAGE:New(convoyObj.name .. " has loaded supplies.", 5):ToAll()
            convoyObj.loadStatus = "loaded"
        else
            MESSAGE:New(convoyObj.name .. " is not in loading zone", 5):ToAll()
        end
    else
        MESSAGE:New("Could not find any matching group. (loading)", 5):ToAll()
    end
end

local function CheckConvoyInUnloadingZone(convoyObj, zoneName)
    local convoyGroup = GROUP:FindByName(convoyObj.name)
    if convoyGroup and convoyGroup:IsAlive() and convoyObj.loadStatus == "loaded" then
        if convoyGroup:IsPartlyOrCompletelyInZone(zoneName) then
            local units_alive = CheckUnitCountInConvoy(convoyObj)
            local supplyPointsToAdd = (units_alive * convoyObj.loadCapacity) / 1000
            MESSAGE:New(convoyObj.name .. " has delivered " .. supplyPointsToAdd .. " supplies.", 5):ToAll()

            if convoyGroup:GetCoalition() == coalition.side.BLUE then
                AddSupplyPoints("blue", supplyPointsToAdd)
            else
                AddSupplyPoints("red", supplyPointsToAdd)
            end
            convoyObj.loadStatus = "unloaded"
        else
            MESSAGE:New("Convoy is not in unloading zone", 5):ToAll()
        end
    else
        MESSAGE:New("Could not find any matching group. (unloading)", 5):ToAll()
    end
end

local function scheduler()
    --MESSAGE:New("Scheduler OK START", 5):ToAll()
    for _, convoyObj in pairs(convoyBlueList) do
        CheckConvoyInLoadingZone(convoyObj, convoyObj.unitLoadingZone)
        CheckConvoyInUnloadingZone(convoyObj, convoyObj.unitUnloadingZone)
    end
    timer.scheduleFunction(scheduler, {}, timer.getTime() + 5)
    --MESSAGE:New("Scheduler OK END", 5):ToAll()
end

scheduler()