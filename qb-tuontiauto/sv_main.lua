
local coldown = 1 --minuutteina

local cooldown = 0
local aktiivinen = 0
local QBCore = exports['qb-core']:GetCoreObject()




local pedit = {
    [1] = {
        pos = { x = -337.11, y = -2442.16, z = 6.0 },
--        pedmodel = "g_m_y_famca_01",
        heading = 297.26,
        luotu = false,
        npcanimaatio = 'anim@heists@prison_heistig_2_p1_exit_bus',
        npcanimaatio2 = 'loop_a_guard_a'
    }
}

RegisterServerEvent('karpo_tuontiauto:myyauto')
AddEventHandler('karpo_tuontiauto:myyauto', function(hinta)
	local Player = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.AddMoney('money', hinta)
end)


QBCore.Functions.CreateCallback('karpo_tuontiauto:boliseja',function(source, cb)
    local bolis = 0
    local xPlayers = QBCore.Functions.GetPlayers()
    for i=1, #xPlayers, 1 do
      local _source = xPlayers[i]
      local Player = QBCore.Functions.GetPlayer(_source)
	  if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        bolis = bolis + 1
      end
    end
    cb(bolis,cooldown,aktiivinen)
end)


RegisterServerEvent('karpo_tuontiauto:aktiivinen')
AddEventHandler('karpo_tuontiauto:aktiivinen', function(lol)
    if lol == 1 then
        cooldown = coldown*1000*60
    end
    aktiivinen = lol
end)

RegisterServerEvent('karpo_tuontiauto:poliisiblip')
AddEventHandler('karpo_tuontiauto:poliisiblip', function(x,y,z)
	local source = source
	local Player = QBCore.Functions.GetPlayer(source)
	local xPlayers = QBCore.Functions.GetPlayers()

	for i=1, #xPlayers, 1 do
		local Player = QBCore.Functions.GetPlayer(xPlayers[i])
		if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
			TriggerClientEvent('karpo_tuontiauto:blipclient', xPlayers[i], x,y,z)
		end
	end
end)


RegisterServerEvent('karpo_tuontiauto:ilmotus')
AddEventHandler('karpo_tuontiauto:ilmotus', function(lolz)
	local source = source
	local Player = QBCore.Functions.GetPlayer(source)
	local xPlayers = QBCore.Functions.GetPlayers()

	for i=1, #xPlayers, 1 do
		local Player = QBCore.Functions.GetPlayer(xPlayers[i])
		if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
			TriggerClientEvent('karpo_tuontiauto:ilmotus', xPlayers[i], lolz)
		end
	end
end)


RegisterServerEvent('karpo_tuontiauto:loppupoliisi')
AddEventHandler('karpo_tuontiauto:loppupoliisi', function()
	local source = source
	local Player = QBCore.Functions.GetPlayer(source)
	local xPlayers = QBCore.Functions.GetPlayers()

	for i=1, #xPlayers, 1 do
		local Player = QBCore.Functions.GetPlayer(xPlayers[i])
		if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
			TriggerClientEvent('karpo_tuontiauto:poisblip', xPlayers[i])
		end
	end
end)


RegisterNetEvent('karpo_tuontiauto:serverista')
AddEventHandler('karpo_tuontiauto:serverista', function()
    local _source = source
    TriggerClientEvent('karpo_tuontiauto:clienttiin', _source, pedit)
end)


AddEventHandler('onResourceStart', function(resource) --yoinkattu jostain toisest carthiefist
	while true do
		Wait(5000) 
		if cooldown > 0 then
			cooldown = cooldown - 5000
		end
	end
end)