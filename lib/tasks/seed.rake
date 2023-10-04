# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'yaml'

namespace :seed do
  desc 'Adds missing currencies to database defined at config/seed/currencies.yml.'
  task currencies: :environment do
    Currency.transaction do
      YAML.load_file(Rails.root.join('config/seed/currencies.yml')).each do |hash|
        hash['id'] = hash['id'].upcase
        puts hash['id']
        currency = Currency.find_by(id: hash.fetch('id'))
        if currency.present?
          currency.update! hash
        else
          Currency.create!(hash)
        end
      end
    end
  end

  desc 'Adds missing blockchains to database defined at config/seed/blockchains.yml.'
  task blockchains: :environment do
    Blockchain.transaction do
      YAML.load_file(Rails.root.join('config/seed/blockchains.yml')).each do |hash|
        next if Blockchain.exists?(key: hash.fetch('key'))

        Blockchain.create!(hash)
      end
    end
  end
end
