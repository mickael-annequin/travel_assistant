class Trip < ApplicationRecord
  require "open-uri"
  require "json"
  belongs_to :user
  has_many :messages, dependent: :destroy

  SYSTEM_PROMPT = "
    Tu es un guide de voyage expérimenté, qui connaît bien les destinations du monde entier et donne des conseils concrets et réalistes.\n\n
    L'utilisateur prépare un voyage avec Travel Assistant. Les informations de son voyage sont données plus bas.\n\n
    Propose-lui des points d'intérêt adaptés à sa destination, à ses dates et à ses centres d'intérêt, puis aide-le à affiner son programme au fil de ses questions. Si une information importante te manque, pose-lui une question.\n\n
    Réponds en français, de façon concise, en Markdown : un titre court, puis une liste à puces avec le nom de chaque lieu en gras suivi d'une phrase d'explication.
  "

  def context
    <<~CONTEXT
      Voici le voyage de l'utilisateur :
      - Titre : #{title}
      - Destination : #{destination}
      - Dates : du #{start_date} au #{end_date}
      - Centres d'intérêt : #{interests}
      - Autres précisions : #{other}
    CONTEXT
  end

  def instructions
    [SYSTEM_PROMPT, context].join("\n\n")
  end

  def fetch_photo
    query = URI.encode_www_form_component(destination)
    url = "https://api.unsplash.com/search/photos?query=#{query}&per_page=1&orientation=landscape&client_id=#{ENV.fetch(
      'UNSPLASH_ACCESS_KEY'
)}"
    data = JSON.parse(URI.open(url).read)
    photo = data["results"].first
    return if photo.nil?

    self.photo_url = photo["urls"]["regular"]
    self.photo_credit = photo["user"]["name"]
  rescue OpenURI::HTTPError
    nil
  end
end
