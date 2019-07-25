class EncounterController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  before_action :set_encounter, only: [:show,:edit,:update]
  before_action :is_signed_in, only: [:new,:edit,:create,:update,:my_encounters]
  before_action :authorized, only: [:edit,:update]
  def show
    @location = Location.find(@encounter.location_id)
    @user = @encounter.user_id ? User.find(@encounter.user_id) : nil
    @specie = Specie.find(@encounter.specie_id)
  end
  def new
    @address = params[:address]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
  end
  def create
    return_path = new_encounter_path
    @location = location_create return_path
    if @location != nil
      @specie = specie_create return_path
      if @specie != nil
        begin
          @encounter = Encounter.create(date: Date.parse(params[:date]), description: params[:description], location_id: @location.id, specie_id: @specie.id, user_id: current_user.id)
          if @encounter.save
            redirect_to encounter_path(@encounter.id), alert: "Successfully created encounter."
          else
            redirect_to return_path, alert: @encounter.errors.values.first.first
          end
        rescue
          redirect_to return_path, alert: "Must enter in a valid date in the correct format. MM/DD/YYYY."
        end
      end
    end
  end
  def edit
    @location = Location.find(@encounter.location_id)
    @specie = Specie.find(@encounter.specie_id)
  end
  def update
    return_path = edit_encounter_path(id: @encounter.id)
    @location = location_create return_path
    if @location != nil
      @specie = specie_create return_path
      if @specie != nil
        if @encounter.update_attributes(encounter_params)
          @encounter.update_attribute("specie_id",@specie.id)
          @encounter.update_attribute("location_id",@location.id)
          redirect_to encounter_path(@encounter.id), alert: "The encounter has been updated successfully."
        else
          redirect_to edit_encounter_path(return_path), alert: @encounter.errors.values.first.first
        end
      end
    end
  end
  def my_encounters
    @encounters = Encounter.where("user_id = #{current_user.id}")
  end
  def user_encounters
    @user = User.find(params[:user])
    @encounters = Encounter.where("user_id = #{params[:user]}")
  end
  def get_by_date
    @date = params[:date]
    @encounters = Encounter.where("date = '#{params[:date]}'")
  end
  def get_by_range
    @start = params[:start]
    @end = params[:end]
    @encounters = Encounter.date_range(params[:start],params[:end])
    @month = (@encounters.first.get_month[:start].to_s == @start && @encounters.first.get_month[:end].to_s == @end) ? "#{@start.split('-')[1]}/#{@start.split('-')[0]}" : false
  end
  def location_create return_path
    @location = Location.create(address: params[:address],city: params[:city], state: params[:state], country: params[:country], user_id: current_user.id)
    if @location.save
      return @location
    else
      if @location.errors.values.first.first == "This location already exists"
         @location = Location.where("city = '#{params[:city]}' AND address = '#{params[:address]}' And state = '#{params[:state]}'").first
         return @location
      else
        redirect_to return_path, alert: @location.errors.values.first.first
        return nil
      end
    end
  end
  def specie_create return_path
    puts "Error Found: #{params[:toggleSpecie] == nil}"
    if params[:toggleSpecie] != nil
      @specie = Specie.create(common: params[:common], scientific: params[:scientific], user_id: current_user.id)
      if @specie.save
        return @specie
      else
        if @specie.errors.values.first.first == "This specie is already in our system."
          return Specie.where("common = '#{params[:common]}' AND scientific = '#{params[:scientific]}'").first
        else
          redirect_to return_path, alert: @specie.errors.values.first.first
          return nil
        end
      end
    else
      @specie = Specie.find(params[:specie])
      if @specie != nil
       return @specie
      else
        redirect_to return_path, alert: "Could not find species."
      end
    end
  end
  def get_by_date_api
    @encounters = Encounter.date_range(params[:date],params[:date])
    render json: @encounters
  end
  def get_by_range_api
    @encounters = Encounter.date_range(params[:start],params[:end])
    render json: @encounters
  end
  def specie_geo_api
    @encounters = Encounter.find_by_sql("SELECT l.latitude, l.longitude, l.city, l.state, l.address, l.title, e.location_id, l.country, CONCAT(l.city, ', ', l.state, ', ', l.country) as full_address FROM encounters e JOIN species s ON e.specie_id = s.id JOIN locations l ON l.id = e.location_id WHERE e.specie_id = '#{params[:specie]}' GROUP BY e.location_id, l.latitude, l.longitude, l.city, l.state, l.address, l.title, l.country") 
    render json: @encounters
  end
  def get_encounters_time_graph_api
    @encounters = Encounter.find_by_sql("SELECT date_part('month', date) as month, COUNT(id) as encounter_count FROM encounters WHERE specie_id = #{params[:specie]} GROUP BY date_part('month', date) ORDER BY month ASC")
    render json:  @encounters
  end

  def csv_upload

  end

  def import_csv
    file = params[:file]
    months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    species = []
    encounters = []
    locations = []
    first = true
    successes = 0
    rows = 0
    errors = []
    begin
      CSV.foreach(file.path, headers: true) do |row|
        begin
          if !first
            cell = row[2]
            rows += 1
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
              found = true if x[:scientific_name] == specie.scientific || x[:common_name] == specie.common
            end
            exists = false
            l = location.split(",").length == 3 ? { city: location.split(",")[2].strip, state: location.split(",")[0].strip, country: "United States of America" } : { city: location.split(",")[3].strip, state: location.split(",")[1].strip, country: location.split(",")[0].strip }
            locations.each do |location|
              exists = true if l[:city].strip == location[:city].strip && location[:state] == l[:state].strip
            end
            Location.all.each do |location|
              exists = true if l[:city].strip == location.city.strip && location[:state] == l[:state].strip
            end
            e = { observations: row[3], date: date, location: l, specie: x }
            species.push(x) if !found || species.length + Specie.all.length == 0
            encounters.push(e)
            locations.push(l) if (!exists || locations.length + Location.all.length == 0)
        else
          first = false
        end
      rescue Exception => e
        puts "Error Message: #{e.message} - #{e.backtrace.inspect}"
        errors.push({ error: "The following row is formatted incorrectly.", row: row})
        puts "Error Found: #{row}"
      end
      end
    rescue Exception => e  
      puts "CSV Error: #{e}"
      errors.push({ error: "You must provide a valid CSV.", row: -1})
    end
    locations.each do |l|
      Location.create!(city: l[:city], state: l[:state], title: "Untitled", country: l[:country], address: "", user_id: 1)
    end
    species.each do |s,i|
      Specie.create!(scientific: s[:scientific_name], common: s[:common_name])
    end
    encounters.each do |e,i|
      loco = Location.where("city like '%#{e[:location][:city]}%'").first
      spec = Specie.where("scientific='#{e[:specie][:scientific_name]}'")
      if spec.length == 0
        spec = Specie.where("common='#{e[:specie][:common_name]}'")
      end
      spec = spec.first.id
      dupes = Encounter.all.to_a.rindex { |n| n.description == e[:observations] && n.specie_id = spec } != -1
      if dupes == nil
        loco.encounters.create!(description: e[:observations], date: e[:date], specie_id: spec)
        successes += 1
      else  
        errors.push({ error: "The following row is a duplicate encounter.", row: e.to_s})
      end
    end
    redirect_to encounter_csv_success_url(errors: errors.first(10), remainder: errors.length > 10 ? errors.length - 10 : 0), alert: "#{successes}/#{rows} of submitted encounters were uploaded successfully."
  end
  def csv_upload_success
    @errors = params[:errors]
    @remainder = params[:remainder]
  end
  def encounter_params
    params.permit(:description)
  end
  def set_encounter
    @encounter = Encounter.find(params[:id])
  end
  def is_signed_in
    redirect_to root_path, alert: "You must be logged in to perform this action." if current_user == nil
  end
  def authorized
    redirect_to root_path, alert: "You must be the owner of this content to perform this action." if !current_user.is_mine(@encounter)
  end
end
