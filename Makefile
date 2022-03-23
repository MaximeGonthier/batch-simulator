all: Data_aware_batch_scheduling

Data_aware_batch_scheduling:
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	pdflatex Data_aware_batch_scheduling.tex
#~ 	bibtex Data_aware_batch_scheduling
	pdflatex Data_aware_batch_scheduling.tex
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	
clean:
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo

.SILENT: pdf
