local QBCore = exports['qb-core']:GetCoreObject()
local CurrentZone

CreateThread(function()
    for k, location in pairs(Config.Locations) do
        local Zone = CircleZone:Create(location.pos, location.radius, {
            name = k,
        })

        Zone:onPlayerInOut(function(inZone)
            if inZone then
                CurrentZone = k
            else
                CurrentZone = nil
            end
        end)
    end
end)

CreateThread(function()
    for k, location in pairs(Config.Locations) do
        AddTextEntry("PROSP_BLIP", "Prospecting Hotspot")
        blip = AddBlipForCoord(location.pos)
        SetBlipSprite(blip, 485)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("PROSP_BLIP")
        EndTextCommandSetBlipName(blip)
        SetBlipColour(blip, 32)
        SetBlipScale(blip, 0.6)

        area_blip = AddBlipForRadius(location.pos, area_size)
        SetBlipColour(area_blip, 32)
        SetBlipAlpha(area_blip, 80)
    end
end)

RegisterNetEvent('prospecting:client:useDetector', function()
    if CurrentZone then
        TriggerServerEvent('prospecting:server:start', CurrentZone)
    else
        QBCore.Functions.Notify("You cannot metal detect in this area.")
    end
end)