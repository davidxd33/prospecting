local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("metaldetector", function(source, item)
    TriggerClientEvent('prospecting:client:useDetector', source)
end)

-- Choose a random item from the item_pool list
function GetNewRandomItem()
    local item = Config.Items[math.random(#Config.Items)]
    return {item = item.item, treasure = item.treasure, qty = item.qty}
end

-- Make a random location within the area
function GetNewRandomLocation(location)
    local area_size = location.radius

    local offsetX = math.random(-area_size, area_size)
    local offsetY = math.random(-area_size, area_size)
    local pos = vector3(offsetX, offsetY, 0.0)
    if #(pos) > area_size then
        -- It's not within the circle, generate a new one instead
        return GetNewRandomLocation(location)
    end
    return location.pos + pos
end

-- Generate a new target location
function GenerateNewTarget(location)
    local newPos = GetNewRandomLocation(location)
    local newData = GetNewRandomItem()
    Prospecting.AddTarget(newPos.x, newPos.y, newPos.z, newData)
end

RegisterNetEvent('prospecting:server:start', function(location)
    if Config.Locations[location] then
        -- The player collected something
        Prospecting.SetHandler(function(src, data, x, y, z)
            local Player = QBCore.Functions.GetPlayer(src)

            if data.treasure then
                if math.random(1,100) <= 35 then
                    if Player.Functions.AddItem(data.item, data.qty or 1) then
                        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[data.item], "add", data.qty or 1)
                    else
                        TriggerClientEvent("QBCore:Notify", src, "You see something in the ground but your pockets are too full.")
                    end
                else
                    TriggerClientEvent("QBCore:Notify", src, "Looks like a false alarm.")
                end
            else
                if Player.Functions.AddItem(data.item, data.qty or 1) then
                    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[data.item], "add", data.qty or 1)
                else
                    TriggerClientEvent("QBCore:Notify", src, "You see something in the ground but your pockets are too full.")
                end
            end

            GenerateNewTarget(Config.Locations[location])
        end)
        
        Prospecting.AddTargets(Config.Locations[location].spots)

        for n = 0, 5 do
            GenerateNewTarget(Config.Locations[location])
        end

        Prospecting.StartProspecting(source)
    else
        print('Could not find ' .. location)
    end
end)

CreateThread(function()
    Prospecting.SetDifficulty(1.0)

    Prospecting.OnStart(function(player)
        TriggerClientEvent("chatMessage", player, "Started prospecting")
    end)

    Prospecting.OnStop(function(player, time)
        TriggerClientEvent("chatMessage", player, "Stopped prospecting")
    end)
end)
