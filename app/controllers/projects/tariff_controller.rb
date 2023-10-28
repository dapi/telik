# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Projects
  # Выбор и смена тарифа
  class TariffController < ApplicationController
    def show; end

    def update
      tariff = Tariff.find params[:tariff_id]
      project.update!(tariff:)
      flash.now[:notice] = 'Тариф сменён'
      render :show, status: :unprocessable_entity
    end
  end
end
