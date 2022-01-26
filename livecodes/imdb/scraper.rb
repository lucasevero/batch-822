require 'open-uri'
require 'nokogiri'
require 'yaml'


# STEPS
# Scrape the link to the movie's pages
def fetch_movies_url
  url = 'https://www.imdb.com/chart/top'
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)

  urls = []

  html_doc.search(".titleColumn a").first(5).each do |title|
    full_url = "https://www.imdb.com#{title.attribute("href").value}"
    urls << full_url
  end
  urls
end

# Scrape the info from the movies pages
def scrape_movie(url)
  html_file = URI.open(url, "Accept-Language" => "en-US").read
  html_doc = Nokogiri::HTML(html_file)

  # Create a Hash for each movie (with al the info we got)
  movie_hash = {}

  # 3 ACTORS
  actors = []
  html_doc.search(".StyledComponents__ActorName-sc-y9ygcu-1").first(3).each do |actor|
    actors << actor.text.strip
  end
  movie_hash[:cast] = actors

  # DIRECTOR
  html_doc.search(".ipc-metadata-list-item__label:contains('Director')").first(1).each do |director|
    director.parent.search(".ipc-metadata-list-item__list-content-item").each do |name|
      movie_hash[:director] = name.text.strip
    end
  end

  # STORYLINE
  html_doc.search(".GenresAndPlot__TextContainerBreakpointXL-sc-cum89p-2").each do |storyline|
    movie_hash[:storyline] = storyline.text.strip
  end

  # TITLE
  html_doc.search(".TitleHeader__TitleText-sc-1wu6n3d-0").each do |title|
    movie_hash[:title] = title.text.strip
  end

  # YEAR
  html_doc.search(".TitleBlockMetaData__ListItemText-sc-12ein40-2").first(1).each do |year|
    movie_hash[:year] = year.text.strip.to_i
  end

  movie_hash
end

# Get this movies together in a array
def build_array_of_movies
  arr = []
  urls = fetch_movies_url
  urls.each do |url|
    arr << scrape_movie(url)
  end
  arr
end

# Store the array in a .yml file
def store_movies_in_yaml(movies)
  File.open("movies.yml", "wb") do |file|
    file.write(build_array_of_movies.to_yaml)
  end
end

# Call the method
store_movies_in_yaml(build_array_of_movies)
