# frozen_string_literal: true

# Основная модель пользователя
#
class User < ApplicationRecord
  authenticates_with_sorcery!
end
