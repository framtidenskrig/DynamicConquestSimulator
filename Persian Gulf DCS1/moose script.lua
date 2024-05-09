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




------------------------------------------------------

MESSAGE:New( "CC start", 15, "INFO" ):ToAll()
do -- Setup the Command Centers
    RU_CC = COMMANDCENTER:New( GROUP:FindByName( "REDHQ" ), "Russia HQ" )
    US_CC = COMMANDCENTER:New( GROUP:FindByName( "BLUEHQ" ), "USA HQ" )
end
MESSAGE:New( "CC done", 15, "INFO" ):ToAll()


do -- Missions
    US_Mission_EchoBay = MISSION:New( US_CC, "Echo Bay", "Primary",
        "Welcome trainee. The airport Groom Lake in Echo Bay needs to be captured.\n" ..
      "There are five random capture zones located at the airbase.\n" ..
      "Move to one of the capture zones, destroy the fuel tanks in the capture zone, " ..
      "and occupy each capture zone with a platoon.\n " ..
      "Your orders are to hold position until all capture zones are taken.\n" ..
      "Use the map (F10) for a clear indication of the location of each capture zone.\n" ..
      "Note that heavy resistance can be expected at the airbase!\n" ..
      "Mission 'Echo Bay' is complete when all five capture zones are taken, and held for at least 5 minutes!"
      , coalition.side.RED)
    US_Score = SCORING:New( "CAZ-001 - Capture Zone" )
    US_Mission_EchoBay:AddScoring( US_Score )
    US_Mission_EchoBay:Start()
end

MESSAGE:New( "Mission done ", 15, "INFO" ):ToAll()

--[[
local zoneNames = {
    "KishZone",
    "QeshmZone",
    "JaskZone"
}

-- Iterate over each zone name and create a ZONE_CAPTURE_COALITION for it
for _, zoneName in ipairs(zoneNames) do
    local zone = ZONE:FindByName(zoneName)
    if zone then
        local captureZone = ZONE_CAPTURE_COALITION:New(zone, coalition.side.RED)
        MESSAGE:New(zoneName .. " capture initialized", 15, "INFO"):ToAll()
            --- @param Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION self
    function ZoneCaptureCoalition:OnEnterGuarded( From, Event, To )
        if From ~= To then
            local Coalition = self:GetCoalition()
            self:E( { Coalition = Coalition } )
            if Coalition == coalition.side.BLUE then
                ZoneCaptureCoalition:Smoke( SMOKECOLOR.Blue )
                US_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
                RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
            else
                ZoneCaptureCoalition:Smoke( SMOKECOLOR.Red )
                RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
                US_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
            end
        end
    end
    MESSAGE:New( "2 ", 15, "INFO" ):ToAll()

    --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
    function ZoneCaptureCoalition:OnEnterEmpty()
        ZoneCaptureCoalition:Smoke( SMOKECOLOR.Green )
        US_CC:MessageTypeToCoalition( string.format( "%s is unprotected, and can be captured!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        RU_CC:MessageTypeToCoalition( string.format( "%s is unprotected, and can be captured!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
    end
    MESSAGE:New( "3 ", 15, "INFO" ):ToAll()

    --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
    function ZoneCaptureCoalition:OnEnterAttacked()
        ZoneCaptureCoalition:Smoke( SMOKECOLOR.White )
        local Coalition = self:GetCoalition()
        self:E({Coalition = Coalition})
        if Coalition == coalition.side.BLUE then
            US_CC:MessageTypeToCoalition( string.format( "%s is under attack by Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
            RU_CC:MessageTypeToCoalition( string.format( "We are attacking %s", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        else
            RU_CC:MessageTypeToCoalition( string.format( "%s is under attack by the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
            US_CC:MessageTypeToCoalition( string.format( "We are attacking %s", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        end
    end
    MESSAGE:New( "4 ", 15, "INFO" ):ToAll()

    --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
    function ZoneCaptureCoalition:OnEnterCaptured()
        local Coalition = self:GetCoalition()
        self:E({Coalition = Coalition})
        if Coalition == coalition.side.BLUE then
            RU_CC:MessageTypeToCoalition( string.format( "%s is captured by the USA, we lost it!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
            US_CC:MessageTypeToCoalition( string.format( "We captured %s, Excellent job!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        else
            US_CC:MessageTypeToCoalition( string.format( "%s is captured by Russia, we lost it!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
            RU_CC:MessageTypeToCoalition( string.format( "We captured %s, Excellent job!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
        end
        self:AddScore( "Captured", "Zone captured: Extra points granted.", 200 )    
        self:__Guard( 30 )
    end
    MESSAGE:New( "5 ", 15, "INFO" ):ToAll()

    ZoneCaptureCoalition:__Guard( 1 )
    ZoneCaptureCoalition:Start( 5, 30 )
    --- @param Functional.Protect#ZONE_CAPTURE_COALITION self

    function ZoneCaptureCoalition:OnEnterEmpty()
        self:Flare( FLARECOLOR.White )
    end
    MESSAGE:New( "6 ", 15, "INFO" ):ToAll()
    else
        MESSAGE:New("Error: " .. zoneName .. " not found!", 15, "ERROR"):ToAll()
    end
end
]]--

MESSAGE:New("Start of Moose Script", 35, "INFO"):ToAll()

local zones = {"KishZone", "QeshmZone", "JaskZone"}
local zoneObjects = {}
local zoneControl = {}  

for _, zoneName in ipairs(zones) do
    local zone = ZONE:FindByName(zoneName)
    if not zone then
        MESSAGE:New("Error: Zone '" .. zoneName .. "' not found! Check the name and definition in the mission editor.", 15, "ERROR"):ToAll()
        return  -- Stop processing if a zone is not found
    end

    local zoneCoord = zone:GetCoordinate()
    if not zoneCoord then
        MESSAGE:New("Error: Coordinates for '" .. zoneName .. "' could not be retrieved. Check zone settings.", 15, "ERROR"):ToAll()
        return  -- Stop processing if coordinates are not available
    end

    if zone then
        local points = {
            zone:GetCoordinate():Translate( 0, 5000),  -- North
            zone:GetCoordinate():Translate(90, 5000),  -- East
            zone:GetCoordinate():Translate(180, 5000), -- South
            zone:GetCoordinate():Translate(270, 5000)  -- West
        }
    -- Function to deploy flares at the points
        local function DeployFlares()
            for _, coord in ipairs(points) do
                coord:FlareYellow()
            end
        end
        -- Deploy flares at mission start and every 30 minutes to mark the zone
        SCHEDULER:New(nil, DeployFlares, {}, 0, 1800)
    else
        MESSAGE:New("Error: Zone '" .. zoneName .. "' not found! Check the name and definition in the mission editor.", 15, "ERROR"):ToAll()
    end
end

MESSAGE:New("All zones processed successfully.", 15, "INFO"):ToAll()


-- Define a function to activate groups based on control
function ActivateGroup(groupName)
    local group = GROUP:FindByName(groupName)
    if group and not group:IsActive() then
        group:Activate()
        MESSAGE:New(groupName .. " has been activated.", 10):ToAll()
    elseif not group then
        MESSAGE:New("Group not found: " .. groupName, 15, "Error"):ToAll()
    end
end


function updateZoneMarkerAndMessage(zoneName, coalition)
    local messageText = zoneName .. " - Controlled by " .. coalition:upper() .. "FOR"
    local zoneCoord = zoneObjects[zoneName]:GetCoordinate()
    MESSAGE:New(zoneName .. " is now controlled by " .. coalition:upper() .. "FOR.", 10):ToAll()
end


-- Function to check and update zone control and send messages
function UpdateZoneControl()
    MESSAGE:New( "UPDATING ZONE CONTROLS ", 15, "INFO" ):ToAll()
    for zoneName, zoneObject in pairs(zoneObjects) do
        MESSAGE:New("232323", 15, "INFO"):ToAll()
        local blueGroups = SET_GROUP:New():FilterCoalitions("blue"):FilterZones({zoneObject}):FilterOnce()
        local redGroups = SET_GROUP:New():FilterCoalitions("red"):FilterZones({zoneObject}):FilterOnce()
        MESSAGE:New("66666", 15, "INFO"):ToAll()

        local blueInZone = blueGroups:Count() > 0
        local redInZone = redGroups:Count() > 0
        MESSAGE:New("17575757", 15, "INFO"):ToAll()

        MESSAGE:New("1", 15, "INFO"):ToAll()

        -- Check if no units are present from either side
        if not blueInZone and not redInZone then
            MESSAGE:New("2", 15, "INFO"):ToAll()
            if zoneControl[zoneName] ~= "neutral" then
                MESSAGE:New("3", 15, "INFO"):ToAll()
                zoneControl[zoneName] = "neutral"
                MESSAGE:New("4", 15, "INFO"):ToAll()
                local messageText = zoneName .. " is now NEUTRAL."
                MESSAGE:New("5", 15, "INFO"):ToAll()
                local zoneCoord = zoneObject:GetCoordinate()
                MESSAGE:New("6", 15, "INFO"):ToAll()
            end
        elseif blueInZone and not redInZone then
            MESSAGE:New("11", 15, "INFO"):ToAll()
            if zoneControl[zoneName] ~= "blue" then
                MESSAGE:New("12", 15, "INFO"):ToAll()
                zoneControl[zoneName] = "blue"
                MESSAGE:New("13", 15, "INFO"):ToAll()
                ActivateGroup("Blue_" .. zoneName)
                MESSAGE:New("14", 15, "INFO"):ToAll()
                updateZoneMarkerAndMessage(zoneName, "blue")
                MESSAGE:New("15", 15, "INFO"):ToAll()
            end
        elseif redInZone and not blueInZone then
            MESSAGE:New("16", 15, "INFO"):ToAll()
            if zoneControl[zoneName] ~= "red" then
                MESSAGE:New("17", 15, "INFO"):ToAll()
                zoneControl[zoneName] = "red"
                MESSAGE:New("18", 15, "INFO"):ToAll()
                ActivateGroup("Red_" .. zoneName)
                MESSAGE:New("19", 15, "INFO"):ToAll()
                updateZoneMarkerAndMessage(zoneName, "red")
                MESSAGE:New("20", 15, "INFO"):ToAll()
            end
        end
    end
end

-- Scheduler to check the zone control every 30 seconds
local checkScheduler = SCHEDULER:New(nil, UpdateZoneControl, {}, 0, 30)
if not checkScheduler then
    MESSAGE:New("Failed to create scheduler for zone control checks.", 15, "Error"):ToAll()
end


MESSAGE:New( "end of Moose Script", 35, "INFO" ):ToAll()

