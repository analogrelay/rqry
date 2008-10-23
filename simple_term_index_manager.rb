require 'simple_term_index.rb'
require 'pathname'

class SimpleTermIndexManager
	def initialize(db_directory)
		@db_directory = Pathname.new db_directory
		@db_directory.mkdir unless @db_directory.directory?
		@loaded_indices = {}
	end

	def get_index(term)
    term.downcase!
    unless @loaded_indices.has_key? term

  		# Is there a directory for the hash prefix?
  		term_prefix = term[0,1]
	  	term_bin = @db_directory + term_prefix
  		term_bin.mkdir unless term_bin.directory?
  
      # Find the term file
  		term_file = term_bin + "#{term}.idx"
  		@loaded_indices[term] = SimpleTermIndex.new term, term_file

    end
  
		return @loaded_indices[term]
	end

	def close_all()
		@loaded_indices.each_value do |index|
			index.save
		end
		@loaded_indices.clear
	end
end
	
