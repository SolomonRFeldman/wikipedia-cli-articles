#This will be responsible for pulling information from the main page of wikipedia and pulling info from the articles themselves
class Scraper

  def self.scrape_main_page
    page = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Main_Page'))
  end

  def self.scrape_article_page
    #doc.css("h1").text = title of page

    doc = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Flags_of_New_York_City'))
    page = Page.new
    page.title = doc.css("h1").text
    page.sections << Section.new
    page.sections.last.title = "Intro"
    puts page.sections.first.title
    binding.pry
  end
end