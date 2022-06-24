local QBCore = exports['qb-core']:GetCoreObject()


local boliiseja = 1 --paljo kyttii alotuksee
local blipaika = 5 --sekunteina kuin usein auton blippi päivittyy poliiseille
local tiirikointiaika = 25 --sekunteina kuinka kauan tiirikointi kestää.

local spawnattu = false
local alotettu = false
local autossa = false
local myymassa = false
local myyty = false
local kilpi = ""
local perse = {}
local blip
local car
local hakumestat = {
    [1] = {coords=vector3(1267.73, -2561.55, 42.86), auto="bullet", aika = 300, heading = 282.0}, --tähän cordinaatteja :pog:
    [2] = {coords=vector3(246.93, -1968.27, 21.96), auto="sultanrs", aika = 300, heading = 235.0}, --tähän cordinaatteja :pog:
    [3] = {coords=vector3(471.11, -902.31, 35.28), auto="sultan2", aika = 300, heading = 244.0}, --tähän cordinaatteja :pog:
    [4] = {coords=vector3(-477.44, -741.27, 29.87), auto="dominator3", aika = 300, heading = 89.68}, --tähän cordinaatteja :pog:
    [5] = {coords=vector3(-1172.77, -1176.41, 5.1), auto="drafter", aika = 300, heading = 194.08}, --tähän cordinaatteja :pog:
    [6] = {coords=vector3(-1042.41, -858.44, 4.2), auto="elegy2", aika = 300, heading = 238.41}, --tähän cordinaatteja :pog:
    [7] = {coords=vector3(1226.51, -1513.17, 34.05), auto="flashgt", aika = 300, heading = 179.24}, --tähän cordinaatteja :pog:
    [8] = {coords=vector3(1101.26, -1503.81, 34.05), auto="gb200", aika = 300, heading = 89.89}, --tähän cordinaatteja :pog:
    [9] = {coords=vector3(892.87, -886.86, 26.37), auto="jugular", aika = 300, heading = 88.83}, --tähän cordinaatteja :pog:
    [10] = {coords=vector3(892.87, -891.52, 26.37), auto="ninef2", aika = 300, heading = 88.83}, --tähän cordinaatteja :pog:
}
    

local myyntimestat = {
    [1] = {coords=vector3(-1271.65, -1428.06, 4.34), hinta = math.random(1000, 2000)}, -- ranta
    [2] = {coords=vector3(-476.43, 269.97, 83.19), hinta = math.random(2000, 2500)}, -- ruletti
    [3] = {coords=vector3(-496.97, 751.43, 162.19), hinta = math.random(2000, 2500)}, -- yl�kaupunki
    [4] = {coords=vector3(934.58, -1.48, 78.12), hinta = math.random(1000, 1500)}, -- casino
    [5] = {coords=vector3(27.12, 3732.11, 39.03), hinta = math.random(2000, 3500)}, -- keskimaan losti
    [6] = {coords=vector3(1345.7, 4371.53, 44.34), hinta = math.random(3000, 4000)}, -- Keskimaa ala mosea 
    [7] = {coords=vector3(2878.74, 4488.04, 47.76), hinta = math.random(2000, 3500)}, -- Matotehdas
    [8] = {coords=vector3(1694.33, 6428.09, 32.17), hinta = math.random(4500, 5500)}, -- pohjosen kauppa
    [9] = {coords=vector3(-244.43, 6237.93, 31.03), hinta = math.random(4500, 5500)}, -- Pohjosen parturi
    [10] = {coords=vector3(-2416.05, 3328.46, 32.37), hinta = math.random(4500, 5500)}, -- Armeija
}
CreateThread(function()
    juttu1 = nil if juttu1 == nil then
        Wait(10)
    end
    TriggerServerEvent('karpo_tuontiauto:serverista')
    Wait(15000)
    while true do
        Wait(2)
        for i=1, #perse do
           local coords = GetEntityCoords(PlayerPedId())
           local lol = perse[i].pos
           if not perse[i].luotu then
                if Vdist(coords.x, coords.y, coords.z, lol.x, lol.y, lol.z) < 150.0 then
                    RequestAnimDict(perse[i].npcanimaatio)
                        while not HasAnimDictLoaded(perse[i].npcanimaatio) do
                            Citizen.Wait(1)
                        end
                    Wait(100)	
                    local pedi = CreatePed(4, GetHashKey(perse[i].pedmodel), lol.x, lol.y, lol.z, perse[i].heading, false, true)
                    SetPedCanRagdollFromPlayerImpact(pedi, false)
                    SetPedCanEvasiveDive(pedi, false)
                    SetPedCanBeTargetted(pedi, false)
                    SetEntityInvincible(pedi, true)
                    SetBlockingOfNonTemporaryEvents(pedi, true)
                    TaskPlayAnim(pedi,perse[i].npcanimaatio,perse[i].npcanimaatio2,1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
                    perse[i].luotu = true
                end
            end
            if Vdist(coords.x, coords.y, coords.z, lol.x, lol.y, lol.z) < 1.0 then
                if not alotettu then
                    teksti(lol, tostring("~g~E ~w~- juttele!"))
                    if IsControlJustReleased(0, 38) then
                        menu()
                    end
                else
                    if not myyty then
                        teksti(lol, tostring("~w~Hae ~r~ajoneuvo ~w~- !"))
                    end
                end
            end  
        end
    end
end)


function menu(x,y,z)
            QBCore.Functions.TriggerCallback('karpo_tuontiauto:boliseja', function(bolis,cooldown,aktiivinen)
                if bolis >= boliiseja then
                    if cooldown <= 0 then
                        if aktiivinen == 0 then
                            alota()
                        else
                            QBCore.Functions.Notify("Joku vetää jo tuontiautoa.", 'error')
                        end
                    else
                        QBCore.Functions.Notify("Cooldown menossa! Odota "..cooldown, 'error')
                    end
                else
                    QBCore.Functions.Notify("Ei tarpeeksi poliiseja", 'error')
                end
            end)

end

function alota()
    alotettu = true
    TriggerServerEvent('karpo_tuontiauto:aktiivinen', 1)
    local mistautorandom = math.random(1,#hakumestat) --hakee random mestan ylemmästä paskasta
    timeri(mistautorandom)
    mistauto = hakumestat[mistautorandom]
    --random blip shittii
    hakublip = AddBlipForCoord(mistauto.coords)
    SetBlipSprite (hakublip, 326)
    SetBlipColour (hakublip, 57)
    SetBlipAsShortRange(hakublip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Hakupiste')
    EndTextCommandSetBlipName(hakublip)
    SetBlipFlashes(hakublip, true)
    SetNewWaypoint(mistauto.coords)
    --auton spawni
    local x,y,z = table.unpack(mistauto.coords)
    local x2,y2,z2 = table.unpack(GetEntityCoords(PlayerPedId()))
    CreateThread(function()
        while true do
            Wait(2)
            local coords22 = GetEntityCoords(PlayerPedId())
            if alotettu then
                if not spawnattu then
                    if Vdist(coords22.x, coords22.y, coords22.z, mistauto.coords) < 150.0 then --spawnataa vastku lähel, ettei despawnaa
                        kaara = hakumestat[mistautorandom].auto
                        local hash = GetHashKey(kaara)
                        RequestModel(hash)
                        while not HasModelLoaded(hash) do
                            RequestModel(hash)
                            Citizen.Wait(1)
                        end
                        car = CreateVehicle(hash, mistauto.coords, 230.83, true, false)
                        SetVehicleDoorsLocked(car, 2)
                        kilpi = 'AUTO' .. math.random(100, 999)
                        SetVehicleNumberPlateText(car, kilpi)
                        local h = hakumestat[mistautorandom].heading
                        SetEntityHeading(car, h)
                        spawnattu = true
                    else
                        Wait(5000) --vähä optimoidaa 
                    end
                end
            end
            if Vdist(coords22.x, coords22.y, coords22.z, mistauto.coords) < 3.0 then
                if not tiirikoi and alotettu and not autossa then
                teksti(mistauto.coords, tostring("~r~E ~w~- tiirikoi!"))
                    if IsControlJustReleased(0, 38) then
                        if not tiirikoi then --kunnon spaghetti koodia vittu
                            tiirikoi = true
                            TriggerServerEvent('karpo_tuontiauto:ilmotus', 1)
                            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 500)
                            Wait(tiirikointiaika*1000)
                            SetVehicleDoorsLocked(car, 1)
                            tiirikoi = false
                            autossa = true
                            ClearPedTasks(PlayerPedId())
                            RemoveBlip(hakublip)
                            local myyntipaikka = math.random(1,#myyntimestat)
                            local paikka = myyntimestat[myyntipaikka]
                            local maksa = myyntimestat[myyntipaikka].hinta
                            myyntiblip = AddBlipForCoord(paikka.coords)
                            SetBlipSprite (myyntiblip, 500)
                            SetBlipColour (myyntiblip, 57)
                            SetBlipAsShortRange(myyntiblip, true)
                            BeginTextCommandSetBlipName('STRING')
                            AddTextComponentSubstringPlayerName('Myyntipiste')
                            EndTextCommandSetBlipName(myyntiblip)
                            SetNewWaypoint(paikka.coords)
                            QBCore.Functions.Notify("Myy ajoneuvo GPS sijaintiin", 'success')
                            myymassa = true
                            CreateThread(function()
                                while true do
                                    Wait(4)
                                    local homo = GetEntityCoords(PlayerPedId())
                                    if Vdist(homo.x, homo.y, homo.z, paikka.coords) < 3.0 then
                                        if not myyty then
                                            if IsPedInAnyVehicle(PlayerPedId()) then
                                                teksti(paikka.coords, tostring("~g~E ~w~myy ajoneuvo!"))
                                                local munauto = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                local rekkari = GetVehicleNumberPlateText(munauto)
                                                if IsControlJustReleased(0, 38) then
                                                    if GetVehiclePedIsIn(PlayerPedId(), false) == car then
                                                        TriggerServerEvent('karpo_tuontiauto:myyauto', maksa)
                                                        TriggerServerEvent('karpo_tuontiauto:ilmotus', 3)
                                                        TriggerServerEvent('karpo_tuontiauto:aktiivinen', 0)
                                                        QBCore.Functions.Notify("Ajoneuvo myyty tienasit: $" ..maksa, 'success')
                                                        RemoveBlip(myyntiblip)
                                                        local lol = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                                        SetVehicleDoorsLocked(lol, 4)
                                                        TaskLeaveVehicle(GetPlayerPed(-1), lol, 0)
                                                        myyty = true
                                                        alotettu = false

                                                        Wait(10000)
                                                        TriggerServerEvent('karpo_tuontiauto:loppupoliisi')
                                                        Wait(600000)
                                                        DeleteEntity(car)
                                                    else
                                                        QBCore.Functions.Notify("Eihän tää ole edes oikea auto??", 'error')

                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                else
                    if not autossa then
                        teksti(mistauto.coords, tostring("~w~Tiirikoidaan ~r~- !"))
                    end
                end
            end 
        end
    end)
end


function timeri(perse)
    local aika22 = hakumestat[perse].aika
    CreateThread(function()
        while aika22 > 0 do
            Wait(1000)
            if aika22 > 0 then
                aika22 = aika22 - 1
            end
        end
	end)
    CreateThread(function()
        while true do
            Wait(2)
            if not autossa and alotettu then
                teksti(GetEntityCoords(PlayerPedId()), '~w~Aika [~g~'..aika22..'~w~]')
            end
            if not autossa and alotettu then
                if IsPedDeadOrDying(PlayerPedId()) then
                    alotettu = false
                    autossa = false
                    TriggerServerEvent('karpo_tuontiauto:aktiivinen', 0)
                    RemoveBlip(hakublip)
                    QBCore.Functions.Notify("Varkaus epäonnistui", 'error')
                end
            end
            if aika22 <= 0 and not autossa and alotettu then
                alotettu = false
                QBCore.Functions.Notify("Aika loppui", 'error')
                TriggerServerEvent('karpo_tuontiauto:aktiivinen', 0)
            end
        end
    end)
    CreateThread(function()
        while true do
            Wait(blipaika*1000)
            if autossa and alotettu then
                local munauto = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                local rekkari = GetVehicleNumberPlateText(munauto)
                if GetVehiclePedIsIn(PlayerPedId(), false) == car then
                    local coords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent('karpo_tuontiauto:poliisiblip', coords.x, coords.y, coords.z)
                end
            end
        end
    end)
end


RegisterNetEvent('karpo_tuontiauto:clienttiin')
AddEventHandler('karpo_tuontiauto:clienttiin', function(infot)
    perse = infot
end)

RegisterNetEvent('karpo_tuontiauto:ilmotus')
AddEventHandler('karpo_tuontiauto:ilmotus', function(lolz)
    PlaySound(-1, "Hang_Up", "Phone_SoundSet_Michael", 0, 0, 1)
    if lolz == 1 then
        QBCore.Functions.Notify("Tuontiauto, Hälytys laukaistu!", 'primary')
    elseif lolz == 2 then
        RemoveBlip(blip)
        QBCore.Functions.Notify("Tuontiauto, Peruuntui", 'primary')
    elseif lolz == 3 then
        RemoveBlip(blip)
        QBCore.Functions.Notify("Tuontiauto, Onnistui!", 'primary')
    end
end)

RegisterNetEvent('karpo_tuontiauto:blipclient')
AddEventHandler('karpo_tuontiauto:blipclient', function(x,y,z)
	RemoveBlip(blip)
    blip = AddBlipForCoord(x,y,z)
    SetBlipSprite(blip , 326)
    SetBlipScale(blip , 1.0)
	SetBlipColour(blip, 8)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Tuontiauto')
    EndTextCommandSetBlipName(blip)
    SetBlipFlashes(blip, true)
end)

RegisterNetEvent('karpo_tuontiauto:poisblip')
AddEventHandler('karpo_tuontiauto:poisblip', function()
	RemoveBlip(blip)
end)


function teksti(cordinaatit, teksti)
	local onScreen, x, y = World3dToScreen2d(cordinaatit.x, cordinaatit.y, cordinaatit.z+0.20)
	SetTextScale(0.41, 0.41)
	SetTextOutline()
	SetTextDropShadow()
	SetTextDropshadow(2, 0, 0, 0, 255)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	AddTextComponentString(teksti)
	DrawText(x, y)
    local factor = (string.len(teksti)) / 400
        DrawRect(x, y+0.012, 0.015+ factor, 0.03, 0, 0, 0, 68)
end
