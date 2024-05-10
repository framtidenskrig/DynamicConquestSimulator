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


MESSAGE:New( "Start CC and Set CAP for defence", 15, "INFO" ):ToAll()
do -- Setup the Command Centers
    RU_CC = COMMANDCENTER:New( GROUP:FindByName( "REDHQ" ), "Russia HQ" )
    US_CC = COMMANDCENTER:New( GROUP:FindByName( "BLUEHQ" ), "USA HQ"  )
end
MESSAGE:New( "CC and CAP done", 15, "INFO" ):ToAll()

-------------------------------------- END CAP BLUE -----------------------------------------------


-- Define zones, initial xp and level etc
local zones = {
    {name = "bf1", id_paint = 0, id_text = 100, level = 0, xp = 0, coalition = "Blue"},
    {name = "bf2", id_paint = 1, id_text = 101, level = 0, xp = 0, coalition = "Blue"},
    {name = "bf3", id_paint = 2, id_text = 102, level = 0, xp = 0, coalition = "Blue"},
    {name = "rmh1", id_paint = 3, id_text = 103, level = 0, xp = 0, coalition = "Red"},
    {name = "rmh2", id_paint = 4, id_text = 104, level = 0, xp = 0, coalition = "Red"},
    {name = "rmh3", id_paint =5, id_text = 105, level = 0, xp = 0, coalition = "Red"},
    {name = "rmf1", id_paint = 7, id_text = 106, level = 0, xp = 0, coalition = "Red"},
    {name = "rmf2", id_paint = 8, id_text = 107, level = 0, xp = 0, coalition = "Red"},
    {name = "rmf3", id_paint = 9, id_text = 108, level = 0, xp = 0, coalition = "Red"},
    {name = "rmf4", id_paint = 10, id_text = 109, level = 0, xp = 0, coalition = "Red"},
    {name = "rf1", id_paint = 11, id_text = 110, level = 0, xp = 0, coalition = "Red"},
    {name = "rf2", id_paint = 12, id_text = 111, level = 0, xp = 0, coalition = "Red"},
    {name = "rf3", id_paint = 13, id_text = 112, level = 0, xp = 0, coalition = "Red"},
    {name = "rf4", id_paint = 14, id_text = 113, level = 0, xp = 0, coalition = "Red"},
    {name = "rf5", id_paint = 15, id_text = 114, level = 0, xp = 0, coalition = "Red"},
}

local homeZones = {
    {name = "bhome", id_paint = 200, id_text = 300, level = 1, xp = 1000, coalition = "Blue"},
    {name = "rhome", id_paint = 201, id_text = 301, level = 1, xp = 1000, coalition = "Red"},
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
    Neutral = {0, 1, 0, 0.4} -- Green color with 70% opacity
}

local texthome = 1
local zoneStatus = {}


--------------------------------------------------------------------------------------------------------








--------------- Function ZonePainter for Homes ----------------


local function ZonePainterHome(zone)
    local zoneObject = ZONE:FindByName(zone.name)
    if not zoneObject then  
        MESSAGE:New("Zone not found: " .. zone.name, 15, "ERROR"):ToAll()
        return
    end

    local homecolor
    if zone.coalition == "Blue" then
        homecolor = colors.Blue
    elseif zone.coalition == "Red" then
        homecolor = colors.Red
    else
        -- Handle other cases or errors
        return
    end

    -- Retrieve the reference for drawing from DCS environment
    local ref = trigger.misc.getZone(zone.name)
    if not ref then
        MESSAGE:New("Reference zone not found for drawing: " .. zone.name, 15, "ERROR"):ToAll()
        return
    end

    -- Draw the circle with the color and unique identifier
    trigger.action.circleToAll(-1, zone.id_paint, ref.point, ref.radius, {0, 0, 0, .7}, homecolor, 1, false, zone.name)

    -- Calculate the text position offset based on the zone's name length and radius
    local offset = {x = ref.point.x + ref.radius + 50, y = 0, z = ref.point.z - ((string.len(zone.name)/2) * 5)}

    -- Draw the text with the unique identifier
    trigger.action.textToAll(-1, zone.id_text, offset, {1, 1, 1, 0.7}, {0, 0, 0, .7}, 20, false, zone.name .. " - ".. zone.coalition .. " - Level " .. zone.level .. " - XP " .. zone.xp)
end


-------------- End ZonePainter for Homes ------------------




--------------- Function ZonePainter ----------------

local function ZonePainter(zone)
    local zoneObject = ZONE:FindByName(zone.name)
    if not zoneObject then
        MESSAGE:New("Zone not found: " .. zone.name, 15, "ERROR"):ToAll()
        return
    end

    local zonecolor
    if zone.coalition == "Blue" then
        zonecolor = colors.Blue
    elseif zone.coalition == "Red" then
        zonecolor = colors.Red
    else
        -- Handle case where the coalition is neither 'Blue' nor 'Red'
        MESSAGE:New("Unknown coalition for zone: " .. zone.name, 15, "ERROR"):ToAll()
        return
    end

    -- Drawing the zone with appropriate color to reflect coalition
    local ref = trigger.misc.getZone(zone.name)
    if not ref then
        MESSAGE:New("Reference zone not found for drawing: " .. zone.name, 15, "ERROR"):ToAll()
        return
    end

    trigger.action.circleToAll(-1, zone.id_paint, ref.point, ref.radius, {0, 0, 0, .7}, zonecolor, 1, false, zone.name)

    -- Calculate the text position offset based on the zone's name length and radius
    local offset = {x = ref.point.x + ref.radius + 50, y = 0, z = ref.point.z - ((string.len(zone.name)/2) * 5)}
    trigger.action.textToAll(-1, zone.id_text, offset, {1, 1, 1, 0.7}, {0, 0, 0, .7}, 20, false, zone.name .. " - ".. zone.coalition .. " - Level " .. zone.level .. " - XP " .. zone.xp)
end

-------------- End ZonePainter -----------------

--------------- Function ZonePainter ----------------

local function ZoneUpdater(zoneName)
    -- First check in homeZones
    for _, zone in ipairs(homeZones) do
        if zone.name == zoneName then
            local zoneObject = ZONE:FindByName(zone.name)
            if not zoneObject then
                MESSAGE:New("Zone not found: " .. zone.name, 15, "ERROR"):ToAll()
                return
            end
                
            local zonecolor
            if zone.coalition == "Blue" then
                zonecolor = colors.Blue
            elseif zone.coalition == "Red" then
                zonecolor = colors.Red
            else
                zonecolor = colors.Neutral
            end
        
            -- Drawing the zone with appropriate color to reflect coalition
            local ref = trigger.misc.getZone(zone.name)
            if not ref then
                MESSAGE:New("Reference zone not found for drawing: " .. zone.name, 15, "ERROR"):ToAll()
                return
            end
        
            trigger.action.setMarkupColorFill(zone.id_paint, zonecolor)
        
            -- Calculate the text position offset based on the zone's name length and radius
            trigger.action.setMarkUpText(zone.id_text, zone.name .. " - ".. zone.coalition .. " - Level " .. zone.level .. " - XP " .. zone.xp)
            return
        end
    end

    -- If not found, check in zones
    for _, zone in ipairs(zones) do
        if zone.name == zoneName then
            local zoneObject = ZONE:FindByName(zone.name)
            if not zoneObject then
                MESSAGE:New("Zone not found: " .. zone.name, 15, "ERROR"):ToAll()
                return
            end
        
        
            local zonecolor
            if zone.coalition == "Blue" then
                zonecolor = colors.Blue
            elseif zone.coalition == "Red" then
                zonecolor = colors.Red
            else
                zonecolor = colors.Neutral
            end
        
            -- Drawing the zone with appropriate color to reflect coalition
            local ref = trigger.misc.getZone(zone.name)
            if not ref then
                MESSAGE:New("Reference zone not found for drawing: " .. zone.name, 15, "ERROR"):ToAll()
                return
            end
        
            trigger.action.setMarkupColorFill(zone.id_paint, zonecolor)
        
            -- Calculate the text position offset based on the zone's name length and radius
            trigger.action.setMarkupText(zone.id_text, zone.name .. " - ".. zone.coalition .. " - Level " .. zone.level .. " - XP " .. zone.xp)
            return
        end
    end

    print(zoneName .. " not found in any zone array")
end
-------------- End ZonePainter -----------------




--------------- Function levelhandler ----------------

local function Levelhandler(zoneName)
    -- Find the zone object with the specified name
    local zoneObject = nil
    for _, zone in ipairs(zones) do
        if zone.name == zoneName then
            zone.xp = zone.xp + 10
            zoneObject = zone
            break
        end
    end

    for _, zone in ipairs(homeZones) do
        if zone.name == zoneName and zone.coalition ~= "Neutral" then
            zone.xp = zone.xp + 10
            zoneObject = zone
            break
        end
    end

    if not zoneObject then
        MESSAGE:New("Zone not found: " .. zoneName, 15, "ERROR"):ToAll()
        return
    end

    local currentLevelIndex = zoneObject.level
    local nextLevelIndex = currentLevelIndex + 1

    -- Check if there is a next level
    if nextLevelIndex > #zoneLevel then
        return false, "This zone is at the maximum level."  -- No next level available
    end

    local currentXP = zoneObject.xp
    local nextLevelXP = zoneLevel[nextLevelIndex].xp
    local xptonext = nextLevelXP - currentXP

    if currentXP >= nextLevelXP then
        zoneObject.level = nextLevelIndex
        MESSAGE:New(zoneName .. " leveled up to: Level " .. zoneObject.level, 15, "INFO"):ToAll()
        return true, "Ready to level up!"
    else
        MESSAGE:New(zoneName .. " needs " .. xptonext .. " more XP before leveling up to: Level " .. nextLevelIndex, 15, "INFO"):ToAll()
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





------------------------------- INIT'S ---------------------------------------------------

-------------------------- Init home zones -------------------------------


for _, zone in ipairs(homeZones) do
    ZonePainterHome(zone)
    ActivateDefense(zone.name, zone.coalition)
end


--------------------- End Init home zones -------------------------



-------------------------- Init zones -------------------------------


for _, zone in ipairs(zones) do
    ZonePainter(zone)
    ActivateDefense(zone.name, zone.coalition)
end


-------------------------- End Init zones -------------------------------







------------- Function UpdateZone -------------


local function UpdateZone()
    MESSAGE:New("Updating zones", 15, "INFO"):ToAll()

    for _, zone in ipairs(zones) do
        MESSAGE:New("Updating " .. zone.name, 15, "INFO"):ToAll()
        local zoneObject = ZONE:FindByName(zone.name)
        if not zoneObject then
            MESSAGE:New("Zone not found: " .. zone.name, 15, "ERROR"):ToAll()  -- Use zone.name instead of zoneObject.name
        else
            MESSAGE:New("We found " .. zone.name .. " and its " .. zone.coalition, 15, "INFO"):ToAll()  -- Use zone.name here directly
            local blueInZone = SET_GROUP:New():FilterCoalitions("blue"):FilterZones({zoneObject}):FilterOnce():Count() > 0
            local redInZone = SET_GROUP:New():FilterCoalitions("red"):FilterZones({zoneObject}):FilterOnce():Count() > 0
            local newCoalition
            MESSAGE:New("We filtered " .. zone.name, 15, "INFO"):ToAll()

            if blueInZone and not redInZone then    
                newCoalition = "Blue"
            elseif redInZone and not blueInZone then
                newCoalition = "Red"
            else
                newCoalition = "Neutral"
            end

            MESSAGE:New(zone.name .. " is " .. newCoalition, 15, "INFO"):ToAll()

            if newCoalition ~= zone.coalition then
                zone.coalition = newCoalition  -- Update coalition directly in the zones array
                zone.xp = 0
                zone.level = 0
                ActivateDefense(zone.name, newCoalition)
            end

            MESSAGE:New("Handling level of " .. zone.name, 15, "INFO"):ToAll()
            Levelhandler(zone.name)

            MESSAGE:New("Repainting " .. zone.name, 15, "INFO"):ToAll()
            ZoneUpdater(zone.name)  -- Make sure to pass zone.name if ZoneUpdater expects a string
        end
    end

    MESSAGE:New("All zones updated successfully", 15, "INFO"):ToAll()
end



------------- End UpdateZone -------------






--------------------------- SCHEDULERs --------------------------------

-- Scheduler to check the zone control every 30 seconds
SCHEDULER:New(nil, UpdateZone, {}, 15, 30)


