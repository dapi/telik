# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  env_prefix :telik
  attr_config(
    host: 'localhost',
    protocol: 'http',
    geo_lite_city_database: '/usr/share/GeoIP/GeoLiteCity.dat'
  )

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explicitly calling `instance`)
    delegate_missing_to :instance

    private

    # Returns a singleton config instance
    def instance
      @instance ||= new
    end
  end
end
