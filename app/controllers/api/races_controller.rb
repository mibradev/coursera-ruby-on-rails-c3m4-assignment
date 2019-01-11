module Api
  class RacesController < ApiController
    before_action :set_race, only: [:edit, :update, :destroy]

    rescue_from Mongoid::Errors::DocumentNotFound do
      render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
    end

    rescue_from ActionController::UnknownFormat do |exception|
      render plain: "woops: we do not support that content-type[#{request.accept}]", status: :unsupported_media_type
    end

    def index
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
      end
    end

    def show
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races/#{params[:id]}"
      else
        respond_to do |format|
          @race = Race.where(id: params[:id]).first

          if @race
            format.json { render :show }
            format.xml { render :show }
          else
            format.json { render :error_msg, status: :not_found }
            format.xml { render :error_msg, status: :not_found }
          end
        end
      end
    end

    def new
    end

    def edit
    end

    def create
      unless request.accept && request.accept != "*/*"
        race_name = params[:race][:name] if params[:race]
        render plain: race_name, status: :ok
      else
        @race = Race.new(race_params)
        render plain: @race.name, status: :created if @race.save
      end
    end

    def update
      if @race.update(race_params)
        render json: @race
      end
    end

    def destroy
      @race.destroy
      render nothing: true, status: :no_content
    end

    private
      def set_race
        @race = Race.find(params[:id])
      end

      def race_params
        params.require(:race).permit(:name, :date)
      end
  end
end
