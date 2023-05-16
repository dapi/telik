# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Добавляет в модель метод класса human_plural. Например
#
# User.human_plural
# => 'Люди'
module ActiveModel
  class Name # rubocop:disable Style/Documentation
    def human_plural
      human count: 100
    end
  end
end
