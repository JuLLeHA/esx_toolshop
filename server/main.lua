RegisterServerEvent('buyItem')
AddEventHandler('buyItem', function(item, price)

    local _source = _source
    local xPlayer = ESX.GetPlayerFromID(_source)
    local sourceitem = xPlayer.GetInventoryItem(itemname)

    if xPlayer.GetAccount.money >= price and not Xplayer.hasWeapon(item) then
        Xplayer.removeAccountMoney(price)
        Xplayer.addWeapon(item)
        TriggerClientEvent('esx:showNotification', _source, _U('bought') .. item)
    elseif xPlayer.getAccount.money <= price then
        TriggerClientEvent('esx:ShowNotification', _source, _U('nomoney'))
    else
        TriggerClientEvent('esx:ShowNotification', _source, _U('alreadyhave'))
    end
end)