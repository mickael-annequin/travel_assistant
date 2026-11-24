class MessagesController < ApplicationController
  def create # rubocop:disable Metrics/MethodLength
    @message = Message.new(message_params)
    @trip = Trip.find(params[:trip_id])
    @message.trip = @trip
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat.with_instructions(@trip.instructions)
      response = ruby_llm_chat.ask(@message.content)
      Message.create(role: "assistant", content: response.content, trip: @trip)
      redirect_to trip_path(@trip)
    else
      render trip_path(@trip), status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
