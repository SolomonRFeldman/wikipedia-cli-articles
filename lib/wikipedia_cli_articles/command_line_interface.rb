#This will be the CLI which will display information and deal with the logic of user input

class WikipediaArticles::CLI
  
  def initialize
    puts "Welcome to the Wikipedia CLI Article Viewer"
    # Scraper.scrape_main_page
    article = get_article_url
    page = Scraper.scrape_article_page(article)
    puts page.sections[0].title
    puts page.sections[0].text.lstrip
    puts "— Contents —"
    page.sections.each { |section| puts section.title }
  end
  
  def get_article_url
    valid = false
    while valid == false
      article = gets.strip
      article.gsub!(' ', '_')
      begin 
        open("https://en.wikipedia.org/wiki/#{article}")
        valid = true
      rescue
        puts "Please enter a valid article name."
      end
    end
    article
  end

end
	