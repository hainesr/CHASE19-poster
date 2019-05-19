# Create a wordcloud from interview data
#
# Copyright (c) 2019, The University of Manchester, UK.
# Robert Haines
#
# Licence: BSD

data_dir=data
interviews_dir=${data_dir}/interviews

.PHONY: clean

WordCounts.txt: AllInterviews.txt ${data_dir}/stopwords.txt ${data_dir}/extra-stopwords.txt filter.rb
	ruby filter.rb $< $@

AllInterviews.txt: AllInterviews.pdf
	pdftotext $< $@

AllInterviews.pdf: ${interviews_dir}/Interview01.pdf
	pdfunite ${interviews_dir}/*.pdf $@

clean:
	rm -f WordCounts.txt AllInterviews.txt AllInterviews.pdf
