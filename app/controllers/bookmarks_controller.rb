class BookmarksController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id])
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.trip = @trip

    if @bookmark.save
      render json: { id: @bookmark.id, name: @bookmark.name, description: @bookmark.description }
    else
      render json: { errors: @bookmark.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:name, :description)
  end
end
