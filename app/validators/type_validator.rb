# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Модельный валиадатор на тип поля
#
class TypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not of class #{options[:with]}") unless value.is_a? options[:with]
  end
end
