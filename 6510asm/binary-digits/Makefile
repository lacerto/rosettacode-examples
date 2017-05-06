PrgDir = bin
DiskFile = $(PrgDir)/dec2bin.d64

$(PrgDir)/dec2bin.prg: dec2bin.s
	tmpx -i $< -o $@
	c1541 -attach $(DiskFile) -delete $(notdir $(basename $@))
	c1541 -attach $(DiskFile) -write $@ $(notdir $(basename $@))

.PHONY: clean
clean:
	rm $(PrgDir)/*.prg