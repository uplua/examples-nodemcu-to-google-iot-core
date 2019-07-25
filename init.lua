station_cfg={}
station_cfg.ssid="phab"  -- Enter SSID here
station_cfg.pwd="hukka123"  -- Enter password here


wifi.setmode(wifi.STATION)  -- set wi-fi mode to station
wifi.sta.config(station_cfg)-- set ssid&pwd to config
wifi.sta.connect(1)         -- connect to router

ip = wifi.sta.getip()       -- IP address of the connected access point 

print(ip)