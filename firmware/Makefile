port = /dev/ttyUSB0
luatool = ~/Dropbox/src/luatool/luatool/luatool.py

all: main init mcp9808 blinkm

.phony: main
main: .main.tmp

.main.tmp: main.lua
	python2.7 ${luatool} -p ${port} --src main.lua --dest main.lua
	touch .main.tmp

.phony: init
init: .init.tmp	

.init.tmp: init.lua
	python2.7 ${luatool} -p ${port} --src init.lua --dest init.lua
	touch .init.tmp

.phony: mcp9808
mcp9808: .mcp9808.tmp

.mcp9808.tmp: mcp9808.lua
	python2.7 ${luatool} -p ${port} --src mcp9808.lua --dest mcp9808.lua
	touch .mcp9808.tmp

.phony: blinkm
blinkm: .blinkm.tmp

.blinkm.tmp: blinkM.lua
	python2.7 ${luatool} -p ${port} --src blinkM.lua --dest blinkM.lua
	touch .blinkm.tmp

list:
	python2.7 ${luatool} -l

.phony: clean
clean:
	rm .*
