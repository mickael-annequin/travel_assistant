class TripsController < ApplicationController
  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user

    if @trip.save
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

  private

  def trip_params
    params.require(:trip).permit(:title, :destination, :interests, :start_date, :end_date, :other)
  end
end
