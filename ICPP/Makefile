all: clean paper.pdf

abstract:
	pdflatex abstract.tex
	pdflatex abstract.tex
	rm -f abstract.aux abstract.log abstract.out abstract.blg abstract.bbl
	
%.pdf: %.tex
	pdflatex $*.tex
	bibtex $*
	pdflatex $*.tex
	pdflatex $*.tex
	rm -f $*.aux $*.log $*.out $*.blg $*.bbl
	
clean:
	rm -f *.aux *.log *.out *.blg *.bbl
