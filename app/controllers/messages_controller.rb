class MessagesController < ApplicationController
  def create # rubocop:disable Metrics/MethodLength
    @message = Message.new(message_params)
    @trip = current_user.trips.find(params[:trip_id])
    @message.trip = @trip
    @message.role = "user"

    if @message.save
      @assistant_message = Message.create(role: "assistant", content: "", trip: @trip)
      response = ask_llm
      @assistant_message.update(content: response.content)
      broadcast_replace(@assistant_message)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to trip_path(@trip) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form",
                                                                            locals: { trip: @trip, message: @message })
        end
        format.html { render "trips/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def build_conversation_history
    @trip.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(@trip, target: helpers.dom_id(message), partial: "messages/message",
                                                      locals: { message: message })
  end

  def ask_llm
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    @ruby_llm_chat.with_instructions(@trip.instructions)
    @ruby_llm_chat.ask(@message.content) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end
end
