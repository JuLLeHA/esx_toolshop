-- Marker settings
Citizen.CreateThread(function()
    while true do

        wait(0)

        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerped)

        if GetDistanceBetweenCoords(coords, Config.MarkerPos.x, Config.MarkerPos.y, Config.MarkerPos.z, true) < Config.DrawDistance then
        DrawMarker(Config.MarkerType, Config.MarkerPos.x, Config.MarkerPos.z, Config.MarkerPos.y, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
        end
    end
end)

-- Blip settings
Citizen.CreateThread(function()

    if Config.ShowBlip = true then
        AddBlipForCoord(Config.BlipPos.x, Config.BlipPos.z, Config.BlipPos.x)
        SetBlipSprite(Config.BlipType)
        SetBlipDisplay(4)
        SetBlipScale(Config.BlipScale)
        SetBlipColor(Config.BlipColor)
        SetBlipText(Config.BlipName)
    end
end)

AddEventHandler('hasEnteredMarker', function()

    CurrentActionMsg = _U('open_shopText')
    CurrentAction = 'open_shop'

end)

AddEventHandler('hasExitedMarker', function()

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerped)

        if GetDistanceBetweenCoords(coords, Config.MarkerPos.x, Config.MarkerPos.z, Config.MarkerPos.y, true) then
                isInMarker = true
        end
    
    if isInMarker and not HasalreadyEnteredMarker then
        HasalreadyEnteredMarker = true
        TriggerEvent('HasEnteredMarker')
    end
    if not isInMarker and HasalreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('hasExitedMarker')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.wait(0)
        if CurrentAction ~= nil then
        
            ESX.ShowHelpNotification(CurrentActionMsg)
            
            local playerPed = GetPlayerPed(-1)

            if IsControlJustReleased(0, 38) then
                if CurrentAction == 'open_shop' then
                    OpenShopMenu()
                end
            
            else
            Citizen.Wait(500)
            end
        end
    end
end)

function OpenShopMenu()

    local playerPed = PlayerPedId()
    Local elements = {}

    for k,v in ipairs(Config.Weapons) do

        table.insert(elements, {
                label = _U('price'):format(v.label, ESX.Math.GroupDigits(v.price)),
                WeaponName = v.item,
                price = v.price,
        })
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.MenuOpen('default', GetCurrentResourceName(), 'shop_menu',{
        title = _U('shop'),
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        ESX.UI.Menu.Open('defualt', GetCurrentResourceName(), 'shop_confirm', {
            title =_U('buy'),
            align = 'bottom-right',
            elements = {
            {label = _U('yes'), value = 'yes'},
            {label = _U('no'), value = 'no'},

        }
    }, function(data2, menu2)
        if data2.current.value == 'yes' then
            ESX.TriggerServerEvent('buyItem', data.current.WeaponName, data.current.price)
        else
        ESX.ShowNotification(_U('noweapon'))
        end
        end)

    end

    menu2.close()
end, function(data2, menu2)
    menu2.close()

    CurrentAction = 'shop_menu'
    CurrentActionMsg = _U('open_shopText')
    end)
end