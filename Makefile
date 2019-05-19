# Create a wordcloud from interview data
#
# Copyright (c) 2019, The University of Manchester, UK.
# Robert Haines
#
# Licence: BSD


interviews_dir=data/interviews

.PHONY: clean

FilteredInterviews.txt: AllInterviews.txt stopwords.txt extra-stopwords.txt filter.rb
	ruby filter.rb $< $@

AllInterviews.txt: AllInterviews.pdf
	pdftotext $< $@

AllInterviews.pdf: ${interviews_dir}/Interview01.pdf
	pdfunite ${interviews_dir}/*.pdf $@

clean:
	rm -f FilteredInterviews.txt AllInterviews.txt AllInterviews.pdf
