local blinkm = require "blinkM"
print(node.heap())
local mcp = require "mcp9808"

m = mqtt.Client("node-" .. wifi.sta.getmac(), 120, "user", "password")
topic = "home/bedroom1/led"
mqtt_host = "192.168.1.10"

tempAddr = 0x18
blinkmAddr = 0x09

id = 0
sda = 1 
scl = 2
led = 3

i2c.setup(id, sda, scl, i2c.SLOW)
gpio.mode(led, gpio.OUTPUT)

tempModule = mcp.create(tempAddr)
blink = blinkm.create(blinkmAddr)

function mq_connect()
	print( "mq: connecting...")
      m:connect(mqtt_host, 1883, 0, function(conn)
	tmr.stop(1)
	print("mq: connected") 
	m:subscribe(topic, 0, function(client, topic, message)
		if message == Nil then
			print("mq: subscribe success" )
		else
			print("mq: subscribe success" .. message)
		end
	end)
      end)
end

tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("wifi: Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
	mq_connect()
      tmr.stop(0)
   end

end)

m:on("connect", function(con)
	print ("mq: connected")

end)
m:on("offline", function(con)
	print ("mq: Disonnected...")
	tmr.alarm(1, 1000, 1, mq_connect)
end)


m:on("message", function(conn, t, data) 
  print(t .. ":" ) 
  if data ~= nil then print(data) end

  if topic == t then
	print ("Topic matched:")
	if data == 1 or data == "1" then
		gpio.write(led, gpio.HIGH)
		blink:stopScript()
		blink:fadeToRGB(0,255,0)
		
	else
		gpio.write(led, gpio.LOW)
		blink:stopScript()
		blink:fadeToRGB(255,0,0)
	end
  end
end)

tmr.alarm(2, 5000, 1, function()
	temp = tempModule:readC()

	m:publish("bedroom1/temp",temp,0,0, function(conn) 
		print("Temp=",temp)
	end)
end)

print("playing light script")

blinkm:setFadeSpeed(20)
blinkm:setTimeAdjust(-10)
blink:playLightScript(12,0x00,0x00)
