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
    doc.css(".mw-parser-output").children.each do |child|
      if child.name == "p"
        page.sections.last.paragraphs << child.text
      elsif child.name == "h2"
        page.sections << Section.new
        page.sections.last.title = child.css(".mw-headline").text
      elsif child.name == "blockquote"
        page.sections.last.paragraphs << ""
        page.sections.last.paragraphs << child.css("p").text
        page.sections.last.paragraphs << ""
      end
    end
    page.sections[2].paragraphs.each do |paragraph|
      puts paragraph
    end
    binding.pry
  end

end