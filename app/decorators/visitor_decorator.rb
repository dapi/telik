# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Декоратор посетителя
#
class VisitorDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at updated_at topic_subject telegram_user user_data]
  end

  def topic_subject
    h.link_to object.topic_data.fetch('name'), object.topic_url, target: '_blank', rel: 'noopener'
  end

  def telegram_user
    h.link_to '@' + object.telegram_user.username, 'https://t.me/' + object.telegram_user.username, target: '_blank', rel: 'noopener'
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
