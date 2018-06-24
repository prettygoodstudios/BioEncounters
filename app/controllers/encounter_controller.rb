class EncounterController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def show
    @encounter = Encounter.find(params[:id])
    @location = Location.find(@encounter.location_id)
    @specie = Specie.find(@encounter.specie_id)
  end
end
