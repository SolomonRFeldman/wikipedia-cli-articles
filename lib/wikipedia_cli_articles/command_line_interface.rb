#This will be the CLI which will display information and deal with the logic of user input

class WikipediaArticles::CLI
  
  def initialize
    puts "Welcome to the Wikipedia CLI Article Viewer"
    # Scraper.scrape_main_page
    article = ""
    while article.downcase != "exit"
      article = get_article_url
      if page = Page.find_by_title(article)
        displaypage(page)
      elsif article.downcase != "exit"
        page = Scraper.scrape_article_page(article)
        displaypage(page)
      end
    end
  end
  
  def get_article_url
    puts 'Please enter the name of a Wikipedia article or type "exit" to exit.'
    valid = false
    while valid == false
      article = gets.strip
      if article.downcase != "exit"
        article.gsub!(' ', '_')
        begin 
          if article.downcase == "main_page" || article == ""
            raise
          end
          open("https://en.wikipedia.org/wiki/#{article}")
          valid = true
        rescue
          puts "Please enter a valid article name."
        end
      else
        valid = true
      end
    end
    article
  end

  def displaypage(page)
    puts "\n#{page.sections[0].title}"
    puts page.sections[0].text.lstrip
    puts "\n Press Enter to continue to contents..."
    gets
    contents_page(page)
  end
  
  def contents_page(page)
    selection = nil
    while selection != "exit"
      puts "— Contents —"
      page.sections.each { |section| puts section.title }
      puts "\n" + 'Type the name of a section to view it, type "Infobox" to view the infobox, or type "exit" to view another article.'
      selection = gets.strip.downcase
      section_index = page.sections.index { |section| section.title.downcase == selection }
      while selection != "exit" && section_index == nil && selection != "infobox"
        puts "Enter a valid section name."
        selection = gets.strip.downcase
        section_index = page.sections.index { |section| section.title.downcase == selection }
      end
      if selection != "exit"
        if selection == "infobox"
          section_page(page.infobox)
        else
          section_page(page.sections[section_index])
        end
      end
    end
  end

  def section_page(section)
    puts "\n#{section.title}"
    puts section.text
    puts "\n Press Enter to go back to contents..."
    gets
  end

end
	