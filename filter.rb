# frozen_string_literal: true

# Create a wordcloud from interview data
#
# Copyright (c) 2019, The University of Manchester, UK.
# Robert Haines
#
# Licence: BSD

inputfile = ARGV[0]
outputfile = ARGV[1]
stopfile1 = 'stopwords.txt'
stopfile2 = 'extra-stopwords.txt'

# Load the text naively stripped from the PDFs.
input = File.read(inputfile)

# Load the stopwords files.
raw_stopwords = File.readlines(stopfile1) + File.readlines(stopfile2)
stopwords = raw_stopwords.map(&:chomp).delete_if do |line|
  line.start_with?('#')
end.sort

# First, fix the labeling error at the start of the first file.
input.sub!('P:', 'I1:')

# Remove odd characters, quotes and bracketed sections.
[
  "\f", '!', '?', '"', "'", '’', '--', '.', ',', '…', '*', ';',
  /\[[^\[]*\]/, /\([^(]*\)/
].each do |char|
  input.gsub!(char, '')
end

# Special treatment for dashes, so we don't lose hyphens, and we don't
# join words that shouldn't be joined.
[
  /([^\w])-(\w)/,    # e.g. 'word-' -> 'word'
  /(\w)-([^\w])/,    # e.g. '-word' -> 'word'
  /([^\w])-([^\w])/  # remove dashes in space, e.g. ' - '
].each do |sub|
  input.gsub!(sub, '\1\2')
end

# Normalize inconsistent labels.
input.gsub!('Person1:', 'I1:')
input.gsub!(/[^\n]\nPerson2:/, "\n\nP:")
input.gsub!('Person2:', 'P:')
input.gsub!(/I1 ?-/, "I1:\n\n")
input.gsub!(/[Pp] ?- /, "P:\n\n")
input.gsub!(/[^\n]\nI1:/, "\n\nI1:")

# Reformat into paragraphs with no empty lines.
input = input.split("\n").map { |line| line == '' ? "\n" : line }.join(' ').split("\n").map(&:strip).delete_if { |line| line == '' }

# Create a hash of interviewer and participant text.
output = { i: [], p: [] }
state = nil
input.each_slice(2) do |f, s|
  if f == 'I1:'
    # If the first of the pair is interviewer text, set state to :i and store.
    state = :i
    output[state] << s
  elsif f == 'P:'
    # Else if the first is participant text, set state to :p and store.
    state = :p
    output[state] << s
  elsif s == 'I1:' || s == 'P:'
    # Else if the second of the pair is a label then we need to store the first
    # as text grouped with whichever state we're already in.
    output[state] << f
  else
    # Else we have two bits of text, so store them in whichever state we're
    # already in.
    output[state] << f
    output[state] << s
  end
end

output = output[:p].join(' ').downcase.split

# Sanity check.
if output.include?('i1:') || output.include?('p:')
  warn 'Unexpected token in the filtered output'
end

# We can finally remove numbers safely.
output = output.map do |word|
  word.gsub(/[0-9]/, '')
end

# Remove stopwords and empty words.
output = output.delete_if do |word|
  stopwords.include?(word) || word.empty?
end

# Count duplicates and sort by count.
output = output.group_by(&:itself).transform_values(&:count).to_a.sort_by { |a| a[1] }.reverse

File.open(outputfile, 'w') do |out|
  output.each do |word, count|
    out.write "#{count} #{word}\n"
  end
end
