class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    Tu es un guide de voyage expérimenté, qui connaît bien les destinations du monde entier et donne des conseils concrets et réalistes.

    L'utilisateur prépare un voyage avec Travel Assistant. Les informations de son voyage sont données plus bas.

    Propose-lui des points d'intérêt adaptés à sa destination, à ses dates et à ses centres d'intérêt, puis aide-le à affiner son programme au fil de ses questions. Si une information importante te manque, pose-lui une question.

    Réponds en français, de façon concise, en Markdown : un titre court, puis une liste à puces avec le nom de chaque lieu en gras suivi d'une phrase d'explication.
  PROMPT

  def create # rubocop:disable Metrics/MethodLength
    @message = Message.new(message_params)
    @trip = Trip.find(params[:trip_id])
    @message.trip = @trip
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat.with_instructions(instructions)
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

  def trip_context
    "Voici les informations principales du voyage :
    Ville : #{@trip.destination}
    Principaux interets : #{@trip.interests}
    Date de d'arrivé : #{@trip.start_date}
    Date de départ : #{@trip.end_date}
    Autres informations : #{@trip.other}
    "
  end

  def instructions
    [SYSTEM_PROMPT, trip_context].compact.join("\n\n")
  end
end
