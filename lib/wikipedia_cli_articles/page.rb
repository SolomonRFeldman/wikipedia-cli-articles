#Going to have a "sidebox" containing basic info, and will have a list of sections to pick from
class Page
  attr_accessor :title, :intro, :sections
  
  def initialize
    @sections = []
  end

end
