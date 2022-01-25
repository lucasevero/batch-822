require "open-uri"
require "nokogiri"

# Let's scrape recipes from https://www.bbcgoodfood.com

ingredient = "chocolate"
url = "https://www.bbcgoodfood.com/search/recipes?q=#{ingredient}"

html_file = URI.open(url).read # Goes in the internet and fetches the html file from the url
html_doc = Nokogiri::HTML(html_file) # Parses the file into a useful Nokogiri object

html_doc.search(".standard-card-new__article-title").each do |element|
  p element.text.strip # Returns the text of the element with surrounding whitespaces
  p element.attribute("href").value # Returns the value of the 'href' attribute (which is a url)
end
