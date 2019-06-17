#This will be the CLI which will display information and deal with the logic of user input

class WikipediaArticles::CLI
  
  def initialize
    puts "Welcome to the Wikipedia CLI Article Viewer"
    # Scraper.scrape_main_page
    article = get_article_url
    page = Scraper.scrape_article_page(article)
    displaypage(page)
  end
  
  def get_article_url
    puts "Please enter the name of a Wikipedia article."
    valid = false
    while valid == false
      article = gets.strip
      article.gsub!(' ', '_')
      begin 
        if article.downcase == "main_page"
          raise
        end
        open("https://en.wikipedia.org/wiki/#{article}")
        valid = true
      rescue
        puts "Please enter a valid article name."
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
      puts "\n" + 'Type the name of a section to view it or type "exit" to exit.'
      selection = gets.strip.downcase
      section_index = page.sections.index { |section| section.title.downcase == selection }
      while selection != "exit" && section_index == nil
        puts "Enter a valid section name."
        selection = gets.strip.downcase
        section_index = page.sections.index { |section| section.title.downcase == selection }
      end
      if selection != "exit"
        section_page(page.sections[section_index])
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
	