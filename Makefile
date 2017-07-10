PROJECT = Resume

all: clean default display

default: obj/$(PROJECT).pdf

display: default
	(${PDFVIEWER} obj/$(PROJECT).pdf &)

clean:
	rm -rf obj/

FLAGS  = -halt-on-error -output-directory obj/

ENGINE = xelatex
TEXINPUTS = .:obj/
TEXMFOUTPUT = obj/

### File Types
TEX_FILES = $(shell find . -name '*.tex' -or -name '*.sty' -or -name '*.cls')
BIB_FILES = $(shell find . -name '*.bib')
BST_FILES = $(shell find . -name '*.bst')
IMG_FILES = $(shell find . -path '*.jpg' -or -path '*.png' -or \( \! -path './obj/*.pdf' -path '*.pdf' \) )

### Standard PDF Viewers
UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
PDFVIEWER = evince
endif

ifeq ($(UNAME), Darwin)
PDFVIEWER = open
endif

### Core Latex Generation

obj/:
	mkdir -p obj/

obj/$(PROJECT).aux: $(TEX_FILES) $(IMG_FILES) | obj/
	$(ENGINE) $(FLAGS) $(PROJECT)

obj/$(PROJECT).bbl: $(BIB_FILES) | obj/$(PROJECT).aux
	bibtex obj/$(PROJECT)
	$(ENGINE) $(FLAGS) $(PROJECT)
	
obj/$(PROJECT).pdf: obj/$(PROJECT).aux $(if $(BIB_FILES), obj/$(PROJECT).bbl)
	$(ENGINE) $(FLAGS) $(PROJECT)