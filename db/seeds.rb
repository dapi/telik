# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#

require './db/seeds/openbill.rb'
Rake::Task['seed:blockchains'].invoke
Rake::Task['seed:currencies'].invoke

telegram_user_id = 943_084_337
TelegramUser.find_or_create_by!(id: telegram_user_id)
begin
  puts 'Create owner'
  owner = User
          .create_with(
            super_admin: true,
            telegram_data: { 'id' => telegram_user_id,
                             'username' => 'bob',
                             'auth_date' => '1683466550',
                             'last_name' => 'bobby',
                             'photo_url' => 'https://',
                             'first_name' => 'bob' }
          )
          .create_or_find_by!(telegram_user_id: telegram_user_id)

rescue StandardError => e
  binding.pry if Rails.env.development?
  puts e
  Rails.logger.debug e.record.inspect
  raise e
end

