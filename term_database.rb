class DocumentEntry
  attr_accessor :path, :doc_id, :title
  def initialize(path, doc_id, title)
    @path = path
    @doc_id = doc_id
    @title = title
  end
end

class TermDatabase
	def initialize(index_manager, doc_db_file)
		@index_manager = index_manager
    @documents = {}
    @doc_count = 0
    @doc_db_file = doc_db_file

    if File.file? @doc_db_file
      File.open(@doc_db_file, "r") do |file|
        max_doc_id = 0
        file.each_line do |line|
          segments = line.split(/:/)
          doc_id = segments[0].to_i
          @documents[segments[1]] = DocumentEntry.new(segments[1], doc_id, segments[2])
          max_doc_id = doc_id if doc_id > max_doc_id
        end
        @doc_count = max_doc_id
      end
    end
	end

	def add_term(term, doc_path, doc_title)
		index = nil
		index = @index_manager.get_index term
    unless @documents.has_key? doc_path
      @doc_count += 1
      @documents[doc_path] = DocumentEntry.new(doc_path, @doc_count, doc_title)
    end
		index.add_document @documents[doc_path]
	end

	def close()
		@index_manager.close_all
    File.open(@doc_db_file, "w") do |file|
      @documents.each_value do |entry|
        title = entry.title
        file.write "#{entry.doc_id}:#{entry.path}:#{title}"
      end
    end
	end
end
