# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module TradeStateMachine
  extend ActiveSupport::Concern
  included do
    state_machine initial: :parked do
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
