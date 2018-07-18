class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def index
    @locations = Location.order("ASCII(city)+ASCII(state)*10 ASC")
  end
  def show
    @location = Location.find(params[:id])
    @encounters = Encounter.find_by_sql("SELECT e.*, s.common FROM encounters e JOIN species s ON e.specie_id = s.id WHERE e.location_id = #{params[:id].to_s} ORDER BY e.date DESC")
  end
  def playground

  end
  def geo_json_api
    render json: Location.find_by_sql("SELECT l.*, COUNT(e.id) as pop FROM locations l LEFT JOIN encounters e ON e.location_id = l.id GROUP BY l.id").map { |l| {city: l.city, full_address: l.full_address, id: l.id, latitude: l.latitude, longitude: l.longitude, encounters: l.pop} }
  end
  def get_by_state
    @locations = Location.where("state = '#{params[:state]}'").order("city ASC")
  end
end
