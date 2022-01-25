require "json"
require "open-uri"

# TODO - Let's fetch name and bio from a given GitHub username
url = "https://api.github.com/users/ssaunier"

user_serialized = URI.open(url).read # Returns a biiig String
user = JSON.parse(user_serialized) # Transform the String in a useful hash

puts "#{user["name"]} - #{user["bio"]}"
