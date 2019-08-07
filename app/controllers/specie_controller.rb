class SpecieController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def index
    @species = Specie.all.order("common ASC")
  end
  def show
    @specie = Specie.friendly.find(params[:id])
    @locations = Location.joins(:encounters).where("encounters.specie_id = #{@specie.id}")
    @encounters = Encounter.where("specie_id = #{@specie.id.to_s}")
    @months = Encounter.get_time_graph('specie', @specie.id.to_s)
  end
end
