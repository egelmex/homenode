port = /dev/ttyUSB0
luatool = ~/Dropbox/src/luatool/luatool/luatool.py

all: main init mcp9808 blinkm

.phony: main
main: .main.tmp

.main.tmp: main.lua
	python2.7 ${luatool} -p ${port} --src $< --dest $<
	touch .main.tmp

.phony: init
init: .init.tmp	

.init.tmp: init.lua
	python2.7 ${luatool} -p ${port} --src $< --dest $<
	touch .init.tmp

.phony: mcp9808
mcp9808: .mcp9808.tmp

.mcp9808.tmp: mcp9808.lua
	python2.7 ${luatool} -p ${port} --src $< --dest $< -c
	touch .mcp9808.tmp

.phony: blinkm
blinkm: .blinkm.tmp

.blinkm.tmp: blinkM.lua
	python2.7 ${luatool} -p ${port} --src $< --dest $< -c
	touch .blinkm.tmp

list:
	python2.7 ${luatool} -l

.phony: clean
clean:
	rm .*.tmp
