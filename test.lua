local sp  = require 'lib.samp.events'
update_state = false -- Если переменная == true, значит начнётся обновление.

local script_vers = 1.1
local script_vers_text = "v1.0" -- Название нашей версии. В будущем будем её выводить юзеру.

local update_url = 'https://raw.githubusercontent.com/Dev-Oleksandr/auto-update/main/update.ini' -- Путь к ini файлу. Позже нам понадобиться.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = 'https://github.com/Dev-Oleksandr/auto-update/blob/main/ManagementTools.luac?raw=true' -- Путь скрипту.
local script_path = thisScript().path


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateini = inicfg.load(nil, update_path)
            if tonumber(updateini.info.vers) > script_vers then
                sampAddChatMessage("Есть обновление! Версия {FA8072}" .. updateini.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)

    while true do wait(0)
      
    end
end

function sp.onSendCommand(input)
    if input:find('^/update') and update_state then 
        lua_thread.create(function()
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            update_state = false
        end)
        return false
    end 
end