---@diagnostic disable: lowercase-global
-- Define a SET_GROUP object that builds a collection of groups that define the EWR network.
-- Here we build the network with all the groups that have a name starting with DF CCCP AWACS and DF CCCP EWR.

MESSAGE:New( "start of Moose Script", 15, "INFO" ):ToAll()

------------------ CAP RED ----------------------

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
CAPZoneE = ZONE:FindByName("CAP Zone E")
A2ADispatcher_Red:SetSquadronCap( "Bandar-E-Jask", CAPZoneE, 3000, 10000, 400, 800, 700, 1200, "BARO" )
A2ADispatcher_Red:SetSquadronCapInterval( "Bandar-E-Jask", 1, 60, 600)


A2ADispatcher_Red:SetSquadron( "Bandar Abbas", AIRBASE.PersianGulf.Bandar_Abbas_Intl, { "SQ CCCP MID" }, 20 )
A2ADispatcher_Red:SetSquadronGrouping( "Bandar Abbas", 2 )
A2ADispatcher_Red:SetSquadronTakeoffFromParkingHot("Bandar Abbas")
A2ADispatcher_Red:SetSquadronLandingAtRunway( "Bandar Abbas" )
CAPZoneM = ZONE:FindByName("CAP Zone M")
A2ADispatcher_Red:SetSquadronCap( "Bandar Abbas", CAPZoneM, 3000, 10000, 400, 800, 700, 1200, "BARO" )
A2ADispatcher_Red:SetSquadronCapInterval( "Bandar Abbas", 1, 60, 600)


A2ADispatcher_Red:SetSquadron( "Kish", AIRBASE.PersianGulf.Kish_Intl, { "SQ CCCP WEST" }, 20 )
A2ADispatcher_Red:SetSquadronGrouping( "Kish", 2 )
A2ADispatcher_Red:SetSquadronTakeoffFromParkingHot("Kish")
A2ADispatcher_Red:SetSquadronLandingAtRunway( "Kish" )
CAPZoneW = ZONE:FindByName("CAP Zone W")
A2ADispatcher_Red:SetSquadronCap( "Kish", CAPZoneW, 3000, 10000, 400, 800, 700, 1200, "BARO" )
A2ADispatcher_Red:SetSquadronCapInterval( "Kish", 1, 60, 600)

MESSAGE:New( "CC start", 15, "INFO" ):ToAll()
do -- Setup the Command Centers
    RU_CC = COMMANDCENTER:New( GROUP:FindByName( "REDHQ" ), "Russia HQ" )
    US_CC = COMMANDCENTER:New( GROUP:FindByName( "BLUEHQ" ), "USA HQ" )
end
MESSAGE:New( "CC done", 15, "INFO" ):ToAll()

-------------------------------------- END CAP RED -----------------------------------------------








--------------------------------------  CAP BLUE -----------------------------------------------

-- Setup detection set for the Blue team
DetectionSetGroup_Blue = SET_GROUP:New()
DetectionSetGroup_Blue:FilterPrefixes({ "DF BLUE AWACS", "DF BLUE EWR" })
DetectionSetGroup_Blue:FilterStart()

Detection_Blue = DETECTION_AREAS:New(DetectionSetGroup_Blue, 5000)

-- Setup the A2A dispatcher for the Blue team
A2ADispatcher_Blue = AI_A2A_DISPATCHER:New(Detection_Blue)

-- Define the border zone for the Blue team
BlueBorderZone = ZONE_POLYGON:New("Blue Border", GROUP:FindByName("Blue Border"))
A2ADispatcher_Blue:SetBorderZone(BlueBorderZone)

-- Enable tactical display (optional)
A2ADispatcher_Blue:SetTacticalDisplay(true)

-- Setup squadron Khaimah for Blue team
A2ADispatcher_Blue:SetSquadron("Khaimah", AIRBASE.PersianGulf["Ras_Al_Khaimah_Intl"], {"SQ BLUE SM"}, 20)
A2ADispatcher_Blue:SetSquadronGrouping("Khaimah", 3)
A2ADispatcher_Blue:SetSquadronTakeoffFromParkingHot("Khaimah")
A2ADispatcher_Blue:SetSquadronLandingAtRunway("Khaimah")
CAPZoneSM = ZONE:FindByName("CAP Zone SM")
A2ADispatcher_Blue:SetSquadronCap("Khaimah", CAPZoneSM, 3000, 10000, 400, 800, 700, 1200, "BARO")
A2ADispatcher_Blue:SetSquadronCapInterval("Khaimah", 2, 60, 600)

-- Setup squadron Minhad for Blue team
A2ADispatcher_Blue:SetSquadron("Minhad", AIRBASE.PersianGulf["Al_Minhad_AFB"], {"SQ BLUE SW"}, 20)
A2ADispatcher_Blue:SetSquadronGrouping("Minhad", 4)
A2ADispatcher_Blue:SetSquadronTakeoffFromParkingHot("Minhad")
A2ADispatcher_Blue:SetSquadronLandingAtRunway("Minhad")
CAPZoneSW = ZONE:FindByName("CAP Zone SW")
A2ADispatcher_Blue:SetSquadronCap("Minhad", CAPZoneSW, 3000, 10000, 400, 800, 700, 1200, "BARO")
A2ADispatcher_Blue:SetSquadronCapInterval("Minhad", 2, 60, 600)

-- Setup squadron Fujairah for Blue team
A2ADispatcher_Blue:SetSquadron("Fujairah", AIRBASE.PersianGulf["Fujairah_Intl"], {"SQ BLUE SE"}, 20)
A2ADispatcher_Blue:SetSquadronGrouping("Fujairah", 4)
A2ADispatcher_Blue:SetSquadronTakeoffFromParkingHot("Fujairah")
A2ADispatcher_Blue:SetSquadronLandingAtRunway("Fujairah")
CAPZoneSE = ZONE:FindByName("CAP Zone SE")
A2ADispatcher_Blue:SetSquadronCap("Fujairah", CAPZoneSE, 3000, 10000, 400, 800, 700, 1200, "BARO")
A2ADispatcher_Blue:SetSquadronCapInterval("Fujairah", 2, 60, 600)

-- Add more squadrons as needed, repeating the pattern above for each new squadron
-- Example:
-- A2ADispatcher_Blue:SetSquadron("Another Base", AIRBASE.PersianGulf.<BaseName>, {"Squadron ID"}, <Number of planes>)
-- Additional configurations can be replicated as per the above squadron setup




-------------------------------------- END CAP BLUE -----------------------------------------------


-- Define zones, initial xp and level etc
local zones = {
    {name = "bf1", level = 0, xp = 0, coalition = "Blue"},
    {name = "bf2", level = 0, xp = 0, coalition = "Blue"},
    {name = "bf3", level = 0, xp = 0, coalition = "Blue"},
    {name = "rmh1", level = 0, xp = 0, coalition = "Red"},
    {name = "rmh2", level = 0, xp = 0, coalition = "Red"},
    {name = "rmh3", level = 0, xp = 0, coalition = "Red"},
    {name = "rmf1", level = 0, xp = 0, coalition = "Red"},
    {name = "rmf2", level = 0, xp = 0, coalition = "Red"},
    {name = "rmf3", level = 0, xp = 0, coalition = "Red"},
    {name = "rmf4", level = 0, xp = 0, coalition = "Red"},
    {name = "rf1", level = 0, xp = 0, coalition = "Red"},
    {name = "rf2", level = 0, xp = 0, coalition = "Red"},
    {name = "rf3", level = 0, xp = 0, coalition = "Red"},
    {name = "rf4", level = 0, xp = 0, coalition = "Red"},
    {name = "rf5", level = 0, xp = 0, coalition = "Red"},
}

local homeZones = {
    {name = "bhome", level = 1, xp = 1000, coalition = "Blue"},
    {name = "rhome", level = 1, xp = 1000, coalition = "Red"},
}



local zoneLevel = {
    {level = 1, xp = 0, defense = "", AntiAir = ""},
    {level = 2, xp = 1000, defense = "low", AntiAir = "low"},
    {level = 3, xp = 2000, defense = "medium", AntiAir = "medium"},
    {level = 4, xp = 4000, defense = "high", AntiAir = "high"},
    {level = 5, xp = 8000, defense = "max", AntiAir = "max"},
}

local colors = {
    Red = {1, 0, 0, 0.4},   -- Red color with 70% opacity
    Blue = {0, 0, 1, 0.4},  -- Blue color with 70% opacity
    Green = {0, 1, 0, 0.4} -- Green color with 70% opacity
}

local texthome = 1
local zoneStatus = {}


--------------------------------------------------------------------------------------------------------








--------------- Function ZonePainter for Homes ----------------

local function ZonePainterHome(zone)
    local homecolor

    local zoneObject = ZONE:FindByName(zone)
    if not zoneObject then
        MESSAGE:New("Zone not found: " .. zone.name, 15, "ERROR"):ToAll()
        return
    end

    if string.sub(zone,1,1) == "b" then
        homecoalition = {coalition = "Blue"}
        homecolor = colors.Blue
        homepaintedzone = 1000
        hometextzone = 2000
    elseif string.sub(zone,1,1) == "r" then
        homecoalition = {coalition = "red"}
        homecolor = colors.Red
        homepaintedzone = 3000
        hometextzone = 4000
    end
    

    -- drawing homezone with appropriate color to reflect coalition
    local ref = trigger.misc.getZone(zone)
    trigger.action.circleToAll(-1 , homepaintedzone, ref.point , ref.radius , {0, 0, 0, .7} , homecolor , 1 , true, zone)
    homepaintedzone = homepaintedzone + 1

    local offset = {x = ref.point.x + ref.radius + 50, y = 0, z = ref.point.z - ((string.len(zone)/2))}
    trigger.action.textToAll(-1 , hometextzone , offset, {1, 1, 1, 0.7} , {0, 0, 0, .7} , 20, true , homeZones[texthome].name)
    texthome = texthome + 1
end

-------------- End ZonePainter for Homes ------------------






--------------- Function ZonePainter ----------------

local paintedzone = 200
local textzone = 300

local function ZonePainter(zone)
    local inthomecoalition, homecolor

    local zoneObject = ZONE:FindByName(zone.name)
    if not zoneObject then
        MESSAGE:New("Zone not found: " .. zone.name, 15, "ERROR"):ToAll()
        return
    end

    if string.sub(zone.name, 1, 1) == "b" then
        homecolor = colors.Blue
    elseif string.sub(zone.name, 1, 1) == "r" then
        homecolor = colors.Red
    else
        -- Handle case where the zone does not start with 'b' or 'r'
        return
    end

    -- Drawing the zone with appropriate color to reflect coalition
    local ref = trigger.misc.getZone(zone.name)
    trigger.action.circleToAll(-1, paintedzone, ref.point, ref.radius, {0, 0, 0, .7}, homecolor, 1, true, zone.name)
    paintedzone = paintedzone + 1

    local offset = {x = ref.point.x + ref.radius + 50, y = 0, z = ref.point.z - ((string.len(zone.name)/2))}
    trigger.action.textToAll(-1, textzone, offset, {1, 1, 1, 0.7} , {0, 0, 0, .7}, 20, true, zones[paintedzone-200].name)
    textzone = textzone + 1
end

-------------- End ZonePainter -----------------






--------------- Function levelhandler ----------------

local function Levelhandler(zoneName)
    local currentLevelIndex = zoneName.level
    local nextLevelIndex = currentLevelIndex + 1
    zoneName.xp = zoneName.xp + 10
    
    -- Check if there is a next level
    if nextLevelIndex > #zoneLevel then
        return false, "This zone is at the maximum level."  -- No next level available
    end

    local currentXP = zoneName.xp
    local nextLevelXP = zoneLevel[nextLevelIndex].xp
    local xptonext = nextLevelXP - currentXP

    if currentXP >= nextLevelXP then
        zoneName.level = nextLevelIndex
        MESSAGE:New(zoneName .. "leveled up to: Level " .. zoneName.level, 15, "INFO"):ToAll()
        return true, "Ready to level up!"
    else
        MESSAGE:New(zoneName .. " needs " .. xptonext " more XP before leveling up to:  " .. zoneName.level, 15, "INFO"):ToAll()
    end

end

--------------- end levelhandler  ----------------





------------- Function ActivateDefense-------------

function ActivateDefense(zoneName, coalition)
    local groupName = coalition .. "_" .. zoneName
    local group = GROUP:FindByName(groupName)
    if group then
        group:Activate()
    end
end

------------- End ActivateDefense-------------





------------- Function UpdateZoneControl -------------

function UpdateZoneControl()
    for zoneName, zoneObject in pairs(zones) do
        MESSAGE:New( "Updating" .. zones.name, 15, "INFO: "):ToAll()
        Levelhandler(zones)
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

------------- End UpdateZoneControl -------------










------------------------------- INIT'S ---------------------------------------------------

-------------------------- Init home zones -------------------------------

MESSAGE:New("Init home zones", 15, "INFO"):ToAll()

for _, zoneName in ipairs(homeZones) do
    local alias = zoneName.name
    ZonePainterHome(alias)
    ActivateDefense(alias, zoneName.coalition)
end


--------------------- End Init home zones -------------------------





-------------------------- Init zones -------------------------------

MESSAGE:New("Init rest of  zones", 15, "INFO"):ToAll()

for _, zone in ipairs(zones) do
    ZonePainter(zone)
    ActivateDefense(zone.name, zone.coalition)
end


-------------------------- End Init zones -------------------------------





--------------------------- SCHEDULERs --------------------------------

-- Scheduler to check the zone control every 30 seconds
SCHEDULER:New(nil, UpdateZoneControl, {}, 0, 15)


