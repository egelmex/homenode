blinkm = {}
blinkm.__index = blinkm 

function blinkm.create(addr)
	blink = {}
	setmetatable(blink, blinkm)
	blink.addr = addr
	return blink
end

function send0(addr, command)
	i2c.start(id)
	i2c.address(id, addr, i2c.transmitter)
	i2c.write(id, command)
	i2c.stop(id)
end

function send1(addr, command, p1)
	i2c.start(id)
	i2c.address(id, addr, i2c.transmitter)
	i2c.write(id, command)
	i2c.write(id, p1)
	i2c.stop(id)
end

function send3(addr, command, p1, p2, p3)
	i2c.start(id)
	i2c.address(id, addr, i2c.TRANSMITTER)
	i2c.write(id, command)
	i2c.write(id, p1)
	i2c.write(id, p2)
	i2c.write(id, p3)
	i2c.stop(id)
end

function read(addr, count)
  i2c.start(id)
  i2c.address(id, addr,i2c.RECEIVER)
  c=i2c.read(id, count)
  i2c.stop(id)
  return c
end

function blinkm:fadeToRGB(r, g, b)
	send3(self.addr, 'c', r, g, b)
end

function blinkm:gotoRGBnow(r, g, b)
	send3(self.addr, 'n', r, g, b)
end

function blinkm:fadeToHSB(h, s, b)
	send3(self.addr, 'h', h, s, b)
end

function blinkm:fadeToRandomHSB(h, s, b)
	send3(self.addr, 'H', h, s, b)
end

function blinkm:fadeToRandomRGB(r,g,b)
	send3(self.addr, 'C',r,g,b)
end

function blinkm:playLightScript(n,r,p)
	print(string.format("%X", self.addr))
	send3(self.addr, 'p', n, r, p)
end

function blinkm:setFadeSpeed(f)
	send1(self.addr, 'f', f)
end

function blinkm:setTimeAdjust(t)
	send1(self.addr, 't', t)
end

function blinkm:stopScript()
	dev_addr = self.addr
	i2c.start(id)
	i2c.address(id, dev_addr ,i2c.TRANSMITTER)
	i2c.write(id, 'o')
	i2c.stop(id)
end

function blinkm:getCurrentColor()
	send1(self.addr, 'g')
	return read(self.addr, 3)
end

return blinkm 
