sda, scl = 3, 4
i2c.setup(0, sda, scl, i2c.SLOW)-- call i2c.setup() only once
bme280.setup(nil, nil, nil, 0) -- initialize to sleep mode

P, T = bme280.baro()
H, T = bme280.humi()
T, Tf = bme280.temp()
print(P,H,T)

bme280.startreadout(0, function ()
  T, P,H = bme280.read()
  print (T,P,H)
  local Tsgn = (T < 0 and -1 or 1); T = Tsgn*T
  print(string.format("T=%s%d.%02d", Tsgn<0 and "-" or "", T/100, T%100))
   print("PRESSURE=".. (P  or 0)/1000*0.75)--давление * 0.75006375541921
    print("TEMPERATURE=".. (T or 0) /100)--температура
    print("HUMIDITY=".. (H or 0)/1000)--влажность

end)
