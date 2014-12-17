# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
u1 = User.create!(email: "admin@mailinator.com", password: "password", role: "admin", name: "AdminGuy", profile: "admin profile")
u2 = User.create!(email: "bob@mailinator.com", password: "password", name: "BOB", profile: "bobs profile")
u3 = User.create!(email: "fred@mailinator.com", password: "password", name: "Freddy", profile: "fred is best")