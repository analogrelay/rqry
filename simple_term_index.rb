class SimpleTermIndex
  attr_reader :term, :index_file_path

	def initialize(term, index_file_path)
		@index_file_path = index_file_path
		@index = {}
    @doc_count = 0
    @term = term
		if @index_file_path.file?
      loaded_doc_count = false
			@index_file_path.open "r" do |index_file|
  			index_file.each_line do |line|
          if loaded_doc_count
   					line.strip!
            segments = line.split(/:/)
            @index[segments[0]] = segments[1].to_i
          else
            @doc_count = line.to_i
          end
  			end
			end
		end
	end

	def save()
		@index_file_path.parent.mkdir unless @index_file_path.parent.directory?

		@index_file_path.open "w" do |term_file|
      term_file.write "#{@doc_count}\n"
			@index.each do |doc_id, occurrences|
				term_file.write "#{doc_id}:#{occurrences}\n"
			end
		end
	end

	def add_document(document)
    if @index.has_key? document
      @index[document.doc_id] += 1
    else
      @index[document.doc_id] = 1
    end
    @doc_count += 1
	end
end
