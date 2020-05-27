User.create!(name: "example user",
             email: "example@railstutorial.org",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true,
             profile: "こんにちは、example userです。ライブに行くのが趣味です。")

9.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               profile: "こんにちは、#{name}です。ライブに行くのが趣味です。気軽 にフォローしてください！")
end

50.times do
  date = Faker::Date.between(from: 1.year.ago, to: 1.year.from_now)
  date < Date.current ? done = true : done = false
  User.find(1).events.create!(date: date,
                              name: Faker::Music.album,
                              content: Faker::Lorem.sentence,
                              place: Faker::Restaurant.name,
                              price: "2500円",
                              performer: Faker::Music.band,
                              public: true,
                              done:done)
end

50.times do
  date = Faker::Date.between(from: 1.year.ago, to: 1.year.from_now)
  date < Date.current ? done = true : done = false
  User.find(2).events.create!(date: date,
                              name: Faker::Music.album,
                              content: Faker::Lorem.sentence,
                              place: Faker::Restaurant.name,
                              price: "2500円",
                              performer: Faker::Music::RockBand.name,
                              public: true,
                              done:done)
end
