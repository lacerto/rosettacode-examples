PrgDir = bin
DiskFile = $(PrgDir)/clrscr.d64

$(PrgDir)/clrscr.prg: clrscr.s
	tmpx -i $< -o $@
	c1541 -attach $(DiskFile) -delete $(notdir $(basename $@))
	c1541 -attach $(DiskFile) -write $@ $(notdir $(basename $@))

.PHONY: clean
clean:
	rm $(PrgDir)/*.prg