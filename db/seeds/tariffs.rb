# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

Rails.logger.debug 'Create tariffes'
[
  {
    price: 0,
    title: 'Талантливый любитель',
    max_visitors_count: 100,
    max_operators_count: 1,
    custom_bot_allowed: false,
    transaction_mails_allowed: false,
    marketing_mails_allowed: false,
    details: <<~END
      <li>Бот – <%= h.link_to_bot %></li>
      <li>До 100 посетителей</li>
      <li>Один оператор</li>
    END
  },
  {
    price: 190,
    title: 'Находчивый предприниматель',
    max_visitors_count: 1000,
    max_operators_count: 3,
    custom_bot_allowed: true,
    transaction_mails_allowed: true,
    marketing_mails_allowed: false,
    details: <<END
    <li>Брендированное имя бота</li>
    <li>До 1 тыс. посетителей</li>
    <li>3 оператора</li>
    <li>Транзакционная рассылка</li>
END
  },
  {
    price: 1890,
    title: 'Успешный бизнес',
    max_visitors_count: 1000,
    max_operators_count: 5,
    custom_bot_allowed: true,
    transaction_mails_allowed: true,
    marketing_mails_allowed: true,
    details: <<END
    <li>Брендированное имя бота</li>
    <li>До 10 тыс. посетителей</li>
    <li>5 операторов</li>
    <li>Транзакционная и маркетинговая рассылка</li>
    <li>Поддержка в течении 24 часов</li>
END
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
