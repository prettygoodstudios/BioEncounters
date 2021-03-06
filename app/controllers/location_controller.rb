class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def index
    @locations = Location.find_by_sql("SELECT l.* FROM locations l LEFT JOIN encounters e ON e.location_id = l.id GROUP BY l.id HAVING COUNT(e.id) > 0 ORDER BY ASCII(city)+ASCII(state)*10 ASC")
  end
  def show
    @location = Location.friendly.find(params[:id])
    @encounters = Encounter.find_by_sql("SELECT e.*, s.common FROM encounters e JOIN species s ON e.specie_id = s.id WHERE e.location_id = #{@location.id.to_s} ORDER BY e.date DESC")
    @months = Encounter.get_time_graph('location', @location.id.to_s)
  end
  def playground

  end
  def geo_json_api
    render json: Location.find_by_sql("SELECT l.*, COUNT(e.id) as pop FROM locations l LEFT JOIN encounters e ON e.location_id = l.id GROUP BY l.id HAVING COUNT(e.id) > 0").map { |l| {city: l.city, full_address: l.full_address, id: l.id, latitude: l.latitude, longitude: l.longitude, encounters: l.pop, slug: l.slug} }
  end
  def get_by_state
    @locations = Location.where("state = '#{params[:state]}'").joins(:encounters).group('encounters.location_id, locations.id').having("COUNT(encounters.id) > 0").order("city ASC")
    @months = Encounter.get_time_graph('state', params[:state])
    @state = State.where("name = '#{params[:state]}'").first
  end
end
