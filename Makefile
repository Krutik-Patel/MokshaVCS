OCAMLC=ocamlc
OCAMLFLAGS=
BUILDDIR=build
SRCDIR=src

# find all the .ml files in the src directory
SOURCEFILES=$(shell find $(SRCDIR) -name *.ml)

OBJECTFILES=$(patsubst $(SRCDIR)/%.ml, $(BUILDDIR)/%.cmo, $(SOURCEFILES))

all: moksha

moksha: $(OBJECTFILES)
	$(OCAMLC) $(OCAMLFLAGS) -o moksha $^

$(BUILDDIR)/parser/parser.cmo: $(SRCDIR)/parser/parser.ml \
								$(BUILDDIR)/subcommands/add.cmo \
								$(BUILDDIR)/subcommands/commit.cmo \
								$(BUILDDIR)/Test/Test.cmo
	mkdir -p $(dir $@)
	$(OCAMLC) $(OCAMLFLAGS) -I $(BUILDDIR)/subcommands -c $< -o $@

$(BUILDDIR)/%.cmo: $(SRCDIR)/%.ml
	mkdir -p $(dir $@)
	$(OCAMLC) $(OCAMLFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILDDIR) moksha

.PHONY: all clean

