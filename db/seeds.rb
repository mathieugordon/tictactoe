# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
u0 = User.create!(email: "computer@mailinator.com", password: "password", role: "computer", name: "Computer", profile_text: "Most Powerful Computer on Earth")
u1 = User.create!(email: "admin@mailinator.com", password: "password", role: "admin", name: "AdminGuy", profile_text: "admin profile")
u2 = User.create!(email: "bob@mailinator.com", password: "password", name: "BOB", profile_text: "bobs profile")
u3 = User.create!(email: "fred@mailinator.com", password: "password", name: "Freddy", profile_text: "fred is best")