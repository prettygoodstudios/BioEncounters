class AdminController < ActionController::Base
  protect_from_forgery with: :exception
  def upload_csv

  end
  def success
    @species = Specie.all.order("common DESC")
    @locations = Location.all.order("city DESC")
  end
  def import_csv
    file = params[:file]
    months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    species = []
    encounters = []
    locations = []
    first = true
    CSV.foreach(file.path, headers: true) do |row|
      begin
        if !first
           cell = row[2]
           location = ""
           date = ""
           monthFormat = false
           months.each do |month|
             if cell.include? month
               vals = cell.split(month)
               location = vals[0]
               date = month + vals[1]
               monthFormat = true
             end
           end
           if !monthFormat
             firstStr = false
             segs = cell.split("/")
             month = months[segs[0].split(" ").last.to_i]
             day = segs[1]
             year = segs[2]
             date = [month,day,year].join(" ")
             temp = segs[0].split(" ")
             temp.pop
             fin = temp.join(" ")
             location = fin
           end
           found = false
           x = { common_name: row[0], scientific_name: row[1] }
           species.each do |specie|
             found = true if x == specie
           end
           Specie.all.each do |specie|
             found = true if x[:scientific_name] == specie.scientific
           end
           exists = false
           l = { city: location.split(",")[2].strip, state: location.split(",")[0].strip, country: "United States of America" }
           locations.each do |location|
             exists = true if l[:city].strip == location[:city].strip
           end
           Location.all.each do |location|
             exists = true if l[:city].strip == location.city.strip
           end
           e = { observations: row[3], date: date, location: l, specie: x }
           species.push(x) if !found || species.length + Specie.all.length == 0
           encounters.push(e)
           locations.push(l) if !exists || locations.length + Location.all.length == 0
       else
         first = false
       end
     rescue Exception => e
       puts "Error Message: #{e.message}"
       puts "Error Found: #{row}"
     end
    end
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
    redirect_to "/admin/success"
  end
end
