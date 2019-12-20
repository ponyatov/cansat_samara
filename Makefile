
CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

TEX  = $(MODULE).tex header.tex
TEX += bib.tex
TEX += cansat/cansat.tex 
TEX += python/python.tex python/install.tex python/hello.tex python/serial.tex
TEX += embed/embed.tex emc/emc.tex linux/linux.tex

SRC  = apt.txt requirements.txt
SRC += python/hello.py python/hello.sh python/hello.out

LATEX = pdflatex -halt-on-error

$(MODULE).pdf: $(TEX) $(SRC) $(IMG)
	$(LATEX) $< | tail -n7
	$(LATEX) $< | tail -n7
	# $(LATEX) $<

pdf: $(MODULE)_$(NOW)-$(REL).pdf
$(MODULE)_$(NOW)-$(REL).pdf: $(MODULE).pdf Makefile
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
		-dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $<
# /screen /ebook /prepress

dot/%.png: dot/%.dot
	dot -Tpng -o $@ $<

python/%.out: python/%.py
	python3 $< > $@

clean:
	rm *.log *.aux *.toc

ifeq ($(OS),Windows_NT)
VSCsettings = .vscode/windows.json
else
VSCsettings = .vscode/linux.json
endif

vscode: .vscode/settings.json
.vscode/settings.json: $(VSCsettings)
	cp $< $@

