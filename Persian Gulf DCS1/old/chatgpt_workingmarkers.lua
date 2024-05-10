---@diagnostic disable: lowercase-global
-- Define a SET_GROUP object that builds a collection of groups that define the EWR network.
-- Here we build the network with all the groups that have a name starting with DF CCCP AWACS and DF CCCP EWR.

MESSAGE:New( "start of Moose Script", 35, "INFO" ):ToAll()


DetectionSetGroup_Red = SET_GROUP:New()
DetectionSetGroup_Red:FilterPrefixes( { "DF CCCP AWACS", "DF CCCP EWR" } )
DetectionSetGroup_Red:FilterStart()

Detection = DETECTION_AREAS:New( DetectionSetGroup_Red, 5000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcher_Red = AI_A2A_DISPATCHER:New( Detection )

-- Setup the border zone. 
-- In this case the border is a POLYGON, 
-- which takes the waypoints of a late activated group with the name CCCP Border as the boundaries of the border area.
-- Any enemy crossing this border will be engaged.
CCCPBorderZone = ZONE_POLYGON:New( "CCCP Border", GROUP:FindByName( "CCCP Border" ) )
A2ADispatcher_Red:SetBorderZone( CCCPBorderZone )

A2ADispatcher_Red:SetTacticalDisplay( true )

-- Setup the squadrons.
A2ADispatcher_Red:SetSquadron( "Bandar-E-Jask", AIRBASE.PersianGulf.Bandar_e_Jask, { "SQ CCCP EAST"}, 20)
A2ADispatcher_Red:SetSquadronGrouping( "Bandar-E-Jask", 2 )
A2ADispatcher_Red:SetSquadronTakeoffFromParkingHot("Bandar-E-Jask")
A2ADispatcher_Red:SetSquadronLandingAtRunway( "Bandar-E-Jask" )
CAPZoneE = ZONE:FindByName("CAP Zone EAST")
A2ADispatcher_Red:SetSquadronCap( "Bandar-E-Jask", CAPZoneE, 3000, 10000, 400, 800, 700, 1200, "RADIO" )
A2ADispatcher_Red:SetSquadronCapInterval( "Bandar-E-Jask", 1, 180, 600)


A2ADispatcher_Red:SetSquadron( "Bandar Abbas", AIRBASE.PersianGulf.Bandar_Abbas_Intl, { "SQ CCCP MID" }, 20 )
A2ADispatcher_Red:SetSquadronGrouping( "Bandar Abbas", 2 )
A2ADispatcher_Red:SetSquadronTakeoffFromParkingHot("Bandar Abbas")
A2ADispatcher_Red:SetSquadronLandingAtRunway( "Bandar Abbas" )
CAPZoneM = ZONE:FindByName("CAP Zone Middle")
A2ADispatcher_Red:SetSquadronCap( "Bandar Abbas", CAPZoneM, 3000, 10000, 400, 800, 700, 1200, "RADIO" )
A2ADispatcher_Red:SetSquadronCapInterval( "Bandar Abbas", 1, 180, 600)


A2ADispatcher_Red:SetSquadron( "Kish", AIRBASE.PersianGulf.Kish_Intl, { "SQ CCCP WEST" }, 20 )
A2ADispatcher_Red:SetSquadronGrouping( "Kish", 2 )
A2ADispatcher_Red:SetSquadronTakeoffFromParkingHot("Kish")
A2ADispatcher_Red:SetSquadronLandingAtRunway( "Kish" )
CAPZoneW = ZONE:FindByName("CAP Zone West")
A2ADispatcher_Red:SetSquadronCap( "Kish", CAPZoneW, 3000, 10000, 400, 800, 700, 1200, "RADIO" )
A2ADispatcher_Red:SetSquadronCapInterval( "Kish", 1, 180, 600)

MESSAGE:New( "CC start", 15, "INFO" ):ToAll()
do -- Setup the Command Centers
    RU_CC = COMMANDCENTER:New( GROUP:FindByName( "REDHQ" ), "Russia HQ" )
    US_CC = COMMANDCENTER:New( GROUP:FindByName( "BLUEHQ" ), "USA HQ" )
end
MESSAGE:New( "CC done", 15, "INFO" ):ToAll()

------------------------------------------------------------------------------------------------------------

-- Define zones, initial supplies, and active construction projects
local zones = {"KishZone", "QeshmZone", "JaskZone"}
local zoneObjects = {}
local zoneSupplies = {}
local zoneStatus = {}
local activeTimers = {}



-- Define a function to update F10 map markers
function updateMarker(zoneName)
    local status = zoneStatus[zoneName]
    local markerText = string.format("Zone: %s - %s - Supplies: %d", zoneName, status.coalition, zoneSupplies[zoneName])
    if status.building then
        markerText = markerText .. string.format(" - Building: %s - %d min left", status.building, math.ceil(status.timeRemaining / 60))
    end
    MARKER:New(zoneObjects[zoneName]:GetCoordinate(), markerText):ToAll()
end

-- Define function to handle construction activation and management
function ActivateDefense(zoneName, coalition)
    -- Activate corresponding group if not neutral
    local groupName = coalition .. "_" .. zoneName
    local group = GROUP:FindByName(groupName)
    if group then
        group:Activate()
    end

    -- Cancel any ongoing constructions if active
    if zoneStatus[zoneName].activeTimer then
        zoneStatus[zoneName].activeTimer:Stop()
        zoneStatus[zoneName].activeTimer = nil
    end

    -- Construction sequence setup
    local buildQueue = {
        {name = "Outpost", cost = 5000, duration = 300},
        {name = "FARP Ammo Storage", cost = 2000, duration = 600},
        {name = "FARP Fuel Depot", cost = 2000, duration = 600},
        {name = "Command Center", cost = 10000, duration = 1200}
    }

    -- Start construction process
    local function startConstruction()
        if #buildQueue > 0 and zoneSupplies[zoneName] >= buildQueue[1].cost then
            local build = buildQueue[1]
            zoneSupplies[zoneName] = (zoneSupplies[zoneName] - build.cost)
            zoneStatus[zoneName].building = build.name
            zoneStatus[zoneName].timeRemaining = build.duration
            MESSAGE:New(string.format("Construction started in %s: %s", zoneName, build.name), 15, "INFO"):ToAll()
            updateMarker(zoneName)

            local timer = TIMER:New(function()
                table.remove(buildQueue, 1)
                zoneStatus[zoneName].building = nil
                zoneStatus[zoneName].timeRemaining = nil
                updateMarker(zoneName)
                startConstruction()
            end)
            timer:Start(build.duration)
            zoneStatus[zoneName].activeTimer = timer
        else
            updateMarker(zoneName)
        end
    end

    startConstruction()
end

-- Function to check and update zone control
function UpdateZone()
    for zoneName, zoneObject in pairs(zoneObjects) do
        MESSAGE:New( "Updating", 15, "INFO: "):ToAll()
        local blueInZone = SET_GROUP:New():FilterCoalitions("blue"):FilterZones({zoneObject}):FilterOnce():Count() > 0
        local redInZone = SET_GROUP:New():FilterCoalitions("red"):FilterZones({zoneObject}):FilterOnce():Count() > 0
        local currentCoalition = zoneStatus[zoneName].coalition
        local newCoalition = nil

        if blueInZone and not redInZone then
            newCoalition = "Blue"
        elseif redInZone and not blueInZone then
            newCoalition = "Red"
        elseif not blueInZone and not redInZone then
            newCoalition = "Neutral"
        end

        if newCoalition and newCoalition ~= currentCoalition then
            zoneStatus[zoneName].coalition = newCoalition
            ActivateDefense(zoneName, newCoalition)
        end
    end
end

-- Initialize zones with default settings
for _, zoneName in ipairs(zones) do
    zoneObjects[zoneName] = ZONE:New(zoneName)
    zoneSupplies[zoneName] = 20000  -- starting supply cap
    zoneStatus[zoneName] = {coalition = "Red", building = nil, timeRemaining = nil, activeTimer = nil}
    ActivateDefense(zoneName, "Red") -- Start off as Red controlled
    updateMarker(zoneName) -- Initial marker update for each zone
end

-- Scheduler to check the zone control every 30 seconds
SCHEDULER:New(nil, UpdateZone, {}, 0, 30)
