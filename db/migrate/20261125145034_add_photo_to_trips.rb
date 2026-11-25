class AddPhotoToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :photo_url, :string
    add_column :trips, :photo_credit, :string
  end
end
