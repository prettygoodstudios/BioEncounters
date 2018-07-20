class Api::V1::LocationsController < ApiController
  before_action :set_location, only: [:show]
  def index
    render json: Location.all
  end
  def show
    render json: @location
  end
  def create
    @location = Location.build(location_params)
    if @location.save
      
    else

    end
  end
  private
    def location_params
      params.require(:location).permit(:title,:address,:city,:state,:country)
    end

    def set_location
      @location = Location.find(params[:id])
    end
end
