# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
15.times do |n|
  name = Faker::Games::Pokemon.name
  email = Faker::Internet.email
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               )
end

15.times do |n|
  name = Faker::Lorem.word
  user_id = rand(2..16)
  Label.create!(name: name, user_id: user_id)
end

15.times do |n|
  title = Faker::Lorem.word
  content = Faker::Lorem.sentence
  deadline = Faker::Time.between(from: DateTime.current + 3, to: DateTime.current + 30)
  status = rand(3)
  priority = rand(3)
  user_id = rand(2..16)
  label_ids = [ rand(1..15) ]
  Task.create!(title: title,
              content: content,
              deadline: deadline,
              status: status,
              priority: priority,
              user_id: user_id,
              label_ids: label_ids
              )
end

User.create!(name: "fuga",
              email: "fuga@example.com",
              password: "111111",
              password_confirmation: "111111",
              admin: true
              )
