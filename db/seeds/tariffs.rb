# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

Rails.logger.debug 'Create tariffes'
[
  {
    price: 0,
    title: '🧪 Талантливый экспериментатор',
    max_visitors_count: 100,
    max_operators_count: 1,
    custom_bot_allowed: false,
    transaction_mails_allowed: false,
    marketing_mails_allowed: false,
    button_title: 'Начать',
    details: <<~DETAILS
      <li>Бот – <%= h.link_to_bot %></li>
      <li>До 100 посетителей</li>
      <li>Один оператор</li>
    DETAILS
  },
  {
    price: 190,
    title: '🚀 Находчивый предприниматель',
    max_visitors_count: 1000,
    max_operators_count: 3,
    custom_bot_allowed: true,
    transaction_mails_allowed: true,
    marketing_mails_allowed: false,
    button_title: 'Поехали!',
    details: <<DETAILS
    <li>Брендированное имя бота</li>
    <li>До 1 тыс. посетителей</li>
    <li>3 оператора</li>
    <li>Транзакционная рассылка</li>
DETAILS
  },
  {
    price: 2500,
    title: '✊ Успешный бизнес',
    max_visitors_count: 1000,
    max_operators_count: 5,
    custom_bot_allowed: true,
    transaction_mails_allowed: true,
    marketing_mails_allowed: true,
    button_title: 'Погнали!',
    details: <<DETAILS
    <li>Брендированное имя бота</li>
    <li>До 10 тыс. посетителей</li>
    <li>5 операторов</li>
    <li>Транзакционная и маркетинговая рассылка</li>
    <li>Поддержка в течение 24 часов</li>
DETAILS
  }
].each_with_index do |item, index|
  tariff = Tariff
    .create_with(item)
    .find_or_create_by!(position: index)
  tariff.assign_attributes item
  tariff.save! if tariff.changed?
rescue StandardError => e
  Rails.logger.debug e
  Rails.logger.debug e.record.inspect
  raise e
end
