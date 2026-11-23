class TripsController < ApplicationController
  def new
    @trip = Trip.new
  end

  def create
  end

  def show
    @trip = Trip.find(params[:id])
  end
end
