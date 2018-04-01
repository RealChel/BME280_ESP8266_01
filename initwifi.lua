wifi.setmode(wifi.STATION)
wifi.sta.config({ssid="Note4",pwd="BezParoly"})--изминить на свои
--wifi.sta.config("Note4","BezParoly")--изминить на свои
wifi.sta.connect()
tmr.alarm(0, 1000, 1, function ()
  local ip = wifi.sta.getip()
  if ip then
    tmr.stop(0)
    print(ip)
    print(wifi.sta.getmac())
  else
    print("Connecting to WIFI...")
  end
end)


