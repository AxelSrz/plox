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

def newSpecies(species)
  if directorioSpecies[species] == nil
    directorioSpecies[species] = Hash.new
  else
    abort("Error, species #{species} is alredy defined")
  end
end

def heirSpecies(father)
  if directorioSpecies[father] != nil
    directorioSpecies[$actualSpecies] = directorioSpecies[father].clone
  else
    abort("Error, '#{father}' father of species #{$actualSpecies} is not defined")
