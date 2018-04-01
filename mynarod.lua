bme280.init(3,4)--SDA,SCL pin--выводы для подключения датчика GPI0=d3 GPI2=d4

function readData()
	P, _T = bme280.baro()
	H, _T = bme280.humi()
    T, _TFine = bme280.temp()

    --[[print(P)
    print(T)
    print(H)
    print(_TFine)
    
    print("PRESSURE=".. P/1000*0.75)--давление * 0.75006375541921
    print("TEMPERATURE=".. T/100)--температура
    print("HUMIDITY=".. H/1000)--влажность
    print("_TFine=".. _TFine)--влажность]]
end

--readData()

function sendData() 
    sock=net.createConnection(net.TCP, 0) 
    sock:connect(8283,'narodmon.ru')
sock:on("connection",function(sock, payload)
    local DEVICE_MAC = "dc:4f:22:19:d6:34"--изменить на свои
    local SENSOR_MAC_1 = "dc:4f:22:19:d6:31"--изменить насвои
	local SENSOR_MAC_2 = "dc:4f:22:19:d6:32"--изменить на свои
	local SENSOR_MAC_3 = "dc:4f:22:19:d6:33"--изменить на свои
	readData()
    sock:send("#"..DEVICE_MAC.."\n#"..SENSOR_MAC_1.."#"..(T/100).."\n#"..SENSOR_MAC_2.."#"..(P/1000*0.75).."\n#"..SENSOR_MAC_3.."#"..(H/1000).."\n##")
    end)

sock:on("receive", function(sock, answer)
   --print('Narodmon answered '..answer)
   sock:close()
end)
   
end 
sendData() 
tmr.alarm(0, 400000, tmr.ALARM_AUTO, function() sendData() end )
