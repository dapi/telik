# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Конечный автомат для сделки
module TradeStateMachine
  extend ActiveSupport::Concern
  included do
    state_machine initial: :proposed do
      event :accept do
        transition proposed: :wait_for_payment
      end
      # before_transition :parked => any - :parked, :do => :put_on_seatbelt
      # after_transition any => :parked do |vehicle, transition|
      # vehicle.seatbelt = 'off'
      # end
      # around_transition :benchmark

      # event :ignite do
      # transition :parked => :idling
      # end

      # state :first_gear, :second_gear do
      # validates :seatbelt_on, presence: true
      # end
    end
  end
end
