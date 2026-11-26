class Bookmark < ApplicationRecord
  belongs_to :trip
  validates :name, uniqueness: { scope: :trip_id }
end
