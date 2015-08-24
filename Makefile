all : data/ahr.utf8.csv Blevins-and-Mullen.gender-prediction.pdf Blevins-and-Mullen.gender-prediction.html Blevins-and-Mullen.gender-prediction.docx

Blevins-and-Mullen.gender-prediction.pdf : article.Rmd
	R --slave -e "set.seed(100); rmarkdown::render('$(<F)', output_format = 'pdf_document', output_file = '$@', clean = FALSE)"

Blevins-and-Mullen.gender-prediction.html : article.Rmd
	R --slave -e "set.seed(100); rmarkdown::render('$(<F)', output_options = list(self_contained = FALSE), output_format = 'html_document', output_file = '$@', clean = FALSE)"

Blevins-and-Mullen.gender-prediction.docx : article.Rmd
	R --slave -e "set.seed(100); rmarkdown::render('$(<F)', output_format = 'word_document', output_file = '$@', clean = FALSE)"

# Change the file encoding of the AHR data
data/ahr.utf8.csv : data-raw/AHR_BookAuthors_Reviewers.csv
	mkdir -p data
	iconv -f latin1 -t utf8 $^ > $@

clean :
	rm -f Blevins-and-Mullen.gender-prediction.pdf Blevins-and-Mullen.gender-prediction.html Blevins-and-Mullen.gender-prediction.docx

clobber :
	rm -f data/ahr.utf8.csv
