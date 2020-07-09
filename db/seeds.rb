[
  ['北海道', 43.06417, 141.34694],
  ['青森', 40.82444, 140.74],
  ['岩手', 39.70361, 141.1525],
  ["宮城", 38.26889, 140.87194],
  ["秋田", 39.71861, 140.1025],
  ["山形", 38.24056, 140.36333],
  ["福島", 37.75, 140.46778],
  ["茨城", 36.34139, 140.44667],
  ["栃木", 36.56583, 139.88361],
  ["群馬", 36.39111, 139.06083],
  ["埼玉", 35.85694, 139.64889],
  ["千葉", 35.60472, 140.12333],
  ["東京", 35.68944, 139.69167],
  ["神奈川", 35.44778, 139.6425],
  ["新潟", 37.90222, 139.02361],
  ["富山", 36.69528, 137.21139],
  ["石川", 36.59444, 136.62556],
  ["福井", 36.06528, 136.22194],
  ["山梨", 35.66389, 138.56833],
  ["長野", 36.65139, 138.18111],
  ["岐阜", 35.39111, 136.72222],
  ["静岡", 34.97694, 138.38306],
  ["愛知", 35.18028, 136.90667],
  ["三重", 34.73028, 136.50861],
  ["滋賀", 35.00444, 135.86833],
  ["京都", 35.02139, 135.75556],
  ["大阪", 34.68639, 135.52],
  ["兵庫", 34.69139, 135.18306],
  ["奈良", 34.68528, 135.83278],
  ["和歌山", 34.22611, 135.1675],
  ["鳥取", 35.50361, 134.23833],
  ["島根", 35.47222, 133.05056],
  ["岡山", 34.66167, 133.935],
  ["広島", 34.39639, 132.45944],
  ["山口", 34.18583, 131.47139],
  ["徳島", 34.06583, 134.55944],
  ["香川", 34.34028, 134.04333],
  ["愛媛", 33.84167, 132.76611],
  ["高知", 33.55972, 133.53111],
  ["福岡", 33.60639, 130.41806],
  ["佐賀", 33.24944, 130.29889],
  ["長崎", 32.74472, 129.87361],
  ["熊本", 32.78972, 130.74167],
  ["大分", 33.23806, 131.6125],
  ["宮崎", 31.91111, 131.42389],
  ["鹿児島", 31.56028, 130.55806],
  ["沖縄", 26.2125, 127.68111],
].each do |name, latitude, longitude|
  Geography.create!(name: name, latitude: latitude, longitude: longitude)
end

# User.create!(name: "example user",
#              email: "example@railstutorial.org",
#              password: "foobar",
#              password_confirmation: "foobar",
#              admin: true,
#              profile: "こんにちは、example userです。ライブに行くのが趣味です。",
#              agreement: true)

# 20.times do |n|
#   name = Faker::Name.name
#   email = "example-#{n+1}@example.org"
#   password = "password"
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password,
#                profile: "こんにちは、#{name}です。音楽が好きでライブに行くのが趣味です。もっと色んな音楽を知りたいので気軽にフォローしてください！",
#                agreement: true)
# end

# 30.times do
#   date = Faker::Time.between(from: DateTime.current.ago(1.year), to: DateTime.current.since(1.year)).change(hour: rand(17..20))
#   date < DateTime.current ? done = true : done = false
#   User.find(1).tickets.create!(date: date,
#                               name: Faker::Music.album,
#                               content: Faker::Lorem.sentence,
#                               place: Faker::Restaurant.name,
#                               price: "2500円",
#                               performer: Faker::Music.band,
#                               public: true,
#                               done:done)
# end

# 30.times do
#   date = Faker::Time.between(from: DateTime.current.ago(1.year), to: DateTime.current.since(1.year)).change(hour: rand(17..20))
#   date < DateTime.current ? done = true : done = false
#   User.find(2).tickets.create!(date: date,
#                               name: Faker::Music.album,
#                               content: Faker::Lorem.sentence,
#                               place: Faker::Restaurant.name,
#                               price: "2500円",
#                               performer: Faker::Music::RockBand.name,
#                               public: true,
#                               done:done)
# end

# users = User.all
# user  = users.first
# following = users[2..10]
# followers = users[3..10]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }
