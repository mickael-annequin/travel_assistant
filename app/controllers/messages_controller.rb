class MessagesController < ApplicationController
  def create # rubocop:disable Metrics/MethodLength
    @message = Message.new(message_params)
    @trip = Trip.find(params[:trip_id])
    @message.trip = @trip
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(@trip.instructions).ask(@message.content)
      @assistant_message = Message.create(role: "assistant", content: response.content, trip: @trip)
      redirect_to trip_path(@trip)
    else
      render "trip/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def build_conversation_history
    @trip.messages.each do |message|
      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end
end
