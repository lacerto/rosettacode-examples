PrgDir = bin
DiskFile = $(PrgDir)/inverse-video.d64

$(PrgDir)/inverse-video.prg: inverse-video.s
	tmpx -i $< -o $@
	c1541 -attach $(DiskFile) -delete $(notdir $(basename $@))
	c1541 -attach $(DiskFile) -write $@ $(notdir $(basename $@))

.PHONY: clean
clean:
	rm $(PrgDir)/*.prg