include ../../../../etc/Makefile.conf

PROG = hello
DEVICE ?= numworks

# Use the first line if you want to compile also the PC simulator. FIXME: it is not at all developped for the Numworks target.
# TARGETS := $(PROG).elf $(PROG).hex
TARGETS := $(PROG).hex

all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(PROG).ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa


NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
