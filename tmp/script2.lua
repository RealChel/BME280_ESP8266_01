bme280.init(3,4)--SDA,SCL pin--выводы для подключения датчика
function readData()
    P, T = bme280.baro()
    H, T = bme280.humi()
    print("PRESSURE=".. P/1000*0.75)--давление * 0.75006375541921
    print("TEMPERATURE=".. T/100)--температура
    print("HUMIDITY=".. H/1000)--влажность
 end

readData()

function sendData() 
    sock=net.createConnection(net.TCP, false) 
    sock:connect(8283,'narodmon.ru')
sock:on("connection",function(sock, payload)
    local DEVICE_MAC = "7F-FF-31-10-69-54"--изменить на свои
    local SENSOR_MAC_1 = "TEMPERATURE"--изменить насвои
    local SENSOR_MAC_2 = "PRESSURE"--изменить на свои
    local SENSOR_MAC_3 = "HUMIDITY"--изменить на свои
    readData()
    sock:send("#"..DEVICE_MAC.."\n#"..SENSOR_MAC_1.."#"..(T/100).."\n#"..SENSOR_MAC_2.."#"..(P/1000*0.75).."\n#"..SENSOR_MAC_3.."#"..(H/1000).."\n##")
    end)

sock:on("receive", function(sock, answer)
   print('Narodmon answered '..answer)
   sock:close()
end)
   
end 
sendData() 
tmr.alarm(0, 360000, 1, function() sendData() end )
