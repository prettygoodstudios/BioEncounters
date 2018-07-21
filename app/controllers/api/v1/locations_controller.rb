class Api::V1::LocationsController < ApiController
  before_action :set_location, only: [:show, :update]
  before_action :is_authenticated, only: [:create, :update]

  def index
    render json: Location.all
  end
  def show
    render json: @location
  end
  def create
    @location = Location.new(location_params)
    if @location.save
      render json: @location
    else
      render json: { error: @location.errors}
    end
  end
  def update
    if @location.update_attributes(location_params)
      render json: @location
    else
      render json: {error: @location.errors}
    end
  end
  private
    def location_params
      params.permit(:title,:address,:city,:state,:country,:user_id)
    end

    def set_location
      @location = Location.find(params[:id])
    end

    def is_authenticated
      if !User.authenticate_via_token params[:email], params[:token]
        redirect_to root_path, alert: "Must be authenticated to perform this action."
      end
    end
end
