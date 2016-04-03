hh = Hash.new{|hash, key| hash[key] = Hash.new}

hh["variable"]["algo"] = 20
hh["variable"]["otro"] = Hash.new
hh["variable"]["otro"]["valor"] = 8
hh["variable"]["troll"] = hh["variable"]["otro"].clone
hh["variable"]["troll"]["vamo"] = "a calmarno"

puts hh["variable"]["algo"]
puts hh["variable"]["otro"]["el"] == nil
puts hh["variable"]["otro"]["valor"]
puts hh["variable"]["otro"]
puts hh["variable"]["troll"]

puts "---------------------------------"

$speciesBook = Hash.new
species = "Persona"
$speciesBook[species] = Hash.new
$speciesBook[species]["global"] = Hash.new
$speciesBook[species]["global"]["methods"] = Hash.new
$speciesBook[species]["global"]["variables"] = Hash.new
$actualSpecies = species
$actualFunction = "global"
puts $speciesBook
