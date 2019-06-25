class Scraper

  def self.scrape_main_page
    page = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Main_Page'))
  end

  def self.scrape_article_page(article)
    if article.downcase.strip == "random"
      doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/Special:Random"))
    else
      doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{article}"))
    end
    page = Page.new
    page = self.parse_main_text(page, doc)
    page = self.parse_infobox(page, doc)
  end
  
  def self.parse_main_text(page, doc)
    page.title = doc.css("h1").text
    page.sections << Section.new
    page.sections.last.title = page.title
    page.sections.last.text = ""
    doc.css(".mw-parser-output").children.each do |child|
      if child.name == "p"
        page.sections.last.text = page.sections.last.text + child.text
      elsif child.name == "h2"
        page.sections << Section.new
        page.sections.last.title = child.css(".mw-headline").text
        page.sections.last.text = ""
      elsif child.name == "h3"
        page.sections.last.text = page.sections.last.text + "\n— #{child.css(".mw-headline").text} —\n"
      elsif child.name == "blockquote"
        child.text.end_with?("\n") ? page.sections.last.text = page.sections.last.text + "\n#{child.text}\n" : page.sections.last.text = page.sections.last.text + "\n#{child.text}\n\n"
      elsif child.name == "ul"
        page.sections.last.text = page.sections.last.text + "#{child.text}\n"
      elsif child.name == "ol"
        position = 0
        child.css("li").each do |child|
          if child.text.strip != ""
            position += 1
            page.sections.last.text = page.sections.last.text + "#{position}. #{child.text}\n"
          end
        end
      elsif child.values.any? { |value| value.include?("reflist") }
        position = 0
        child.css("ol").css("li").each do |child|
          position += 1
          page.sections.last.text = page.sections.last.text + "#{position}. #{child.css("cite").text}#{child.css("a").text}\n"
        end
      end
    end
    page
  end
  
  def self.parse_infobox(page, doc)
    page.infobox = Section.new
    page.infobox.title = "Infobox"
    page.infobox.text = ""
    doc.css(".infobox").css("tr").each do |child|
      if !child.children.any? { |children| 
        children.keys.include?("colspan") && !children.children.any? do |colspan_child| 
          colspan_child.name == "text" || (colspan_child.name == "a" && colspan_child.text != "") 
        end
      }
        index = 0
        child.children.each do |children|
          children.children.each do |text|
            if text.name == "br"
              page.infobox.text = page.infobox.text + ", "
            elsif text.css("ul").any?{ |value| value.name == "ul" }
              ul_list = text.css("ul").css("li")
              ul_list.each do |list|
                if ul_list.last == list
                  page.infobox.text = page.infobox.text + list.text
                else
                  page.infobox.text = page.infobox.text + "#{list.text}, "
                end
              end
            else
              page.infobox.text = page.infobox.text + text.text
            end
          end
          page.infobox.text = (page.infobox.text + ":  ") if index == 0 && child.children.size > 1 && children.text.strip != ""
          index += 1
        end
        page.infobox.text = page.infobox.text + "\n"
      end
    end
    page
  end

end