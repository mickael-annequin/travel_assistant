class BookmarksController < ApplicationController
  def create
    @trip = current_user.trips.find(params[:trip_id])
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.trip = @trip

    if @bookmark.save
      render json: { id: @bookmark.id, name: @bookmark.name, description: @bookmark.description }
    else
      render json: { errors: @bookmark.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @trip = @bookmark.trip
    return redirect_to trips_path, alert: "Action non autorisée" unless @trip.user == current_user

    @bookmark.destroy
    redirect_to trip_path(@trip), status: :see_other
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:name, :description)
  end
end
