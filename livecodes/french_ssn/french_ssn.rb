require 'date'
require 'yaml'

# BUILDING THE PATTERN
  # We are using capture groups so we can access the data matched with the pattern:
  # # We are naming the groups using (?<name_of_the_group>), so code is more verbose

  # Using \A and \z to make sure the string only contain the SNN

  # GENDER
  # Only accepting 1 or 2 (for 'man' or 'woman ')
  # For that we are using the litteral range [12] (alternativelly, we could've use (1|2))
  # After it, we are accepting 0 or 1 blank spaces => \s?

  # YEAR
  # Can be any couple of digits, including 00
  # Any digit => \d
  # Two times => {2}

  # MONTH
  # We just want to accept numbers from 01 to 12
  # For that,
  # - we accept a 0 followed by a digit from 1 to 9 (we can't accept 00)
  # - OR
  # - a 1 followed by 0, 1 or 2
  # The result is (0[1-9]|1[0-2])

  # ZIP CODE
  # We want to accept number from 01 to 99
  # For that,
    # - 0 followed by a digit from 1 to 9
    # - OR
    # - a digit from 1 to 9, followed by any digit
  # The result is (0[1-9]|[1-9]\d)

  # RANDOM DIGITS
  # Just need to make sure we accept the blank spaces in right places and that there are 6 digits
  # \d{3}\s?\d{3}\s?

  # KEY
  # Any two digits => \d{2}
#

PATTERN = /^(?<gender>[12])\s?(?<year>\d{2})\s?(?<month>0[1-9]|1[0-2])\s?(?<zip_code>0[1-9]|[1-9]\d)\s?\d{3}\s?\d{3}\s?(?<key>\d{2})$/

def french_ssn_info(ssn)
  # Using the #match method to get a MatchData object (that contains the information of the capture groups)
  match = ssn.match(PATTERN)

  # Check if the SSN is valid. Can be invalid by:
    # - The string does not match the pattern
    # - The key-math is not valid (we created a #valid_code? method for this: see line 100)
  #

  if match && valid_code?(ssn)

    # CREATING THE STRING
    # We have the info in the format of numbers
    # We want to change the format so we can return a string like "a man, born in December, 1984 in Seine-Maritime."

    # GENDER
    # Transform '1' into 'man' and '2' into 'woman'
    # See the method #gender in line 91
    gender = gender(match)

    # MONTH
    # Using the constant Date::MONTHNAMES which is an array like [nil, 'January', 'February', ... , 'December']
    # Accessing the array by the index (which we get from the MatchData => match[:month])
    month = Date::MONTHNAMES[match[:month].to_i]

    # YEAR
    # Simple: Just adding the 19 before the rest of the number
    year = "19#{match[:year]}"

    # ZIP_CODE
    # Every departament has a number, and we have a .yml file that give us all the data we need
    # With the YAML library (see line 2), we can parse this file into a hash with the method YAML.load_file
    # We are reading the value of the key match[:zip_code] in the yaml_hash
    yaml_hash = YAML.load_file('data/french_departments.yml')
    zip_code = yaml_hash[match[:zip_code]]

    # Interpolate all the data
    "a #{gender}, born in #{month}, #{year} in #{zip_code}."
  else
    'The number is invalid'
  end
end

private

def gender(match)
  case match[:gender]
  when '1'
    'man'
  when '2'
    'woman'
  end
end

# (97 subtracted by the SSN number without the key) divided by 97, should have a reminder equal to the key itself
def valid_code?(ssn)
  key = ssn[-2..-1].to_i # The last 2 digits of the ssn, to an integer
  ssn_without_key = ssn[0..-3] # The ssn, without the last 2 digits
  ssn_int = ssn_without_key.gsub(/\s/, '').to_i
  (97 - ssn_int) % 97 == key
end

p french_ssn_info("1 84 12 76 451 089 46")
