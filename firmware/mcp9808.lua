MCP9808 = {}
MCP9808.__index = MCP9808 

local MCP9808_REG_UPPER_TEMP        = 0x02
local MCP9808_REG_LOWER_TEMP        = 0x03
local MCP9808_REG_CRIT_TEMP         = 0x04
local MCP9808_REG_AMBIENT_TEMP      = 0x05
local MCP9808_REG_MANUF_ID          = 0x06
local MCP9808_REG_DEVICE_ID         = 0x07

function read_reg(dev_addr, reg_addr) -- Read MCP9808 data
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id,reg_addr)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.RECEIVER)
  c=i2c.read(id,2)
  i2c.stop(id)
  return c
end

function MCP9808.toFahrenheit(ctemp) -- convert Celcius to Fahrenheit
  ftemp = ctemp * 9 / 5 + 32
  return temp
end

function MCP9808.create(addr)
	local mcp = {}
	setmetatable(mcp,MCP9808)
	mcp.addr = addr
	return mcp
end

function convert(tempval) -- convert 2 byte value
  t = tonumber(string.byte(tempval,1))
  --print (string.format("%X %X", t, tonumber(string.byte(tempval,2))))
  t = bit.lshift(t,8) + tonumber(string.byte(tempval,2))
  temp = bit.band(t, 0x0FFF) / 16
  if t > 127 then t = t - 255 end
  return temp
end 

function MCP9808:readC()
	return convert(read_reg(self.addr, 0x05))
end

return MCP9808
