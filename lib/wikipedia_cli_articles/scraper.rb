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
    paragraphs = []
    doc.css(".mw-parser-output").children.each do |child|
      if child.name == "p"
        paragraphs << child.text
      elsif child.name == "h2"
        page.sections.last.text = parse_paragraphs(paragraphs)
        paragraphs = []
        page.sections << Section.new
        page.sections.last.title = child.css(".mw-headline").text
      elsif child.name == "h3"
        paragraphs << "\n— #{child.css(".mw-headline").text} —"
      elsif child.name == "blockquote"
        paragraphs << "\n#{child.text}\n"
      elsif child.name == "ul"
        paragraphs << "#{child.text}\n"
      end
    end
    puts page.sections[2].text
    binding.pry
  end
  
  def self.parse_paragraphs(paragraphs)
    text = ""
    paragraphs.each do |paragraph|
      text = text + "#{paragraph}\n"
    end
    text
  end

end