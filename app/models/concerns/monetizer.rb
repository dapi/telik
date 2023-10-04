module Monetizer
  def monetize(attr, value: , currency:)

    define_method attr do
      binding.pry
      Money.new()
    end
  end
end
