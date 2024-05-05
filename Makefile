OCAMLC=ocamlc
OCAMLFLAGS=
BUILDDIR=build
SRCDIR=src

# find all the .ml files in the src directory
SOURCEFILES=$(shell find $(SRCDIR) -name *.ml)

OBJECTFILES=$(patsubst $(SRCDIR)/%.ml, $(BUILDDIR)/%.cmo, $(SOURCEFILES))

all: moksha

moksha: $(OBJECTFILES)
	$(OCAMLC) $(OCAMLFLAGS) -o moksha \
	$(BUILDDIR)/global/global.cmo \
	$(BUILDDIR)/helper/*.cmo \
	$(BUILDDIR)/subcommands/*.cmo \
	$(BUILDDIR)/parser/parser.cmo


$(BUILDDIR)/global/global.cmo: $(SRCDIR)/global/global.ml
	mkdir -p $(dir $@)
	$(OCAMLC) $(OCAMLFLAGS) -c $< -o $@


$(BUILDDIR)/helper/%.cmo: $(SRCDIR)/helper/%.ml
	mkdir -p $(dir $@)
	$(OCAMLC) $(OCAMLFLAGS) -c $< -o $@


$(BUILDDIR)/Test/%.cmo: $(SRCDIR)/Test/%.ml
	mkdir -p $(dir $@)
	$(OCAMLC) $(OCAMLFLAGS) -c $< -o $@


$(BUILDDIR)/subcommands/%.cmo: $(SRCDIR)/subcommands/%.ml \
								$(BUILDDIR)/helper/fileHandler.cmo \
								$(BUILDDIR)/global/global.cmo
	mkdir -p $(dir $@)
	$(OCAMLC) $(OCAMLFLAGS) -I $(BUILDDIR)/helper -I $(BUILDDIR)/global -c $< -o $@
 

$(BUILDDIR)/parser/parser.cmo: $(SRCDIR)/parser/parser.ml \
								$(BUILDDIR)/Test/Test.cmo \
								$(BUILDDIR)/subcommands/add.cmo \
								$(BUILDDIR)/subcommands/init.cmo \
								$(BUILDDIR)/subcommands/commit.cmo \
								$(BUILDDIR)/subcommands/checkout.cmo \
								$(BUILDDIR)/subcommands/clone.cmo \
								$(BUILDDIR)/subcommands/status.cmo \
								$(BUILDDIR)/subcommands/log.cmo \
								$(BUILDDIR)/subcommands/merge.cmo \
								$(BUILDDIR)/subcommands/push.cmo \
								$(BUILDDIR)/subcommands/pull.cmo
	mkdir -p $(dir $@)
	$(OCAMLC) $(OCAMLFLAGS) -I $(BUILDDIR)/global -I $(BUILDDIR)/helper -I $(BUILDDIR)/subcommands -c $< -o $@

# The -I flag is to provide directory for the built modules the currently compiled module is using




clean:
	rm -rf $(BUILDDIR) moksha

cleanup:
	rm -rf $(BUILDDIR)

.PHONY: all clean

