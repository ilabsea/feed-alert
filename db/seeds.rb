# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Seed User
user_attributes = [ 
  { user_name: 'admin', email: 'admin@ilabsea.org', role: User::ROLE_ADMIN, full_name: "Admin", phone: "0975553553", password: "password" },
  { user_name: 'normal', email: 'normal@ilabsea.org', role: User::ROLE_NORMAL, full_name: "Admin", phone: "0975553553", password: "password" }
]

user_attributes.each do |attrs|
  user = User.where(email: attrs[:email]).first_or_initialize
  user.update_attributes(attrs)
  user.save!
end

10.times.each do |i|
  attrs = { full_name:  Faker::Name.name , email: Faker::Internet.email, phone: "#{Faker::Number.number(10)}" }
  member = Member.where(email: attrs[:email]).first_or_initialize
  member.update_attributes(attrs)
end