--[[
********************************************************************************
*                            Fishing Gatherer Scrips                            *
*                                Version 1.0.1                                 *
********************************************************************************

Created by: pot0to (https://ko-fi.com/pot0to)
Loosely based on Ahernika's NonStopFisher

********************************************************************************
*                               Required Plugins                               *
********************************************************************************

AutoHook
VnavMesh
Lifestream

********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

FishToFarm = "Zorgor Condor"
SwitchLocationsAfter                = 10        --Number of minutes to fish at this spot before changing spots.

Retainers                           = true      --If true, will do AR (autoretainers)
GrandCompanyTurnIn                  = true      --If true, will do GC deliveries using deliveroo everytime retainers are processed
ReturnToGCTown                      = true      --if true will use fast return to GC town for retainers and scrip exchange (that assumes you set return location to your gc town else turn it false), else falase
--needs a yesalready set up like "/Return to New Gridania/"

Food                                = ""        --what food to eat (false if none)
Potion                              = "Superior Spiritbond Potion <hq>"     --what potion to use (false if none)

--things you want to enable
ExtractMateria                      = true      --If true, will extract materia if possible
ReduceEphemerals                    = true      --If true, will reduce ephemerals if possible
Repair                              = true      --If true, will do repair if possible set repair amount below
RepairAmount                        = 1         --repair threshold, adjust as needed

MinInventoryFreeSlots               = 1           --set !!!carefully how much inventory before script stops gathering and does additonal tasks!!!

HubCity                             = "Solution Nine"   --options:Limsa/Gridania/Ul'dah/Solution Nine

--[[
********************************************************************************
*           Code: Don't touch this unless you know what you're doing           *
********************************************************************************
]]

HubCities =
{
    {
        zoneName="Limsa",
        zoneId = 129,
        aethernet = {
            aethernetZoneId = 129,
            aethernetName = "Hawkers' Alley",
            x=-213.61108, y=16.739136, z=51.80432
        },
        retainerBell = { x=-123.88806, y=17.990356, z=21.469421, requiresAethernet=false },
        scripExchange = { x=-258.52585, y=16.2, z=40.65883, requiresAethernet=true }
    },
    {
        zoneName="Gridania",
        zoneId = 132,
        aethernet = {
            aethernetZoneId = 133,
            aethernetName = "Sapphire Avenue Exchange",
            x=131.9447, y=4.714966, z=-29.800903
        },
        retainerBell = { x=168.72, y=15.5, z=-100.06, requiresAethernet=true },
        scripExchange = { x=142.15, y=13.74, z=-105.39, requiresAethernet=true },
    },
    {
        zoneName="Ul'dah",
        zoneId = 130,
        aethernet = {
            aethernetZoneId = 131,
            aethernetName = "Leatherworkers' Guild & Shaded Bower",
            x=101, y=9, z=-112
        },
        retainerBell = { x=171, y=15, z=-102, requiresAethernet=true },
        scripExchange = { x=142.68, y=13.75, z=-104.59, requiresAethernet=true },
    },
    {
        zoneName="Solution Nine",
        zoneId = 1186,
        aethernet = {
            aethernetZoneId = 1186,
            aethernetName = "Nexus Arcade",
            x=-161, y=-1, z=21
        },
        retainerBell = { x=-152.465, y=0.660, z=-13.557, requiresAethernet=true },
        scripExchange = { x=-158.019, y=0.922, z=-37.884, requiresAethernet=true }
    }
}

OrangeGathererScripId = 41785

FishTable =
{
    {
        fishName = "Zorgor Condor",
        fishId = 43761,
        baitName = "Versatile Lure",
        zoneId = 1190,
        zoneName = "Shaaloani",
        autohookPreset = "AH4_H4sIAAAAAAAACu1YW3OjNhT+K5Rnq8NF4pI3r5uk6eQ2a7ed6U4fhCQwE4y8Quwm3cl/7xEYG2ycTHb80Eve4OjoOxc+fZL4Zk9rLWe00tUszeyzb/Z5SZNCTIvCPtOqFhPbDF7npdgN8m7oCp68KJ7Y9yqXKtdP9pkL1ur8kRU1F3xnNv7PLdaNlGxpwJoHzzw1OEE0sS/Xi6US1VIWYHEdZ4D8MnSDEYeDGc6rycyW9arLALsOfiWFbpYsCsH0kY4Ajtuf5b2ehVQ8p8URPNcLgkGP8WbaRV4tz59E1SuA7BVAyKCAoPsG9EHMl3mqP9C8KcMYqs4w15Q9ACqAbb7MIW4fNd6g3lOdi5KJXj7B/rxg2FCvm6ryv8SM6pYZYzSDJPbBvL2v42/AFkta5PShuqBfpDJ4A0NXnT8Z2j8KJr8I8HdNz46kgAcBu3Z+yLNLumrqnpZZIVTVBfHaqX7o4IPsB1DRM2CdP2pFN+vQfIiFnH+l66tS17nOZXlJ87LrLQKKXddK3IiqohmEtu2JfdskYd9KWK2TFuFpDRbTmBG8a1np78a7h0LEeIY2so+MtxGb8V0+8zWsJUWLWa2UKPWJqtxDPVmto9keVDwavfG6kIoJbvA3iuWCZrWsmWu5Nms6L7O5FutGTHcFbZg1Vaepow/XJPZrmX+uhcG1eeglOIxT5LvUQRgTB8G7j9I4ijn2HIYT3wa867zSd6mJAVT/1HLWFLDV9La6Yzn+BvFBMgphGQ8DeCvVihY/S/lgIDo9+V3Q5t3YIf/t0kxpUcHabN83g6a0btFuTG392A2NTnWYc61k2dvwjkxf5Cuh9rTgJi+3Q/CN4h+dg1CO3wt1LTJRcqqeTlBDA/yTrMF5ryuthxfEW4ddiUddxlLrey1Uvj4WKSSev3U5Fmvg9EK0jZ9ZAdNUCzWjdbaEY8fKbE9A87Gl0RxMgDjN/mceeso+o9D4Yqq1WK1110vjs6AqEy3mXVk8NRjG1PmM6L4fkvjwYPDCpm5OI53idVz+KD7XuRIcctS12VvNcecIwV8h7Fu59s6dt3HnRBTo6SkLI8JZ4CDiYg566jkoZq6HGBckjXgcE0ZA/g4FFPsR8Y8L6IwyXVNl/ZJn/2r1vKGPPZuP3xX1XVHfFfW/sxufQEIpTh3hEopwEmGE05AhiuMIJSzymUi9iHM4Qf7ZnUk3Pxk+bQ2tqsIZdSivkNRxef1Dqkwqa86kWsNWPjhOuy/154rDmT9ncPyHpphgrcN0Jety4AYpkHj/YugP7+yRiVSrlILsFkZfx386kJi8cj0mAPSP+fmyu9d8923GTDaWmelq09D+/WZzqzGPrXnnNkbfHtXcJPYo9iIUeBz4RrCPYoEFchIv5IHj40R4zW69R6XgoICp9RViCG5VS8rlV0vllaisVMkVDGiIb+mlsFZA0B8OWDeTJYe/F6fm3Dh13k7Bd86dlHNCeD7IWYS4oD7CMeeIJg5BASMkjmAlh9gd5ZzzwvWaZoqW2gJCMArq+C5f/wv54jymIQkTlNIAqESYi6KER8gjjFLfC2gS0manbHHHVMdC1h1QJxOw98FZoRr+HYoi7EZUYBQxsxWHOEQxSRhKhB+5cF8JQCbt578BALnDoFoYAAA=",
        fishingSpots = {
            { waypointX=200.699, waypointY=12.000, waypointZ=735.425, x=197.205, y=11.194, z=750.186 },
            { waypointX=114.894, waypointY=5.233,  waypointZ=711.255, x=120.631, y=5.295,  z=724.759 },
            { waypointX=69.043,  waypointY=-0.889, waypointZ=727.032, x=75.741,  y=-1.648, z=737.941 },
            { waypointX=10.366,  waypointY=-5.563, waypointZ=743.747, x=12.425,  y=-7.169, z=756.219 }
        },
        collectiblesTurnInListIndex = 6,
        collectiblesTurnInScripId = 39
    },
    {
        fishName = "Fleeting Brand",
        fishId = 36473,
        baitName = "Versatile Lure",
        zoneId = 959,
        zoneName = "Mare Lamentorum",
        autohookPreset = "AH4_H4sIAAAAAAAACu1YTVPjOBD9Kymf4yl/f3ALGWCpCgxFwu5hag+y3U5UOFZGllmyU/z3adlWYicOmZoiFAculGlJr59aT63u/NRGpWBjUohinM61s5/aRU6iDEZZpp0JXsJQk4MTmsN2MFFD1/hlBeFQu+OUcSrW2pmJ1uLiOc7KBJKtWc5/qbFuGIsXEqz6sORXheMFQ+1qNVtwKBYsQ4tpGB3k16ErjNDvrDCOkhkvyqVi4JiGc4SCWsWyDGJxICKIY7ZXWcdZMJ5QklVE8ifgytCdPOxzZlqeF+6wdrqsu5saRewJzzIlWaHcX9JicbGGohUIdwfSdTuQnjpL8gjTBU3FOaFVOKShUIapIPEjoiJYc8L7uG3UsEG9I4JCHh9SHNLzdmG87jlZConT/2FMRC04RWJ3tbVzynazerYgGSWPxSV5YlwCdAxqd/awa7+HGCOM800Zs74bgxR2hWZ3CKjwntP5FVlWcRjl8wx4oZxKTcllvuHs7aYDFbwg1sWz4KS53/JgZmz6H1ld56KkgrL8itBcxUdH6U5KDjdQFGSOrjVtqN1WJLRbhllgWCOsV2iRgerBm7BC/DHeHW4E+hlqunZgvPZYjW/5TFd4RznJxiXnkIs32uUO6pvttZft3o57vVezaoFMBVvJ60zz+VTAqsrHW+6NiEb8bSi34SoODzn9UYLE1dIoiAkEhm7GIdEdN0j00I4iPTUAwtBMzBBsDfEmtBDfUukDVf29lqfcwOa+hr7pH+b4N/rHbJHBQM6QgLeML0n2F2OPEkKlkn+AVP9LO/Lf3MoqDapb2gzKran7Kk0zugS+c49vaL4Zkk/TF+R4Q57btvALXv8Gso6fY/oyxSlOU8FZ3npzT+/esFvuJzCHPCF8/QHiUhH7ykqEOnJSb+rY8sKN3+1pnMzF70T8BM5nnK7eOa6+a9kbz6eKbMfJ+8e2cS8z7igVwMeknC+wUl7KSgjTal8qrmppTFRVqSU/WkVE/Z674X4N2n3QX6kmZRmsnkSVAe/hR0k5JOhJlLIYk3V2X1o8fZp712z2mZ0+s9Nndvpg2alVIAYGpF5CUt02A093jNjUie/HumcHsW8Zielaifbyr6oQm18Nvm8MdZGIFWO7WrQ9x7cPV4uXGYDAHQ/OOcmTTm1rHgyW7OKuEyy2aYx1N4ZIOvuWZ+uHAh7yBPi2XVU/mMjVoyUr81bA+xpZN9xt3mzp7SvLxZggYtbsunm/tvEMJNuSpwTTayarsqZxd0P3SG/r4soP8wvMtjP5435ELpaWsYx2Feh2h9L0JfKzNm+n7V8Ao6NPK3LtwLAsPY3sQHcSYuhR4Nq6ZXmuATZxIyPCfmNff+7hHdzDnAlGC/hN6Zk9yutX12tyelU2/bLsVdFxWX6q67C6OuJyIhL6jk/0xI8c3Qk90EmCMkvD1DNMMwwTB5tZzHW1anvT10Af3JUcS9/BNMYSuOj234GUrRekOknNSHeISzC9Ehf/uIGTgOO4JNZefgEjD0ty/xUAAA==",
        fishingSpots = {
            {waypointX = 15.25, waypointY = 23.72, waypointZ = 459.84, x = 13.53, y = 22.93, z = 463.75},
            {waypointX = 26.27, waypointY = 22.11, waypointZ = 468.88, x = 23.14, y = 21.73, z = 472.73},
            {waypointX = 34.51, waypointY = 21.7, waypointZ = 481.15, x = 30.27, y = 21.69, z = 482.1},
            {waypointX = 44.03, waypointY = 21.75, waypointZ = 482.86, x = 45.16, y = 21.64, z = 487.06}
        },
        collectiblesTurnInListIndex = 10,
        collectiblesTurnInScripId = 38
    },
    {
        fishName = "Goldgrouper",
        fishId = 43775,
        collectiblesTurnInScripId = 39
    }
}

ScripExchangeItem =
{
    scripExchangeMenu1=4,
    scripExchangeMenu2=8,
    scripExchangeRow=6,
    scripExchangePrice=1000
}

MinInventoryFreeSlots = 1
TimeoutThreshold                 = 10  --certain functions timeout and close if they don't work as intended due to some reason, after this period
FishingTimeoutThreshold          = 15  --how long to wait for current fishing attemp to be completed before trying to disable AH
MinWaitTime                     = 400 --(in seconds) set a carefully min wait before to switch fishing spot, (its anti pool limit movement wait time, setting value as 60 is what what i tested (i.e 1min)) how frequently you want to swap fishing spots to avoid fish being aware of your presence
MaxWaitTime                     = 900 --(in seconds) set a carefully max wait before to switch fishing spot

CharacterCondition = {
    mounted=4,
    gathering=6,
    casting=27,
    occupiedInEvent=31,
    occupiedInQuestEvent=32,
    occupied=33,
    boundByDutyDiadem=34,
    occupiedMateriaExtractionAndRepair=39,
    gathering42=42,
    fishing=43,
    betweenAreas=45,
    jumping48=48,
    occupiedSummoningBell=50,
    jumping61=61,
    betweenAreasForDuty=51,
    boundByDuty56=56,
    mounting57=57,
    mounting64=64,
    beingMoved=70,
    flying=77
}

--#region Fishing

function SelectNewFishingHole()
    local n = math.random(1, #SelectedFish.fishingSpots)
    SelectedFishingSpot = SelectedFish.fishingSpots[n]
    SelectedFishingSpot.startTime = os.clock()
end

function GoToFishingHole()
    if not IsInZone(SelectedFish.zoneId) then
        TeleportTo(SelectedFish.closestAetheryte.aetheryteName)
        return
    end

    if GetDistanceToPoint(SelectedFishingSpot.waypointX, SelectedFishingSpot.waypointY, SelectedFishingSpot.waypointZ) > 1 then
        if not GetCharacterCondition(CharacterCondition.mounted) then
            State = CharacterState.mounting
            LogInfo("State Change: Mounting")
        elseif not (PathfindInProgress() or PathIsRunning()) then
            PathfindAndMoveTo(SelectedFishingSpot.waypointX, SelectedFishingSpot.waypointY, SelectedFishingSpot.waypointZ, true)
        end
        yield("/wait 1")
        return
    end

    if GetCharacterCondition(CharacterCondition.mounted) then
        State = CharacterState.dismounting
        LogInfo("State Change: Dismount")
        return
    end

    State = CharacterState.fishing
    LogInfo("State Change: Fishing")
end

function Fishing()
    if GetInventoryFreeSlotCount() <= MinInventoryFreeSlots then
        if GetCharacterCondition(CharacterCondition.fishing) then
            yield("/ac Quit")
            yield("/wait 1")
            SelectNewFishingHole()
        else
            State = CharacterState.turnIn
            LogInfo("State Change: TurnIn")
        end
        return
    end

    if (SelectedFishingSpot.startTime + (SwitchLocationsAfter*60)) < os.clock() then
        if GetCharacterCondition(CharacterCondition.gathering) then
            if not GetCharacterCondition(CharacterCondition.fishing) then
                yield("/ac Quit")
                yield("/wait 1")
            end
        else
            SelectNewFishingHole()
            State = CharacterState.ready
            LogInfo("State Change: Ready")
        end
        return
    end

    if GetDistanceToPoint(SelectedFishingSpot.x, SelectedFishingSpot.y, SelectedFishingSpot.z) > 1 then
        if not PathfindInProgress() and not PathIsRunning() then
            PathfindAndMoveTo(SelectedFishingSpot.x, SelectedFishingSpot.y, SelectedFishingSpot.z)
        end
        return
    end

    if GetCharacterCondition(CharacterCondition.fishing) then
        if (PathfindInProgress() or PathIsRunning()) then
            yield("/vnav stop")
        end
        yield("/wait 1")
        return
    end

    yield("/bait "..SelectedFish.baitName)
    yield("/wait 0.1")
    yield("/ac Cast")
end

function BuyFishingBait()
    if GetItemCount(30279) >= 30 and GetItemCount(30280) >= 30 and GetItemCount(30281) >= 30 then
        if IsAddonVisible("Shop") then
            yield("/callback Shop true -1")
        else
            State = CharacterState.goToFishingHole
            LogInfo("State Change: MoveToNextNode")
        end
        return
    end

    if not HasTarget() or GetTargetName() ~= Mender.npcName then
        yield("/target "..Mender.npcName)
        yield("/wait 1")
        if not HasTarget() or GetTargetName() ~= Mender.npcName then
            LeaveDuty()
        end
        return
    end

    if GetDistanceToPoint(Mender.x, Mender.y, Mender.z) > 5 then
        if not PathfindInProgress() and not PathIsRunning() then
            PathfindAndMoveTo(Mender.x, Mender.y, Mender.z)
        end
        return
    end

    if PathfindInProgress() or PathIsRunning() then
        yield("/vnav stop")
        return
    end

    if IsAddonVisible("SelectIconString") then
        yield("/callback SelectIconString true 0")
    elseif IsAddonVisible("SelectYesno") then
        yield("/callback SelectYesno true 0")
    elseif IsAddonVisible("Shop") then
        if GetItemCount(30279) < 30 then
            yield("/callback Shop true 0 4 99 0")
        elseif GetItemCount(30280) < 30 then
            yield("/callback Shop true 0 5 99 0")
        elseif GetItemCount(30281) < 30 then
            yield("/callback Shop true 0 6 99 0")
        end
    else
        yield("/interact")
    end
end

--#endregion Fishing

--#region Movement
function GetClosestAetheryte(x, y, z, zoneId, teleportTimePenalty)
    local closestAetheryte = nil
    local closestTravelDistance = math.maxinteger
    local zoneAetherytes = GetAetherytesInZone(zoneId)
    for i=0, zoneAetherytes.Count-1 do
        local aetheryteId = zoneAetherytes[i]
        local aetheryteRawPos = GetAetheryteRawPos(aetheryteId)
        LogInfo(aetheryteRawPos)
        local distanceAetheryteToPoint = DistanceBetween(aetheryteRawPos.Item1, y, aetheryteRawPos.Item2, x, y, z)
        local comparisonDistance = distanceAetheryteToPoint + teleportTimePenalty
        local aetheryteName = GetAetheryteName(aetheryteId)
        LogInfo("[OrangeGatherer] Distance via "..aetheryteName.." adjusted for tp penalty is "..tostring(comparisonDistance))

        if comparisonDistance < closestTravelDistance then
            LogInfo("[OrangeGatherer] Updating closest aetheryte to "..aetheryteName)
            closestTravelDistance = comparisonDistance
            closestAetheryte = {
                aetheryteId = aetheryteId,
                aetheryteName = aetheryteName
            }
        end
    end

    return closestAetheryte
end

function TeleportTo(aetheryteName)
    yield("/tp "..aetheryteName)
    yield("/wait 1") -- wait for casting to begin
    while GetCharacterCondition(CharacterCondition.casting) do
        LogInfo("[FATE] Casting teleport...")
        yield("/wait 1")
    end
    yield("/wait 1") -- wait for that microsecond in between the cast finishing and the transition beginning
    while GetCharacterCondition(CharacterCondition.betweenAreas) do
        LogInfo("[FATE] Teleporting...")
        yield("/wait 1")
    end
    yield("/wait 1")
end

function Mount()
    if GetCharacterCondition(CharacterCondition.flying) then
        State = CharacterState.goToFishingHole
        LogInfo("[FATE] State Change: GoToFishingHole")
    elseif GetCharacterCondition(CharacterCondition.mounted) then
        yield("/gaction jump")
    else
        yield('/gaction "mount roulette"')
    end
    yield("/wait 1")
end

function Dismount()
    if PathIsRunning() or PathfindInProgress() then
        yield("/vnav stop")
        return
    end

    if GetCharacterCondition(CharacterCondition.flying) then
        yield("/e is flying")
        yield('/ac dismount')
    elseif GetCharacterCondition(CharacterCondition.mounted) then
        yield('/ac dismount')
    else
        State = CharacterState.fishing
        LogInfo("State Change: Fishing")
    end
    yield("/wait 1")
end

function GoToHubCity()
    if not IsPlayerAvailable() then
        yield("/wait 1")
    elseif not IsInZone(SelectedHubCity.zoneId) then
        TeleportTo(SelectedHubCity.aetheryte)
    else
        State = CharacterState.ready
        LogInfo("State Change: Ready")
    end
end

--#endregion Movement

--#region Collectables

function TurnIn()
    if GetItemCount(SelectedFish.fishId) == 0 then
        if IsAddonVisible("CollectablesShop") then
            yield("/callback CollectablesShop true -1")
        else
            State = CharacterState.ready
            LogInfo("[FishingGatherer] State Change: Ready")
        end
    elseif not IsInZone(SelectedHubCity.zoneId) then
        State = CharacterState.goToHubCity
        LogInfo("State Change: GoToHubCity")
    elseif SelectedHubCity.scripExchange.requiresAethernet and (not IsInZone(SelectedHubCity.aethernet.aethernetZoneId) or
        GetDistanceToPoint(SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z) > DistanceBetween(SelectedHubCity.aethernet.x, SelectedHubCity.aethernet.y, SelectedHubCity.aethernet.z, SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z) + 10) then
        if not LifestreamIsBusy() then
            yield("/li "..SelectedHubCity.aethernet.aethernetName)
        end
        yield("/wait 1")
    elseif IsAddonVisible("TelepotTown") then
        LogInfo("TelepotTown open")
        yield("/callback TelepotTown false -1")
    elseif GetDistanceToPoint(SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z) > 1 then
        if not (PathfindInProgress() or PathIsRunning()) then
            LogInfo("Path not running")
            PathfindAndMoveTo(SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z)
        end
    elseif GetItemCount(OrangeGathererScripId) >= 3800 then
        if IsAddonVisible("CollectablesShop") then
            yield("/callback CollectablesShop true -1")
        else
            State = CharacterState.scripExchange
            LogInfo("State Change: ScripExchange")
        end
    else
        if PathfindInProgress() or PathIsRunning() then
            yield("/vnav stop")
        end

        if not IsAddonVisible("CollectablesShop") then
            yield("/target Collectable Appraiser")
            yield("/wait 0.5")
            yield("/interact")
        else
            yield("/callback CollectablesShop true 12 "..SelectedFish.collectiblesTurnInListIndex)
            yield("/wait 0.1")
            yield("/callback CollectablesShop true 15 0")
            yield("/wait 1")
        end
    end
end

function ScripExchange()
    if GetItemCount(OrangeGathererScripId) < 3800 then
        if IsAddonVisible("InclusionShop") then
            yield("/callback InclusionShop true -1")
        elseif GetItemCount(SelectedFish.fishId) > 0 then
            State = CharacterState.turnIn
            LogInfo("State Change: TurnIn")
        else
            State = CharacterState.ready
            LogInfo("State Change: Ready")
        end
    elseif not IsInZone(SelectedHubCity.zoneId) then
        State = CharacterState.goToHubCity
        LogInfo("State Change: GoToHubCity")
    elseif not LogInfo("[FishingGatherer] /li aethernet") and SelectedHubCity.scripExchange.requiresAethernet and (not IsInZone(SelectedHubCity.aethernet.aethernetZoneId) or
        GetDistanceToPoint(SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z) > DistanceBetween(SelectedHubCity.aethernet.x, SelectedHubCity.aethernet.y, SelectedHubCity.aethernet.z, SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z) + 10) then
        if not LifestreamIsBusy() then
            yield("/li "..SelectedHubCity.aethernet.aethernetName)
        end
        yield("/wait 1")
    elseif not LogInfo("[FishingGatherer] close telepottown") and IsAddonVisible("TelepotTown") then
        LogInfo("TelepotTown open")
        yield("/callback TelepotTown false -1")
    elseif not LogInfo("[FishingGatherer] move to scrip exchange") and GetDistanceToPoint(SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z) > 1 then
        if not (PathfindInProgress() or PathIsRunning()) then
            LogInfo("Path not running")
            PathfindAndMoveTo(SelectedHubCity.scripExchange.x, SelectedHubCity.scripExchange.y, SelectedHubCity.scripExchange.z)
        end
    elseif IsAddonVisible("ShopExchangeItemDialog") then
        yield("/callback ShopExchangeItemDialog true 0")
        yield("/wait 1")
    elseif IsAddonVisible("SelectIconString") then
        yield("/callback SelectIconString true 0")
    elseif IsAddonVisible("InclusionShop") then
        yield("/callback InclusionShop true 12 "..ScripExchangeItem.scripExchangeMenu1)
        yield("/wait 1")
        yield("/callback InclusionShop true 13 "..ScripExchangeItem.scripExchangeMenu2)
        yield("/wait 1")
        yield("/callback InclusionShop true 14 "..ScripExchangeItem.scripExchangeRow.." "..GetItemCount(OrangeGathererScripId)//ScripExchangeItem.scripExchangePrice)
    else
        yield("/wait 1")
        yield("/target Scrip Exchange")
        yield("/wait 0.5")
        yield("/interact")
    end
end

--#endregion Collectables

-- #region Other Tasks
function ProcessRetainers()
    CurrentFate = nil
    
    LogInfo("[FishingGatherer] Handling retainers...")
    if not LogInfo("[FishingGatherer] check retainers ready") and not ARRetainersWaitingToBeProcessed() or GetInventoryFreeSlotCount() <= 1 then
        if IsAddonVisible("RetainerList") then
            yield("/callback RetainerList true -1")
        elseif not GetCharacterCondition(CharacterCondition.occupiedSummoningBell) then
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        end
    elseif not LogInfo("[FishingGatherer] is in hub city zone?") and
        not (IsInZone(SelectedHubCity.zoneId) or IsInZone(SelectedHubCity.aethernet.aethernetZoneId))
    then
        TeleportTo(SelectedHubCity.aetheryte)
    elseif not LogInfo("[FishingGatherer] use aethernet?") and
        SelectedHubCity.retainerBell.requiresAethernet and not LogInfo("abc") and (not IsInZone(SelectedHubCity.aethernet.aethernetZoneId) or
        (GetDistanceToPoint(SelectedHubCity.retainerBell.x, SelectedHubCity.retainerBell.y, SelectedHubCity.retainerBell.z) > (DistanceBetween(SelectedHubCity.aethernet.x, SelectedHubCity.aethernet.y, SelectedHubCity.aethernet.z, SelectedHubCity.retainerBell.x, SelectedHubCity.retainerBell.y, SelectedHubCity.retainerBell.z) + 10)))
    then
        if not LifestreamIsBusy() then
            yield("/li "..SelectedHubCity.aethernet.aethernetName)
        end
        yield("/wait 1")
    elseif not LogInfo("[FishingGatherer] close telepot town") and IsAddonVisible("TelepotTown") then
        LogInfo("TelepotTown open")
        yield("/callback TelepotTown false -1")
    elseif not LogInfo("[FishingGatherer] move to summoning bell") and GetDistanceToPoint(SelectedHubCity.retainerBell.x, SelectedHubCity.retainerBell.y, SelectedHubCity.retainerBell.z) > 1 then
        if not (PathfindInProgress() or PathIsRunning()) then
            LogInfo("Path not running")
            PathfindAndMoveTo(SelectedHubCity.retainerBell.x, SelectedHubCity.retainerBell.y, SelectedHubCity.retainerBell.z)
        end
    elseif PathfindInProgress() or PathIsRunning() then
        return
    elseif not HasTarget() or GetTargetName() ~= "Summoning Bell" then
        yield("/target Summoning Bell")
        return
    elseif not GetCharacterCondition(CharacterCondition.occupiedSummoningBell) then
        yield("/interact")
    elseif IsAddonVisible("RetainerList") then
        yield("/ays e")
        if Echo == "All" then
            yield("/echo [FATE] Processing retainers")
        end
        yield("/wait 1")
    end
end

function ExecuteGrandCompanyTurnIn()
    if GetInventoryFreeSlotCount() <= MinInventoryFreeSlots then
        local playerGC = GetPlayerGC()
        local gcZoneIds = {
            129, --Limsa Lominsa
            132, --New Gridania
            130 --"Ul'dah - Steps of Nald"
        }
        if not IsInZone(gcZoneIds[playerGC]) then
            yield("/li gc")
            yield("/wait 1")
        elseif DeliverooIsTurnInRunning() then
            return
        else
            yield("/deliveroo enable")
        end
    else
        State = CharacterState.ready
        LogInfo("State Change: Ready")
    end
end

function ExecuteRepair()
    if IsAddonVisible("SelectYesno") then
        yield("/callback SelectYesno true 0")
        return
    end

    if IsAddonVisible("Repair") then
        if not NeedsRepair(RepairAmount) then
            yield("/callback Repair true -1") -- if you don't need repair anymore, close the menu
        else
            yield("/callback Repair true 0") -- select repair
        end
        return
    end

    -- if occupied by repair, then just wait
    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) then
        LogInfo("[FATE] Repairing...")
        yield("/wait 1")
        return
    end

    local hawkersAlleyAethernetShard = { x=-213.95, y=15.99, z=49.35 }
    if SelfRepair then
        if GetItemCount(33916) > 0 then
            if IsAddonVisible("Shop") then
                yield("/callback Shop true -1")
                return
            end

            if not IsInZone(SelectedFish.zoneId) then
                TeleportTo(SelectedFish.aetheryteList[1].aetheryteName)
                return
            end

            if GetCharacterCondition(CharacterCondition.mounted) then
                Dismount()
                LogInfo("[FATE] State Change: Dismounting")
                return
            end

            if NeedsRepair(RepairAmount) then
                if not IsAddonVisible("Repair") then
                    LogInfo("[FATE] Opening repair menu...")
                    yield("/generalaction repair")
                end
            else
                State = CharacterState.ready
                LogInfo("[FATE] State Change: Ready")
            end
        elseif ShouldAutoBuyDarkMatter then
            if not IsInZone(129) then
                if Echo == "All" then
                    yield("/echo Out of Dark Matter! Purchasing more from Limsa Lominsa.")
                end
                TeleportTo("Limsa Lominsa Lower Decks")
                return
            end

            local darkMatterVendor = { npcName="Unsynrael", x=-257.71, y=16.19, z=50.11, wait=0.08 }
            if GetDistanceToPoint(darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z) > (DistanceBetween(hawkersAlleyAethernetShard.x, hawkersAlleyAethernetShard.y, hawkersAlleyAethernetShard.z,darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z) + 10) then
                yield("/li Hawkers' Alley")
                yield("/wait 1") -- give it a moment to register
            elseif IsAddonVisible("TelepotTown") then
                yield("/callback TelepotTown false -1")
            elseif GetDistanceToPoint(darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z) > 5 then
                if not (PathfindInProgress() or PathIsRunning()) then
                    PathfindAndMoveTo(darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z)
                end
            else
                if not HasTarget() or GetTargetName() ~= darkMatterVendor.npcName then
                    yield("/target "..darkMatterVendor.npcName)
                elseif not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent) then
                    yield("/interact")
                elseif IsAddonVisible("SelectYesno") then
                    yield("/callback SelectYesno true 0")
                elseif IsAddonVisible("Shop") then
                    yield("/callback Shop true 0 40 99")
                end
            end
        else
            if Echo == "All" then
                yield("/echo Out of Dark Matter and ShouldAutoBuyDarkMatter is false. Switching to Limsa mender.")
            end
            SelfRepair = false
        end
    else
        if NeedsRepair(RepairAmount) then
            if not IsInZone(129) then
                TeleportTo("Limsa Lominsa Lower Decks")
                return
            end
            
            local mender = { npcName="Alistair", x=-246.87, y=16.19, z=49.83 }
            if GetDistanceToPoint(mender.x, mender.y, mender.z) > (DistanceBetween(hawkersAlleyAethernetShard.x, hawkersAlleyAethernetShard.y, hawkersAlleyAethernetShard.z, mender.x, mender.y, mender.z) + 10) then
                yield("/li Hawkers' Alley")
                yield("/wait 1") -- give it a moment to register
            elseif IsAddonVisible("TelepotTown") then
                yield("/callback TelepotTown false -1")
            elseif GetDistanceToPoint(mender.x, mender.y, mender.z) > 5 then
                if not (PathfindInProgress() or PathIsRunning()) then
                    PathfindAndMoveTo(mender.x, mender.y, mender.z)
                end
            else
                if not HasTarget() or GetTargetName() ~= mender.npcName then
                    yield("/target "..mender.npcName)
                elseif not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent) then
                    yield("/interact")
                end
            end
        else
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        end
    end
end

function ExecuteExtractMateria()
    if GetCharacterCondition(CharacterCondition.mounted) then
        Dismount()
        LogInfo("[FATE] State Change: Dismounting")
        return
    end

    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) then
        return
    end

    if CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        if not IsAddonVisible("Materialize") then
            yield("/generalaction \"Materia Extraction\"")
            return
        end

        LogInfo("[FATE] Extracting materia...")
            
        if IsAddonVisible("MaterializeDialog") then
            yield("/callback MaterializeDialog true 0")
        else
            yield("/callback Materialize true 2 0")
        end
    else
        if IsAddonVisible("Materialize") then
            yield("/callback Materialize true -1")
        else
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        end
    end
end

function FoodCheck()
    --food usage
    if not HasStatusId(48) and Food ~= "" then
        yield("/item " .. Food)
    end
end

function PotionCheck()
    --pot usage
    if not HasStatusId(49) and Potion ~= "" then
        yield("/item " .. Potion)
    end
end

-- #endregion

function SelectFishTable()
    for _, fishTable in ipairs(FishTable) do
        if FishToFarm == fishTable.fishName then
            return fishTable
        end
    end
end

function Ready()
    FoodCheck()
    PotionCheck()

    if not LogInfo("[FishingGatherer] Ready -> IsPlayerAvailable()") and not IsPlayerAvailable() then
        -- do nothing
    elseif not LogInfo("[FishingGatherer] Ready -> Repair") and RepairAmount > 0 and NeedsRepair(RepairAmount) and
        (not shouldWaitForBonusBuff or (SelfRepair and GetItemCount(33916) > 0)) then
        State = CharacterState.repair
        LogInfo("[FishingGatherer] State Change: Repair")
    elseif not LogInfo("[FishingGatherer] Ready -> ExtractMateria") and ExtractMateria and CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        State = CharacterState.extractMateria
        LogInfo("[FishingGatherer] State Change: ExtractMateria")
    elseif not LogInfo("[FishingGatherer] Ready -> ProcessRetainers") and
        Retainers and ARRetainersWaitingToBeProcessed() and GetInventoryFreeSlotCount() > 1
    then
        State = CharacterState.processRetainers
        LogInfo("[FishingGatherer] State Change: ProcessingRetainers")
    elseif GetInventoryFreeSlotCount() <= MinInventoryFreeSlots and GetItemCount(SelectedFish.fishId) > 0 then
        State = CharacterState.turnIn
        LogInfo("State Change: TurnIn")
    elseif not LogInfo("[FishingGatherer] Ready -> GC TurnIn") and GrandCompanyTurnIn and
        GetInventoryFreeSlotCount() < MinInventoryFreeSlots
    then
        State = CharacterState.gcTurnIn
        LogInfo("[FishingGatherer] State Change: GCTurnIn")
    elseif GetInventoryFreeSlotCount() <= MinInventoryFreeSlots and GetItemCount(SelectedFish.fishId) > 0 then
        State = CharacterState.goToHubCity
        LogInfo("[FishingGatherer] State Change: GoToSolutionNine")
    else
        State = CharacterState.goToFishingHole
        LogInfo("State Change: MoveToWaypoint")
    end
end

CharacterState = {
    ready = Ready,
    mounting = Mount,
    dismounting = Dismount,
    goToFishingHole = GoToFishingHole,
    extractMateria = ExecuteExtractMateria,
    repair = ExecuteRepair,
    exchangingVouchers = ExchangeVouchers,
    processRetainers = ProcessRetainers,
    gcTurnIn = ExecuteGrandCompanyTurnIn,
    fishing = Fishing,
    turnIn = TurnIn,
    scripExchange = ScripExchange,
    goToHubCity = GoToHubCity
}

StopMain = false
LastStuckCheckTime = os.clock()
LastStuckCheckPosition = {x=GetPlayerRawXPos(), y=GetPlayerRawYPos(), z=GetPlayerRawZPos()}

SelectedFish = SelectFishTable()
if SelectedFish == nil then
    yield("/echo Cannot find data for "..FishToFarm)
    StopMain = true
end
SelectedFish.closestAetheryte = GetClosestAetheryte(
            SelectedFish.fishingSpots[1].x,
            SelectedFish.fishingSpots[1].y,
            SelectedFish.fishingSpots[1].z,
            SelectedFish.zoneId,
            0)
yield("/ahon")
DeleteAllAutoHookAnonymousPresets()
UseAutoHookAnonymousPreset(SelectedFish.autohookPreset)

for _, city in ipairs(HubCities) do
    if city.zoneName == HubCity then
        SelectedHubCity = city
        SelectedHubCity.aetheryte = GetAetheryteName(GetAetherytesInZone(city.zoneId)[0])
    end
end
if SelectedHubCity == nil then
    yield("/echo Could not find hub city: "..HubCity)
    yield("/vnav stop")
end

if GetClassJobId() ~= 18 then
    yield("/gs change Fisher")
    yield("/wait 1")
end

SelectNewFishingHole()
State = CharacterState.ready
while not StopMain do
    State()
    yield("/wait 0.1")
end
