--[[ ===================================================== ]]--
--[[         FiveM Real Parking Script by Akkariin         ]]--
--[[ ===================================================== ]]--

ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
	ESX = response
end)

-- When the client request to refresh the vehicles

RegisterServerEvent('esx_realparking:refreshVehicles')
AddEventHandler('esx_realparking:refreshVehicles', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	RefreshVehicles(xPlayer, source)
end)

-- Save the car to database

ESX.RegisterServerCallback("esx_realparking:saveCar", function(source, cb, vehicleData)
	local xPlayer = ESX.GetPlayerFromId(source)
    local plate   = vehicleData.props.plate
	local isFound = false
	FindPlayerVehicles(xPlayer.identifier, function(vehicles)
		for k, v in pairs(vehicles) do
			if type(v.plate) ~= 'nil' and string.trim(plate) == string.trim(v.plate) then
				isFound = true
			end		
		end
		if GetVehicleNumOfParking(vehicleData.parking) > Config.ParkingLocations[vehicleData.parking].maxcar then
			cb({
				status  = false,
				message = Config.Locales["parking_full"],
			})
		elseif isFound then
			MySQL.Async.fetchAll("SELECT * FROM car_parking WHERE owner = @identifier AND plate = @plate", {
				['@identifier'] = xPlayer.identifier,
				['@plate']      = plate
			}, function(rs)
				if type(rs) == 'table' and #rs > 0 then
					cb({
						status  = false,
						message = Config.Locales["already_parking"],
					})
				else
					MySQL.Async.execute("INSERT INTO car_parking (owner, plate, data, time, parking) VALUES (@owner, @plate, @data, @time, @parking)", {
							["@owner"]   = xPlayer.identifier,
							["@plate"]   = plate,
							["@data"]    = json.encode(vehicleData),
							["@time"]    = os.time(),
							["@parking"] = vehicleData.parking
						}
					)
					MySQL.Async.execute('UPDATE owned_vehicles SET stored = 2 WHERE plate = @plate AND owner = @identifier', {
						["@plate"]      = plate,
						["@identifier"] = xPlayer.identifier
					})
					cb({
						status  = true,
						message = Config.Locales["car_saved"],
					})
					Wait(100)
					TriggerClientEvent("esx_realparking:addVehicle", -1, {vehicle = vehicleData, plate = plate, fee = 0.0, owner = xPlayer.identifier, name = xPlayer.getName()})
				end
			end)
		else
			cb({
				status  = false,
				message = Config.Locales["not_your_car"],
			})
		end
	end)
end)

-- When player request to drive the car

ESX.RegisterServerCallback("esx_realparking:driveCar", function(source, cb, vehicleData)
	local xPlayer = ESX.GetPlayerFromId(source)
    local plate   = vehicleData.plate
	local isFound = false
	FindPlayerVehicles(xPlayer.identifier, function(vehicles)
		for k, v in pairs(vehicles) do
			if type(v.plate) ~= 'nil' and string.trim(plate) == string.trim(v.plate) then
				isFound = true
			end		
		end
		if isFound then
			MySQL.Async.fetchAll("SELECT * FROM car_parking WHERE owner = @identifier AND plate = @plate", {
				['@identifier'] = xPlayer.identifier,
				['@plate']      = plate
			}, function(rs)
				if type(rs) == 'table' and #rs > 0 and rs[1] ~= nil then
					local fee         = math.floor(((os.time() - rs[1].time) / 86400) * Config.ParkingLocations[rs[1].parking].fee)
					local playerMoney = xPlayer.getMoney()
					local parkingCard = xPlayer.getInventoryItem('parkingcard').count
					if parkingCard > 0 then
						fee = 0
					end
					if playerMoney >= fee then
						xPlayer.removeMoney(fee)
						MySQL.Async.execute('DELETE FROM car_parking WHERE plate = @plate AND owner = @identifier', {
							["@plate"]      = plate,
							["@identifier"] = xPlayer.identifier
						})
						MySQL.Async.execute('UPDATE owned_vehicles SET stored = 0 WHERE plate = @plate AND owner = @identifier', {
							["@plate"]      = plate,
							["@identifier"] = xPlayer.identifier
						})
						cb({
							status  = true,
							message = string.format(Config.Locales["pay_success"], fee),
							vehData = json.decode(rs[1].data),
						})
						TriggerClientEvent("esx_realparking:deleteVehicle", -1, {
							plate = plate
						})
					else
						cb({
							status  = false,
							message = Config.Locales["not_enough_money"],
						})
					end
				else
					cb({
						status  = false,
						message = Config.Locales["invalid_car"],
					})
				end
			end)
		else
			cb({
				status  = false,
				message = Config.Locales["not_your_car"],
			})
		end
	end)
end)

-- When the police impound the car, support for esx_policejob

ESX.RegisterServerCallback("esx_realparking:impoundVehicle", function(source, cb, vehicleData)
	local xPlayer = ESX.GetPlayerFromId(source)
    local plate   = vehicleData.plate
	MySQL.Async.fetchAll("SELECT * FROM car_parking WHERE plate = @plate", {
		['@plate']      = plate
	}, function(rs)
		if type(rs) == 'table' and #rs > 0 and rs[1] ~= nil then
			print("Police impound the vehicle: ", vehicleData.plate, rs[1].owner)
			MySQL.Async.execute('DELETE FROM car_parking WHERE plate = @plate AND owner = @identifier', {
				["@plate"]      = plate,
				["@identifier"] = rs[1].owner
			})
			MySQL.Async.execute('UPDATE owned_vehicles SET stored = 0 WHERE plate = @plate AND owner = @identifier', {
				["@plate"]      = plate,
				["@identifier"] = rs[1].owner
			})
			cb({
				status  = true,
			})
			TriggerClientEvent("esx_realparking:deleteVehicle", -1, {
				plate = plate
			})
		else
			cb({
				status  = false,
				message = Config.Locales["invalid_car"],
			})
		end
	end)
end)

-- Send the identifier to client

ESX.RegisterServerCallback("esx_realparking:getPlayerIdentifier", function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local playerId = xPlayer.identifier
	if type(playerId) ~= 'nil' then
		cb(playerId)
	else
		print("[RealParking][ERROR] Failed to get the player identifier!")
	end
end)

-- Refresh client local vehicles entity

function RefreshVehicles(xPlayer, src)
	if src == nil then
		src = -1
	end
	local vehicles = {}
	local nameList = {}
	if Config.UsingOldESX then
		local nrs = MySQL.Sync.fetchAll("SELECT identifier, name FROM users")
		if type(nrs) == 'table' then
			for k, v in pairs(nrs) do
				nameList[v.identifier] = v.name
			end
		end
	else
		local nrs = MySQL.Sync.fetchAll("SELECT identifier, firstname, lastname FROM users")
		if type(nrs) == 'table' then
			for k, v in pairs(nrs) do
				nameList[v.identifier] = v.firstname .. " " .. v.lastname
			end
		end
	end
	MySQL.Async.fetchAll("SELECT * FROM car_parking", {}, function(rs) 
		for k, v in pairs(rs) do
			local vehicle = json.decode(v.data)
			local plate   = v.plate
			local fee     = math.floor(((os.time() - v.time) / 86400) * Config.ParkingLocations[v.parking].fee)
			if fee < 0 then
				fee = 0
			end
			table.insert(vehicles, {vehicle = vehicle, plate = plate, fee = fee, owner = v.owner, name = nameList[v.owner]})
		end
		TriggerClientEvent("esx_realparking:refreshVehicles", src, vehicles)
	end)
end

-- Get the number of the vehicles

function GetVehicleNumOfParking(name)
	local rs = MySQL.Sync.fetchAll('SELECT id FROM car_parking WHERE parking = @parking', {['@parking'] = name})
	if type(rs) == 'table' then
		return #rs
	else
		return 0
	end
end

-- Get all vehicles the player owned

function FindPlayerVehicles(id, cb)
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier", {['@identifier'] = id}, function(rs)
		for k, v in pairs(rs) do
			local vehicle = json.decode(v.vehicle)
			local plate = v.plate
			table.insert(vehicles, {vehicle = vehicle, plate = plate})
		end
		cb(vehicles)
	end)
end

-- Clear the text

string.trim = function(text)
	if text ~= nil then
		return text:match("^%s*(.-)%s*$")
	else
		return nil
	end
end
