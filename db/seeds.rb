# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "Example User", email: "example@railstutorial.org",
password: "foobar", password_confirmation: "foobar", admin: true, activated: true, activated_at: Time.zone.now)
99.times do |n|
    name = Faker::Name.name
    email = "example_#{n+1}@railstutorials.org"
    password = "password"
    User.create(name: name, email: email, password: password, password_confirmation: password, activated: true, activated_at: Time.zone.now)
end
# Generate posts for 6 first users
users = User.order(:created_at).take(6)
20.times do
    content = Faker::Lorem.sentence(5)
    users.each do |user|
        user.microposts.create!(content: content)
    end
end
# Generate following relationship
users = User.all
user = users.first #the center of all this relationship chaos
following = users[2..50] #user will follow users w/ id 2 to 50
followers = users[3..40] #user will be follwed by users w/ id 3 to 40
following.each do |followed|
    user.follow(followed)
end
followers.each do |follower|
    follower.follow(user)
end
