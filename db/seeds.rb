# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Seed User
# user_attributes = [ 
#   { full_name: 'admin', email: 'admin@ilabsea.org', role: User::ROLE_ADMIN, full_name: "Admin", phone: "0975553553", password: "password" },
#   { full_name: 'normal', email: 'normal@ilabsea.org', role: User::ROLE_NORMAL, full_name: "Admin", phone: "0975553552", password: "password" }
# ]

# user_attributes.each do |attrs|
#   user = User.where(email: attrs[:email]).first_or_initialize
#   user.update_attributes(attrs)
#   user.save!
# end

# places = ["Asia", "South East Asia", "Africa", "Asia", "Cambodia", "Thailand", "Lao"]
# places.each do |place_name|
#   place = Place.where(name: place_name).first_or_initialize
#   place.update_attributes(name: place_name)
# end

# if Rails.env.development?
#   10.times.each do |i|
#     attrs = { full_name:  Faker::Name.name , email: Faker::Internet.email, phone: "#{Faker::Number.number(10)}" }
#     member = Member.where(email: attrs[:email]).first_or_initialize
#     member.update_attributes(attrs)
#   end

#   30.times.each do |i|
#     Keyword.find_or_create_by(name: Faker::Name.name)
#   end

#   10.times.each do |i|
#     attrs = { name:  Faker::Name.name , description: Faker::Name.name }
#     group = Group.where(name: attrs[:name]).first_or_initialize
#     group.update_attributes(attrs)
#   end
# end

