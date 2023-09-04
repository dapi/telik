# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class TariffDecorator < ApplicationDecorator
  delegate_all

  def price
    h.format_price(object.price == object.price.to_i ? object.price.to_i : object.price)
  end

  def details
    ERB.new(object.details).result(binding).html_safe
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
