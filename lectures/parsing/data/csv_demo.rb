require "csv"

# TODO - let's read/write data from beatles.csv
filepath = "data/beatles.csv"

# PARSING
# Without headers => row is a Array
CSV.foreach(filepath) do |row|
  puts "#{row[0]} #{row[1]}, that plays the #{row[2]}"
end

# With the first line as a header => row is a Hash
CSV.foreach(filepath, headers: :first_row) do |row|
  puts "#{row["First Name"]} #{row["Last Name"]}, that plays the #{row["Instrument"]}"
end

# STORING
beatles = [
  {
    first_name: "John",
    last_name: "Lennon",
    instrument: "Guitar"
  },
  {
    first_name: "Paul",
    last_name: "McCartney",
    instrument: "Bass"
  }
]

CSV.open(filepath, "wb") do |csv|
  csv << ["First Name", "Last Name", "Instrument"]
  beatles.each do |beatle|
    csv << [beatle[:first_name], beatle[:last_name], beatle[:instrument]]
  end
end
