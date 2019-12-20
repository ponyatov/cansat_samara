
CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

TEX  = $(MODULE).tex header.tex
TEX += bib.tex
TEX += cansat/cansat.tex 
TEX += python/python.tex python/install.tex python/hello.tex python/serial.tex
TEX += embed/embed.tex emc/emc.tex linux/linux.tex
TEX += python/jupyter.tex python/ply.tex python/flask.tex

SRC  = apt.txt requirements.txt
SRC += python/hello.py python/hello.sh

OUT  = python/hello.out

LATEX = pdflatex -halt-on-error

$(MODULE).pdf: $(TEX) $(SRC) $(IMG) $(OUT)
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

.PHONY: requirements.txt
requirements.txt:
	bin/pip3 freeze | grep -v 0.0.0 > $@

MERGE  = Makefile README.md .gitignore apt.txt
MERGE += $(TEX) $(SRC) $(IMG)

merge:
	git checkout master
	git checkout shadow -- $(MERGE)

release: pdf
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow

zip: $(MODULE)_$(NOW)-$(REL).zip
$(MODULE)_$(NOW)-$(REL).zip:
	git archive --format zip --output $@ HEAD
