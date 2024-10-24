include ../../../../etc/Makefile.conf

PROG = prolog
DEVICE ?= numworks

TARGETS := $(PROG).hex

all: $(TARGETS)	$(PROG).exe
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(PROG).ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

$(PROG).exe:	$(PROG).ml
	ocamlopt.opt -o $@ $^

$(PROG).bytecode:	$(PROG).ml
	ocamlc.opt -o $@ $^

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa *.exe *.bytecode


NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
