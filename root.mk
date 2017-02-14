# You can change the pdf viewer to your preferred
# one by commenting every line beginning by
# `PDFVIEWER' except the one with your pdf viewer
#PDFVIEWER=evince # GNOME
#PDFVIEWER=okular # KDE
#PDFVIEWER=xpdf # lightweight
PDFVIEWER=xdg-open # Default pdf viewer - GNU/Linux
#PDFVIEWER=open # Default pdf viewer - Mac OS

MAIN_NAME_SOL=$(MAIN_NAME)-Sol
PDF=$(MAIN_NAME).pdf
PDFR=$(MAIN_NAME)-$(shell date +"%Y-%m-%d").pdf
PDF_SOL=$(MAIN_NAME_SOL).pdf
PDF_SOLR=$(MAIN_NAME_SOL)-$(shell date +"%Y-%m-%d").pdf

ALL=$(PDF)
ifdef N
	FULL=$(PDF_SOL)
	ALL+=$(PDF_SOL)
else
	FULL=$(PDF)
endif

# You want latexmk to *always* run, because make does not have all the info.
.PHONY: $(PDF) $(PDF_SOL)

# If you want the pdf to be opened by your preferred pdf viewer
# after `$ make', comment the following line and uncomment the
# line after
#default: all
default: show

all: $(ALL)

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interactive=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

$(PDF): $(MAIN_NAME).tex
	latexmk -pdf -pdflatex="pdflatex -shell-escape -enable-write18 '\def\Sol{false} \input{%S}'" -use-make $(MAIN_NAME).tex

$(PDF_SOL): $(MAIN_NAME).tex
	latexmk -pdf -pdflatex="pdflatex -jobname=$(MAIN_NAME_SOL) -shell-escape -enable-write18 '\def\Sol{true} \input{%S}'" -use-make $(MAIN_NAME).tex -jobname=$(MAIN_NAME_SOL)

clean:
	latexmk -CA
	$(RM) *.aux *.fdb_latexmk *.log *.out *.pdf *.bbl

show: $(FULL)
ifdef N
	$(PDFVIEWER) $(PDF_SOL) 2> /dev/null &
else
	$(PDFVIEWER) $(PDF) 2> /dev/null &
endif

release: $(ALL)
	cp $(PDF) $(PDFR)
ifdef N
	cp $(PDF_SOL) $(PDF_SOLR)
endif
