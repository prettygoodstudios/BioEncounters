class Api::V1::LocationsController < ApiController
  before_action :set_location, only: [:show, :update]
  before_action :is_authenticated, only: [:create, :update]
  before_action :is_mine, only: [:update]

  def index
    render json: Location.find_by_sql("SELECT l.*, COUNT(e.id) as pop FROM locations l LEFT JOIN encounters e ON e.location_id = l.id GROUP BY l.id").map { |l| {city: l.city, full_address: l.full_address, id: l.id, latitude: l.latitude, longitude: l.longitude, encounters: l.pop} }
  end
  def show
    l = @location
    render json: { city: l.city, full_address: l.full_address, id: l.id, latitude: l.latitude, longitude: l.longitude, encounters: l.encounters }
  end
  def create
    @location = Location.new(location_params)
    if @location.save
      render json: @location
    else
      render json: { errors: @location.errors}
    end
  end
  def update
    if @location.update_attributes(location_params)
      render json: @location
    else
      render json: {errors: @location.errors}
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
        head(:unauthorized)
      else
        @user = User.where("email = '#{params[:email]}'").first
      end
    end

    def is_mine
      if !@user.is_mine @location
        head(:unauthorized)
      end
    end
end
