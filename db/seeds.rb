# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_1 = User.create!(name: "Ricky LaFleur", email: "igotmy@grade10.com", google_id: "19023306", token: "fake_token_1")
user_2 = User.create!(name: "Bubbles", email: "catlover69@hotmail.com", google_id: "7357151", token: "fake_token_2")
user_3 = User.create!(name: "Jim Lahey", email: "supervisor@sunnyvale.ca", google_id: "83465653", token: "fake_token_3")
user_4 = User.create!(name: "Randy Bobandy", email: "assistantsupervisor@sunnyvale.ca", google_id: "52785579", token: "fake_token_4")
user_5 = User.create!(name: "Gon Freecss", email: "gon@hunterassociation.com", google_id: "58544636", token: "fake_token_5")
user_6 = User.create!(name: "Hisoka Morow", email: "hisoka.morow@meteorcity.gov", google_id: "91239464", token: "fake_token_6")
user_7 = User.create!(name: "Jenny", email: "jenny@tommytutone.com", google_id: "8675309", token: "fake_token_7")
user_8 = User.create!(name: "Lonely", email: "noposts@lonely.alone", google_id: "8675310", token: "fake_token_8")