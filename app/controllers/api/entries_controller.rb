module Api
  class EntriesController < ApiController
    def index
      unless request.accept && request.accept != "*/*"
        render plain: "/api/racers/#{params[:racer_id]}/entries"
      end
    end

    def show
      unless request.accept && request.accept != "*/*"
        render plain: "/api/racers/#{params[:racer_id]}/entries/#{params[:id]}"
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
