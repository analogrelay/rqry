#!/usr/bin/ruby
require 'rubygems'
require 'hpricot'
require 'open-uri'

module HtmlScraper
	def HtmlScraper.scrape(input)
		doc = Hpricot(input)

		content = (doc/"body").inner_text 
		content.gsub!(/(<!\w+>)/, "")

		split_content = []
		content.split(/(\s|!|\?|\.|,|\\|\/|\+|=|\*)\s*/).each do |word|
			# Remove all other non-word characters
			word.gsub!(/(\W)/, "")
			word.strip!()
			split_content.push(word) if word.length > 0
		end

		return split_content, (doc/"title").inner_text
	end
end
