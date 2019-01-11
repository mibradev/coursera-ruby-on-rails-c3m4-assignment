module Api
  class ResultsController < ApiController
    def index
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      else
        @race = Race.find(params[:race_id])
        @entrants = @race.entrants
      end
    end

    def show
      unless request.accept && request.accept != "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else
        respond_to do |format|
          @race = Race.where(id: params[:race_id]).first
          @result = @race.entrants.where(id: params[:id]).first if @race

          format.json { render :show } if @result
        end
      end
    end

    def new
    end

    def edit
    end

    def create
    end

    def update
      result = params[:result]

      if result
        entrant = Race.find(params[:race_id]).entrants.find(params[:id])

        if result[:swim]
          entrant.swim = entrant.race.race.swim
          entrant.swim_secs = result[:swim].to_f
        end

        if result[:t1]
          entrant.t1 = entrant.race.race.t1
          entrant.t1_secs = result[:t1].to_f
        end

        if result[:bike]
          entrant.bike = entrant.race.race.bike
          entrant.bike_secs = result[:bike].to_f
        end

        if result[:t2]
          entrant.t2 = entrant.race.race.t2
          entrant.t2_secs = result[:t2].to_f
        end

        if result[:run]
          entrant.run = entrant.race.race.run
          entrant.run_secs = result[:run].to_f
        end

        render nothing: true if entrant.save
      end
    end

    def destroy
    end
  end
end
