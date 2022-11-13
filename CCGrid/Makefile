all: clean CCGrid-paper.pdf

%.pdf: %.tex
	pdflatex $*.tex
#~ 	bibtex $*
	pdflatex $*.tex
	pdflatex $*.tex
	rm -f $*.aux $*.log $*.out $*.blg $*.bbl
	
clean:
	rm -f *.aux *.log *.out *.blg *.bbl
