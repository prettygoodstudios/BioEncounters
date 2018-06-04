# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
species = []
encounters = []
locations = []
first = true
User.create(email:"test@test.com",title:"Test Acount",password: "12345ghdk",display: "test")
CSV.foreach("/Users/admin/Downloads/bio.csv") do |row|
  if !first
     cell = row[2]
     location = ""
     date = ""
     months.each do |month|
       if cell.include? month
         vals = cell.split(month)
         location = vals[0]
         date = month + vals[1]
       end
     end
     found = false
     x = { common_name: row[0], scientific_name: row[1] }
     species.each do |specie|
       found = true if x == specie
     end
     exists = false
     l = { city: location.split(",")[2].strip, state: location.split(",")[0].strip, country: "United States of America" }
     locations.each do |location|
       exists = true if l == location
     end
     e = { observations: row[3], date: date, location: l, specie: x }
     species.push(x) if !found || species.length == 0
     encounters.push(e)
     locations.push(l) if !exists || locations.length == 0
 else
   first = false
 end
end
puts species
puts encounters
puts locations
locations.each do |l|
  Location.create!(city: l[:city], state: l[:state], title: "Untitled", country: l[:country], address: "", user_id: 1)
end
species.each do |s,i|
  Specie.create!(scientific: s[:scientific_name], common: s[:common_name])
end
encounters.each do |e,i|
  loco = Location.where("city like '%#{e[:location][:city]}%'").first
  spec = Specie.where("scientific='#{e[:specie][:scientific_name]}'").first.id
  loco.encounters.create!(description: e[:observations], date: e[:date], specie_id: spec)
end
