# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
u0 = User.create!(email: "computer@mailinator.com", password: "password", role: "computer", name: "Computer", profile_text: "Most Powerful Computer on Earth", remote_user_image_url: "http://i.imgur.com/jpE8bEJ.gif")
u1 = User.create!(email: "admin@mailinator.com", password: "password", role: "admin", name: "Admin", profile_text: "Best Admin on Earth", remote_user_image_url: "http://i.imgur.com/jpE8bEJ.gif")