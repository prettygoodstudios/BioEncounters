class Api::V1::SpeciesController < ApiController
  before_action :set_specie, only: [:show, :update]
  before_action :is_authenticated, only: [:create, :update]
  before_action :is_mine, only: [:update]


  def index
    render json: Specie.all
  end

  def show
    render json: @specie
  end

  def create
    @specie = Specie.new(specie_params)
    if @specie.save
      render json: @specie
    else
      render json: { errors: @specie.errors }
    end
  end

  def update
    if @specie.update_attributes(specie_params)
      render json: @specie
    else
      render json: { errors: @specie.errors }
    end
  end

  private
    def specie_params
      params.permit(:common, :scientific)
    end

    def set_specie
      @specie = Specie.find(params[:id])
    end

    def is_authenticated
      if !User.authenticate_via_token params[:email], params[:token]
        head(:unauthorized)
      else
        @user = User.where("email = '#{params[:email]}'").first
      end
    end

    def is_mine
      if !@user.is_mine @specie
        head(:unauthorized)
      end
    end
end
