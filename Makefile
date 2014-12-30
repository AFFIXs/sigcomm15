
PAPER=paper
all: 
	pdflatex $(PAPER); bibtex $(PAPER); pdflatex $(PAPER); pdflatex $(PAPER)


SECTIONS = \
	abstract.tex \
	introduction.tex \
	goals.tex \
	related.tex \
	implementation.tex \
	architecture.tex \
	services.tex \
	eval.tex \
	results.tex \
	casestudy.tex \
	conclusion.tex


TEXT =  $(SECTIONS) 

TEX   = paper.tex \
        $(TEXT)

FIGS = 
#FIGS = \
#   PLtime.eps

#PS2PDF = ps2pdf14
PS2PDF = ps2pdf


$(PAPER).ps: $(PAPER).dvi
	dvips -e 0 -Pcmz -Pamz -G0 -D 600 -t letter $(PAPER) -o $@

$(PAPER).dvi: $(PAPER).tex $(TEX) $(FIGS) $(PAPER).bbl 
	export TEXINPUTS=.:./latex-styles:; \
	pdflatex $(PAPER)
	pdflatex $(PAPER)
	pdflatex $(PAPER)

$(PAPER).bbl: bibdata.bib
	export TEXINPUTS=.:./latex-styles:; \
	pdflatex $(PAPER); bibtex $(PAPER); pdflatex $(PAPER); pdflatex $(PAPER)

$(PAPER).pdf: $(PAPER).ps 
	$(PS2PDF) $^ $@

again:
	/bin/rm $(PAPER).dvi; $(MAKE)

DELATEX = detex -l -n 

html: $(PAPER).ps
	-/bin/rm -rf html
	latex2html  -image_type gif -split 0 -show_section_numbers \ 
	-local_icons -dir html -transparent -info 0 -antialias_text \
	-white -antialias -mkdir $(PAPER).tex

viewhtml:
	firefox file://$$PWD/html/index.html


count:
	$(DELATEX)  $(TEXT) | wc -w

count1:
	countwords $(TEXT)
 

count2:
	delatex $(TEX) | wc -w

spell:
	ispell $(SECTIONS)

clean:
	/bin/rm -f $(PAPER).aux $(PAPER).bbl $(PAPER).blg $(PAPER).dvi \
	$(PAPER).log $(PAPER).ps $(PAPER).pdf

ocd: clean
	/bin/rm -f *.*~ *~

