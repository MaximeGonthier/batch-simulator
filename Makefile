all: Data_aware_batch_scheduling todo

Data_aware_batch_scheduling:
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	pdflatex Data_aware_batch_scheduling.tex
	bibtex Data_aware_batch_scheduling
	pdflatex Data_aware_batch_scheduling.tex
	pdflatex Data_aware_batch_scheduling.tex
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	
todo:
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	pdflatex todo.tex
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	
summary:
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	pdflatex summary.tex
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo *.nav
	
clean:
	rm -f *.toc *.aux *.log *.out *.blg *.xml *.dvi *.bbl *-blx.bib *.bcf *.ist *glsdefs *.lof *.acn *.glo

.SILENT: pdf
