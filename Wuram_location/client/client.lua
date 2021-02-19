


local Keys = {
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


ESX = nil 

local latestPoint



Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)


_menuPool = NativeUI.CreatePool()
locationMenu = NativeUI.CreateMenu("Location","", nil, nil, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")
_menuPool:Add(locationMenu)



spawnCar = function(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    if latestPoint == 1 then

    local vehicle = CreateVehicle(car, -1029.8221, -2731.8547, 20.10, 240.55, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNumberPlateText(vehicle, "WURAM")
    elseif latestPoint == 2 then
        local vehicle = CreateVehicle(car, 254.50, -777.28, 30.62, 122.45, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleNumberPlateText(vehicle, "WURAM")
    end
   
end


function AddLocationMenu(menu)

    local voituremenu = _menuPool:AddSubMenu(menu, "Voiture", nil, nil, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")

    local motomenu = _menuPool:AddSubMenu(menu, "Moto", nil, nil, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")





    local panto = NativeUI.CreateItem("Panto", "Appuyer sur ENTRER pour louer ce véhicule")
    voituremenu.SubMenu:AddItem(panto)
    panto:RightLabel("50$")


    local faggio = NativeUI.CreateItem("Faggio", "Appuyer sur ENTRER pour louer ce véhicule")
    motomenu.SubMenu:AddItem(faggio)
    faggio:RightLabel("25$")



    voituremenu.SubMenu.OnItemSelect = function(menu, item)
        if item == panto then 
            TriggerServerEvent('buyPanto')
            ESX.ShowNotification('Vous avez payé 50$')
            Citizen.Wait(1)
            spawnCar("panto")
            ESX.ShowAdvancedNotification("Location", "Merci faites attention sur la route !", "", "CHAR_CARSITE", 1)
            _menuPool:CloseAllMenus(true)
        end
    end


    motomenu.SubMenu.OnItemSelect = function(menu, item)
        if item == faggio then
            TriggerServerEvent('buyFaggio')
            ESX.ShowNotification('Vous avez payé 25$')
            Citizen.Wait(1)
            spawnCar("faggio")
            ESX.ShowAdvancedNotification("Location", "Merci faites attention sur la route !", "", "CHAR_CARSITE", 1)
            _menuPool:CloseAllMenus(true)
        end
    end




end

AddLocationMenu(locationMenu)
_menuPool:RefreshIndex()

local blips = {
    {title="Location de Véhicule", colour=3, id = 480, x = -1032.42, y = -2734.21, z = 19.16,},
    {title="Location de Véhicule", colour=3, id = 480, x = 259.78, y = -783.15, z = 31.52,}  -- Blips sur la Map
}



Citizen.CreateThread(function()

    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.8)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)


local location = {
    {x = -1030.0611, y = -2735.2121, z = 20.23, type = 1},
    {x = 258.66, y = -782.73, z = 30.52, type = 2},
}



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false);

        for k in pairs(location) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, location[k].x, location[k].y, location[k].z)

            if dist <= 1.2 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour intéragir avec le ~b~Loueur")
                if IsControlJustPressed(1,51) then 
                    latestPoint = location[k].type 
                    locationMenu:Visible(not locationMenu:Visible())
				end
            end
        end
    end
end)

local v1 = vector3(-1030.0611, -2735.2121, 21.23)
local v2 = vector3(259.78, -783.15, 31.52)      -- Le nom au dessus du PNJ



function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.30)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local distance = 40

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < distance then
            Draw3DText(v1.x,v1.y,v1.z, "Wuram")
        end
        
        if Vdist2(GetEntityCoords(PlayerPedId(), false), v2) < distance then
            Draw3DText(v2.x,v2.y,v2.z, "Wuram")
		end
	end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("cs_barry")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Citizen.Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", "cs_barry", -1030.0611, -2735.2121, 19.23, false, true) --Emplacement du PEDS
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    ped = CreatePed("PED_TYPE_CIVMALE", "cs_barry", 259.78, -783.15, 29.51, 69.41, false, true) --Emplacement du PEDS
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end)



