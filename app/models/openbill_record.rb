# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Базовая модель для openbill-моделей
class OpenbillRecord < ApplicationRecord
  self.abstract_class = true

  # def self.model_name
  # ActiveModel::Name.new(self, nil, name.gsub('Openbill', ''))
  # end
end
