# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "Nettoyage de la base..."
# On détruit les enfants AVANT les parents :
# un message pointe vers un trip, un trip pointe vers un user (foreign keys).
Message.destroy_all
Trip.destroy_all
User.destroy_all

# ---------- USERS ----------
puts "Création des users..."
# Devise a besoin d'un email et d'un password (6 caractères minimum).
# create! (avec !) plante en affichant l'erreur si une validation bloque.
mickael = User.create!(
  email: "mickael@test.com",
  password: "azerty123",
  username: "mickael"
)

julie = User.create!(
  email: "julie@test.com",
  password: "azerty123",
  username: "julie"
)

# ---------- TRIPS ----------
puts "Création des trips..."
# start_date et end_date sont des colonnes :date → on donne de vraies dates, pas des strings.
lisbonne = Trip.create!(
  title: "Week-end à Lisbonne",
  destination: "Lisbonne, Portugal",
  interests: "street food, musées, points de vue",
  start_date: Date.new(2027, 3, 12),
  end_date: Date.new(2027, 3, 15),
  other: "Budget serré, je me déplace à pied et en tram",
  user: mickael
)

Trip.create!(
  title: "Road trip en Écosse",
  destination: "Highlands, Écosse",
  interests: "randonnée, châteaux, nature",
  start_date: Date.new(2027, 6, 1),
  end_date: Date.new(2027, 6, 10),
  other: "Chiens autorisés",
  user: mickael
)

Trip.create!(
  title: "Une semaine à Tokyo",
  destination: "Tokyo, Japon",
  interests: "gastronomie, temples, jeux vidéo",
  start_date: Date.new(2027, 10, 4),
  end_date: Date.new(2027, 10, 11),
  other: "Premier voyage en Asie",
  user: julie
)

# ---------- MESSAGES ----------
# ⚠️ Ne marche qu'une fois la colonne trip_id ajoutée à la table messages.
puts "Création des messages..."
# De faux messages pour tester l'affichage du chat sans appeler l'IA (pas de tokens dépensés).
Message.create!(
  role: "user",
  content: "Quels quartiers visiter en priorité ?",
  trip: lisbonne
)

Message.create!(
  role: "assistant",
  content: "Pour un premier séjour, commence par **l'Alfama** (ruelles, miradouros) et **le Bairro Alto** pour le soir. Le tram 28 relie les deux.",
  trip: lisbonne
)

puts "Terminé : #{User.count} users, #{Trip.count} trips, #{Message.count} messages."
