include ../../../../etc/Makefile.conf

PROG = prolog
EADK_APP_NAME = OCaml-Prolog
DEVICE ?= numworks

TARGETS := $(PROG).hex $(PROG).elf

OCAMLOPT = ocamlopt.opt
OCAMLC = ocamlc.opt

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(PROG).ml mygenlex.ml
	@echo "omicrob $<"
	$(BIN)/omicrob -v -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@


# TODO: include inline the content of mygenlex.ml in prolog.ml: it should be ONE file, with no dependencies...
# TODO: solve the issue of the Stream module? Either include it in OMicroB/stdlib/ or include it here?

$(PROG).elf:	$(PROG).ml
	@echo "OCAMLOPT $<"
	$(OCAMLOPT) -c mygenlex.mli
	$(OCAMLOPT) -c mygenlex.ml
	$(OCAMLOPT) -o $@ mygenlex.cmx $^
	# To test what was produced:
	./$@

$(PROG).bytecode:	$(PROG).ml mygenlex.ml
	@echo "OCAMLC $<"
	$(OCAMLC) -c mygenlex.mli
	$(OCAMLC) -c mygenlex.ml
	$(OCAMLC) -o $@ mygenlex.cmo $^
	# To test what was produced:
	./$@

.PHONY: run
clean:
	rm -vf *.cmi *.cmo *.cmx *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa *.elf *.bytecode *.o

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
