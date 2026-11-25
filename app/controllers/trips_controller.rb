class TripsController < ApplicationController
  FIRST_QUESTION = "Propose 5 points d'intérêt : 3 liés à mes centres d'intérêt et 2 incontournables de la destination."

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    @trip.fetch_photo
    if @trip.save
      response = RubyLLM.chat.with_instructions(@trip.instructions).ask(FIRST_QUESTION)
      Message.create(role: "assistant", content: response.content, trip: @trip)
      redirect_to trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @message = Message.new
  end

  def index
    @trips = Trip.all
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to trips_path, status: :see_other
  end

  private

  def trip_params
    params.require(:trip).permit(:title, :destination, :interests, :start_date, :end_date, :other)
  end
end
