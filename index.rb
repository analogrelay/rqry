#!/usr/bin/ruby
require 'simple_term_index_manager.rb'
require 'term_database.rb'
require 'html_scraper.rb'
require 'stemmer.rb'

input_directory = Pathname.new ARGV[0]
db_directory = Pathname.new ARGV[1]

def each_file_rec(dir, &block)
  print "Processing Directory #{dir}\n"
  path = Pathname.new(dir)
  path.each_entry do |entry|
    abs_entry = path + entry
    unless entry.basename.to_s == "." || entry.basename.to_s == ".."
      each_file_rec(abs_entry.realpath, &block) if File.directory? abs_entry.realpath
      yield abs_entry if File.file? abs_entry.realpath
    end
  end
end

# Check arguments
if db_directory == nil or input_directory == nil then
	puts "Usage: index.rb input_directory db_directory"
	exit 0
end

Dir.mkdir(db_directory) unless File.directory? db_directory

# Open Term Database
db = TermDatabase.new(SimpleTermIndexManager.new(db_directory), db_directory + "docs.idx")

# Recurse over each file in the directory
each_file_rec(input_directory) do |file|
  print "Indexing... #{file}\n"
  File.open(file) do |f|
    scraped_input, title = HtmlScraper.scrape(f)
    scraped_input.each do |word|
      db.add_term(word.strip(), file.realpath, title)
    end
  end
end

db.close



