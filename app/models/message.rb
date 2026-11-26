class Message < ApplicationRecord
  after_create_commit :broadcast_append_to_trip
  belongs_to :trip

  private

  def broadcast_append_to_trip
    broadcast_append_to trip, target: "messages", partial: "messages/message", locals: { message: self }
  end
end
