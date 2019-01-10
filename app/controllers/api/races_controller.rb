module Api
  class RacesController < ApiController
    def index
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races"
      end
    end

    def show
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races/#{params[:id]}"
      end
    end

    def new
    end

    def edit
    end

    def create
      unless request.accept && request.accept != "*/*"
        render plain: :nothing, status: :ok
      end
    end

    def update
    end

    def destroy
    end
  end
end
