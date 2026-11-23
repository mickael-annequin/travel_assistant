class Addcolumnstotrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :title, :string
    add_column :trips, :destination, :string
    add_column :trips, :interests, :string
    add_column :trips, :start_date, :date
    add_column :trips, :end_date, :date
    add_column :trips, :other, :string
  end
end
