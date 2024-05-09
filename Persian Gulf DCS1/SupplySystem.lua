MESSAGE:New("SupplySystem script started successfully", 5):ToAll()

BlueSupplyPoints = 100
RedSupplyPoints = 100

local loadingZoneA = ZONE:New("LoadingZoneA")
local loadingZoneB = ZONE:New("LoadingZoneB")
local unloadingZoneA = ZONE:New("UnloadingZoneA")
local unloadingZoneB = ZONE:New("UnloadingZoneB")

local convoyBlueGroupA = {
    name = "Blue Supply Convoy A",
    unitLoadingZone = loadingZoneA,
    unitUnloadingZone = unloadingZoneA,
    loadStatus = "unloaded"
}

local convoyBlueGroupB = {
    name = "Blue Supply Convoy B",
    unitLoadingZone = loadingZoneB,
    unitUnloadingZone = unloadingZoneB,
    loadStatus = "unloaded"
}

local convoyBlueList = {
    convoyBlueGroupA, convoyBlueGroupB
}

local function CheckUnitCountInConvoy(convoyObj)
    local convoyGroup = GROUP:FindByName(convoyObj.name)
    local count = convoyGroup:GetSize()
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
        if convoyGroup:IsPartlyInZone(zoneName) then
            MESSAGE:New(convoyObj.name .. " has loaded supplies.", 5):ToAll()
            convoyObj.loadStatus = "loaded"
        else
            --MESSAGE:New("Convoy is not in loading zone", 5):ToAll()
        end
    else
        --MESSAGE:New("Could not find any matching group. A", 5):ToAll()
    end
end

local function CheckConvoyInUnloadingZone(convoyObj, zoneName)
    local convoyGroup = GROUP:FindByName(convoyObj.name)
    if convoyGroup and convoyGroup:IsAlive() and convoyObj.loadStatus == "loaded" then
        if convoyGroup:IsPartlyInZone(zoneName) then
            local units_alive = CheckUnitCountInConvoy(convoyObj)
            local supplyPointsToAdd = units_alive * 10
            MESSAGE:New(convoyObj.name .. " has delivered " .. units_alive .."x supplies.", 5):ToAll()

            if convoyGroup:GetCoalition() == coalition.side.BLUE then
                AddSupplyPoints("blue", supplyPointsToAdd) -- Example action
            else
                AddSupplyPoints("red", supplyPointsToAdd) -- Example action
            end
            convoyObj.loadStatus = "unloaded"
        else
            --MESSAGE:New("Convoy is not in unloading zone", 5):ToAll()
        end
    else
        --MESSAGE:New("Could not find any matching group. B", 5):ToAll()
    end
end

local function scheduler()
    --MESSAGE:New("Scheduler OK START", 5):ToAll()
    for _, convoy in pairs(convoyBlueList) do
        CheckConvoyInLoadingZone(convoy, convoy.unitLoadingZone)
        CheckConvoyInUnloadingZone(convoy, convoy.unitUnloadingZone)
    end
    timer.scheduleFunction(scheduler, {}, timer.getTime() + 5)
    --MESSAGE:New("Scheduler OK END", 5):ToAll()
end

scheduler()