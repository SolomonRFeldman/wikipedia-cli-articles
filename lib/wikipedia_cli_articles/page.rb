class WikipediaArticles::Page
  attr_accessor :title, :sections, :infobox
  
  @@all = []

  def initialize
    @sections = []
    @@all << self
  end

  def self.all
    @@all
  end
  
  def self.find_by_title(title)
    @@all.find do |page|
      page.title.downcase == title.downcase
    end
  end


end
