#This will be responsible for pulling information from the main page of wikipedia and pulling info from the articles themselves
class Scraper

  def self.scrape_main_page
    page = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Main_Page'))
  end

end