module Api
  class ResultsController < ApiController
    def index
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      end
    end

    def show
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
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
