require "json"

# TODO - let's read/write data from beatles.json
filepath = "data/beatles.json"

# PARSING
serialized_beatles = File.read(filepath) # Returns a biiig String
beatles = JSON.parse(serialized_beatles) # Transform the String in a useful hash

# STORING
beatles = { beatles: [
  {
    first_name: "John",
    last_name: "Lennon",
    instrument: "Guitar"
  },
  {
    first_name: "Paul",
    last_name: "McCartney",
    instrument: "Bass Guitar"
  }
]}

File.open(filepath, "wb") do |file| # 'wb' stands for writting binary; this means you overwriting the file
  file.write(JSON.generate(beatles))
end

# JSON.generate(beatles) : takes a Hash and transforms it into a biig String
# # This is going to be used to create the JSON file
