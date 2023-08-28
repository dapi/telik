# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Декоратор посещения
class VisitDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at region_and_country referrer page_data visit_data user_data]
  end
end
