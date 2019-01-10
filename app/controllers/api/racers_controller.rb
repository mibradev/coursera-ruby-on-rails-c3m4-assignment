module Api
  class RacersController < ApiController
    def index
      unless request.accept && request.accept != "*/*"
        render plain: "/api/racers"
      end
    end

    def show
      unless request.accept && request.accept != "*/*"
        render plain: "/api/racers/#{params[:id]}"
      end
    end

    def new
    end

    def edit
    end

    def create
    end

    def update
    end

    def destroy
    end
  end
end
