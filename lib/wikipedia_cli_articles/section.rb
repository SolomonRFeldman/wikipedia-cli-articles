#Will have a section name to identify which section the user wants to read, and it will have a body text
class Section
  attr_accessor :title, :paragraphs

  def initialize
    @paragraphs = []
  end

end
