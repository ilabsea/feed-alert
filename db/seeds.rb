# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Seed User
user_attributes = { email: 'admin@ilabsea.org', first_name: "admin", last_name: "Admin", phone: "0975553553", password: "password" }
user = User.where(email: user_attributes[:email]).first_or_initialize
user.update_attributes(user_attributes.except(:email))
user.save!
