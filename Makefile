all : data/ahr.utf8.csv

# Change the file encoding of the AHR data
data/ahr.utf8.csv : data-raw/AHR_BookAuthors_Reviewers.csv
	mkdir -p data
	iconv -f latin1 -t utf8 $^ > $@

clobber :
	rm -f data/ahr.utf8.csv
