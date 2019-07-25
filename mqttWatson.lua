
mqttPort =  --mqtt port
broker =  --broker
userID =  --username
userPWD =  --password
clientID =     -- enter clientID here
mqttState = 0 -- State Control

t0 = tmr.time()

function wifi_connect()
 wifi.setmode(wifi.STATION)
 wifi.sta.config("NETGEAR81","imaginarypiano1")
 wifi.sta.connect()
end

function mqtt_do()
 count = count +1  -- tmr alarm counter

 if mqttState < 5 then
 mqttState = wifi.sta.status() --State:Waiting for wifi
 wifi_connect()

 elseif mqttState == 5 then
 print("Starting to connect...")
 m = mqtt.Client( clientID, 120, userID, userPWD)

 m:on("offline", function(conn)
 print ("Checking GCP server...")
 mqttState = 0 -- Starting all over again
 end)

 m:connect(broker, mqttPort, 0,
 function(conn)
 print("Connected to"..broker..":" ..mqttPort)
 mqttState = 20 --Go to publish State
 end)

 elseif mqttState == 20 then
 mqttState =25 --Publishing
 t1 = tmr.time() - t0
 if t1 >100 then
 t1 = 0
 t0 = tmr.time()
 end
 -- t1 is used as emulated sensor data, real application will use GPIOx to sense external sensors

 m:publish(topic , '{"d": {"data":'..t1..'}}', 0, 0,

 function(conn)
 -- Print confirmation of data published
 print("Sent message #"..count.." data:"..t1)
 mqttState = 20 --Finished publishing - go back to publish state.
 end)

 else print("Waiting..."..mqttState)
 mqttState = mqttState - 1     -- takes us gradually back to publish state to retry
 end

end

tmr.alarm(2, 10000, 1, function() mqtt_do() end)  -- send data every 10s





 
