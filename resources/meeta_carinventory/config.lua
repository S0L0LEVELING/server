-- CREATE BY THANAWUT PROMRAUNGDET
Config = {}

Config.Key = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config.Distance = 2.0 -- ระยะ
Config.Delay = 2000 -- ระยะสัญญาของรีโมท

Config.Limit = 25000


Config.DefaultWeight = 10
Config.localWeight = {
	black_money = 0.01,
	cash = 0.01,
   	raw_ore = 100,
	stone = 100,
	copper_nugget = 200,
	copper_bar = 500,
	iron = 300,
	metal_scrap = 300,
	steel_bar = 300,
	gold_nugget = 500,
	gold_bar = 500,
	rough_diamond = 500,
	diamond = 500,
	alive_chicken = 300,
	slaughtered_chicken = 300,
	packaged_chicken = 300,
	gazbottle = 200,
	essence = 200,
	petrol = 200,
	petrol_raffin = 200, 
	weed = 500,
    weed_pooch = 500,    
	fish = 300,
	fish2 = 300,
	clothe = 200,
	wool = 200,
	fabric = 200,
	cannabis = 250,
	marijuana = 750,
	grass = 30,
	grass_pack = 30,
	pro_wood = 3000,
	wood = 1000,
	sand = 500,
	glass = 1000,
	catfish = 1000,
	catfishfood = 5000,
	snakefishfood = 7500,
	snakeheadfish = 1500,
	bikersuit = 3750,
	meat = 750,
	leather = 750,
	milk = 750,
	meatfood = 1500,
	ammo_pistol = 1000,
	ammo_pistol50 = 1000,
	shark = 3000,
	WEAPON_STUNGUN = 10000,
	WEAPON_PISTOL = 10000,
	WEAPON_PISTOL50 = 10000,
	WEAPON_PETROLCAN = 10000,
	WEAPON_NIGHTSTICK = 5000,
	WEAPON_HEAVYSNIPER = 20000,
	WEAPON_FLASHLIGHT = 5000,
	WEAPON_BAT = 5000,
}

Config.VehicleLimitModel = {
    ["Panto"] = 15000,
	["blista"] = 25000,
	["cog55"] = 25000,
	["issi2"] = 25000,
	["issi3"] = 25000,
	["kamacho"] = 30000,
	["premier"] = 25000,
	["rhapsody"] = 20000,
	["schafter2"] = 25000,
	["stafford"] = 30000,
	["superd"] = 30000,
	["brawler"] = 25000,
	["rebel2"] = 35000,
	["asea"] = 25000,
	["emperor"] = 30000,
	["primo"] = 25000,
	["warrener"] = 25000,
	["brio"] = 15000,
	["casco"] = 25000,
	["michelli"] = 25000,
	["pigalle"] = 30000,
	["zion2"] = 30000,
	["Lynx"] = 25000,
	["z4"] = 25000,
	["carbonizzare"] = 25000,
	["guardian"] = 40000,
	["z190"] = 40000,
	["dominator"] = 30000,
	["dominator3"] = 30000,
	["f620"] = 25000,
	["kuruma"] = 30000,
	["baller2"] = 40000,
	["bjxl"] = 45000,
	["minivan"] = 40000,
	["serrano"] = 40000,
	["bison"] = 40000,
	["burrito3"] = 40000
}