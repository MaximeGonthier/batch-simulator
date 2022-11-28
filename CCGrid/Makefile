all: clean CCGrid-paper.pdf

abstract:
	pdflatex CCGrid-abstract.tex
	pdflatex CCGrid-abstract.tex
	rm -f CCGrid-abstract.aux CCGrid-abstract.log CCGrid-abstract.out CCGrid-abstract.blg CCGrid-abstract.bbl
	
%.pdf: %.tex
	pdflatex $*.tex
	bibtex $*
	pdflatex $*.tex
	pdflatex $*.tex
	rm -f $*.aux $*.log $*.out $*.blg $*.bbl
	
clean:
	rm -f *.aux *.log *.out *.blg *.bbl
