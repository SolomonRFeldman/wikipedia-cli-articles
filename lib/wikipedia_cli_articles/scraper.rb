#This will be responsible for pulling information from the main page of wikipedia and pulling info from the articles themselves
class Scraper

  def self.scrape_main_page
    page = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Main_Page'))
  end

  def self.scrape_article_page(article)
    #doc.css("h1").text = title of page
    if article.downcase.strip == "random"
      doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/Special:Random"))
    else
      doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{article}"))
    end
    page = Page.new
    page.title = doc.css("h1").text
    page.sections << Section.new
    page.sections.last.title = page.title
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
        paragraphs << "\n— #{child.css(".mw-headline").text} —\n"
      elsif child.name == "blockquote"
        child.text.end_with?("\n") ? paragraphs << "\n#{child.text}\n" : paragraphs << "\n#{child.text}\n\n"
      elsif child.name == "ul"
        paragraphs << "#{child.text}\n"
      elsif child.values.any? { |value| value.include?("reflist") }
        position = 0
        child.css("ol").css("li").each do |child|
          position += 1
          paragraphs << "#{position}. #{child.css("cite").text}#{child.css("a").text}\n"
        end
      end
    end
    page
  end
  
  def self.parse_paragraphs(paragraphs)
    text = ""
    paragraphs.each do |paragraph|
      text = text + "#{paragraph}"
    end
    text
  end

end