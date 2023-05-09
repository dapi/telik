# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#

owner = User.
  create_with(
    telegram_data: {"id"=>"943084337",
     "username"=>"pismenny",
     "auth_date"=>"1683466550",
     "last_name"=>"Pismenny",
     "photo_url"=>"https://t.me/i/userpic/320/3CYhSyogI0OC2gV3vV5rziFJFXlsStR4yi692YM-rGU.jpg",
     "first_name"=>"Danil"}).
  find_or_create_by!(telegram_id: 943084337)

project = Project.
  create_with(
    telegram_group_id: -1001854699958,
    url: 'http://' + ENV.fetch('RAILS_DEVELOPMENT_HOST', 'localhost'),
  ).
  create_or_find_by!(
    owner: owner,
    host: ENV.fetch('RAILS_DEVELOPMENT_HOST', 'localhost'),
  )

Membership.find_or_create_by!(project: project, user: owner)
