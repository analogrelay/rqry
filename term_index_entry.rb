class TermIndexEntry
  attr_accessor :term, :frequency
  def initialize(term, frequency)
    @term = term
    @frequency = frequency
  end
end

