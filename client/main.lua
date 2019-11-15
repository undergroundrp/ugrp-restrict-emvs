-- THREADS ---------------------------------------------------------------------

  -- Setup
  Citizen.CreateThread(function()
    -- Initialize ESX
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end

    -- Fetch player data
    Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
  end)

  -- Restrict vehicles
  Citizen.CreateThread(function()
      while true do
        Citizen.Wait(500)

        if Config.restricted then
          local thisPed             = GetPlayerPed(PlayerId())
          local thisVehicle         = GetVehiclePedIsUsing(thisPed, false)
          local isEmergencyVehicle  = ((GetVehicleClass(thisVehicle) == 18) or IsPedInAnyPoliceVehicle(thisPed))
          local isDriver            = (GetPedInVehicleSeat(thisVehicle, -1) == thisPed)
          local isAuthorized        = false

          -- Check player job
          if PlayerData.job ~= nil then
            for _, v in ipairs(Config.allowed) do
              if v == PlayerData.job then
                isAuthorized = true
                break
              end
            end
          end

          -- Check player authorized
          if isEmergencyVehicle and isDriver and not isAuthorized then
            ESX.ShowNotification(_U('restricted'))
            SetVehicleUndriveable(thisVehicle, true)
          end
        end
      end
  end)


-- EVENTS ----------------------------------------------------------------------

  -- Initialize player data
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
  end)

  -- Initialize player jop
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
  end)
