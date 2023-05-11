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

begin
  Rails.logger.debug 'Create owner'
  owner = User
          .create_with(
            telegram_data: { 'id' => '943084337',
                             'username' => 'pismenny',
                             'auth_date' => '1683466550',
                             'last_name' => 'Pismenny',
                             'photo_url' => 'https://t.me/i/userpic/320/3CYhSyogI0OC2gV3vV5rziFJFXlsStR4yi692YM-rGU.jpg',
                             'first_name' => 'Danil' }
          )
          .find_or_create_by!(telegram_id: 943_084_337)

  Rails.logger.debug 'Create project'
  project = Project
            .create_with(
              telegram_group_id: -1_001_854_699_958,
              url: Rails.application.routes.url_helpers.root_url
            )
            .create_or_find_by!(
              owner:,
              host: Addressable::URI.parse(Rails.application.routes.url_helpers.root_url).host
            )

  Rails.logger.debug 'Create membership'
  Membership.find_or_create_by!(project:, user: owner)
rescue StandardError => e
  Rails.logger.debug e.record.inspect
  raise e
end
